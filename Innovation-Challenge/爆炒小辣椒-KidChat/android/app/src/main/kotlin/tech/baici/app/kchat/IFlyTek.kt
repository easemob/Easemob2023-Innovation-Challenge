package tech.baici.app.kchat

import android.util.Log
import com.iflytek.cloud.InitListener
import com.iflytek.cloud.SpeechConstant
import com.iflytek.cloud.SpeechRecognizer
import com.iflytek.cloud.SpeechSynthesizer
import com.iflytek.cloud.SpeechUtility
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

object IFlyTek: MethodChannel.MethodCallHandler {

    private var channel: MethodChannel? = null

    private var speechRecognizerChannel: EventChannel? = null
    private var speechSynthesizerChannel: EventChannel? = null

    private val speechRecognizer get() = SpeechRecognizer.getRecognizer()
    private val speechSynthesizer get() = SpeechSynthesizer.getSynthesizer()

    const val TAG = "IFlyTek"

    fun registerWith(messenger: BinaryMessenger) {
        //
        channel = MethodChannel(messenger, "tech.baici.app.kchat/iflytek")
        channel?.setMethodCallHandler(this)

        speechRecognizerChannel = EventChannel(messenger, "tech.baici.app.kchat/iflytek_listen", JSONMethodCodec.INSTANCE)
        speechRecognizerChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
                speechRecognizer?.startListening(object : com.iflytek.cloud.RecognizerListener {
                    override fun onVolumeChanged(p0: Int, p1: ByteArray?) {
                        Log.d(TAG, "onVolumeChanged: $p0")
                        //
                        sink?.success(mapOf("type" to "volume", "volume" to p0))
                    }

                    override fun onBeginOfSpeech() {
                        Log.d(TAG, "onBeginOfSpeech: ")
                        //
                        sink?.success(mapOf("type" to "begin"))
                    }

                    override fun onEndOfSpeech() {
                        sink?.success(mapOf("type" to "end"))
                    }

                    override fun onResult(p0: com.iflytek.cloud.RecognizerResult?, p1: Boolean) {
                        Log.d(TAG, "onResult: $p0")
                        p0?.let {
                            sink?.success(mapOf("type" to "result", "result" to JSONObject(it.resultString)))
                        }
                        if (p1) {
                            speechRecognizer?.cancel();
                            sink?.endOfStream();
                        }
                    }

                    override fun onError(p0: com.iflytek.cloud.SpeechError?) {
                        Log.d(TAG, "onError: $p0")
                        sink?.error(p0?.errorCode.toString(), p0?.errorDescription, null)
                    }

                    override fun onEvent(p0: Int, p1: Int, p2: Int, p3: android.os.Bundle?) {
                        // 以下代码用于获取与云端的会话id，当业务出错时将会话id提供给技术支持人员，可用于查询会话日志，定位出错原因
                        Log.d(TAG, "onEvent: $p0")
                    }
                })
            }

            override fun onCancel(p0: Any?) {
                speechRecognizer?.cancel();
            }
        })

        speechSynthesizerChannel = EventChannel(messenger, "tech.baici.app.kchat/iflytek_speak", JSONMethodCodec.INSTANCE)
        speechSynthesizerChannel?.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
                Log.i(TAG, "onListen: $p0")
                val arg = p0 as JSONObject
                speechRecognizer?.setParameter(SpeechConstant.TTS_AUDIO_PATH, arg.getString("filepath"))
                speechSynthesizer?.startSpeaking(arg.getString("content"), object : com.iflytek.cloud.SynthesizerListener {
                    override fun onSpeakBegin() {
                        sink?.success(mapOf("type" to "begin"))
                    }

                    override fun onBufferProgress(p0: Int, p1: Int, p2: Int, p3: String?) {
                        sink?.success(mapOf("type" to "bufferProgress", "result" to mapOf("progress" to p0, "beginPos" to p1, "endPos" to p2)))
                    }

                    override fun onSpeakPaused() {
                        sink?.success(mapOf("type" to "speakPaused"))
                    }

                    override fun onSpeakResumed() {
                        sink?.success(mapOf("type" to "speakResumed"))
                    }

                    override fun onSpeakProgress(p0: Int, p1: Int, p2: Int) {
                        sink?.success(mapOf("type" to "speakProgress", "result" to mapOf("progress" to p0, "beginPos" to p1, "endPos" to p2)))
                    }

                    override fun onCompleted(p0: com.iflytek.cloud.SpeechError?) {
                        p0?.let {
                            sink?.error(p0.errorCode.toString(), p0.errorDescription, null)
                        } ?: run {
                            sink?.success(mapOf("type" to "end"))
                            sink?.endOfStream()
                        }
                    }

                    override fun onEvent(p0: Int, p1: Int, p2: Int, p3: android.os.Bundle?) {
                        Log.d(TAG, "onEvent: $p0")
                    }
                })
            }

            override fun onCancel(p0: Any?) {
                speechSynthesizer?.stopSpeaking()
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                // 注意： appid 必须和下载的SDK保持一致，否则会出现10407错误
                call.argument<String>("appId")?.let {appId ->
                    //
                    SpeechUtility.createUtility(App.applicationContext(), SpeechConstant.APPID + "=$appId")

                    //
                    SpeechSynthesizer.createSynthesizer(App.applicationContext(), InitListener {
                        Log.d(TAG, "SpeechSynthesizer: $it")
                        speechSynthesizer.setParameter(SpeechConstant.VOICE_NAME, "aisjinger")
                        speechSynthesizer.setParameter(SpeechConstant.SPEED, "50")
                        speechSynthesizer.setParameter(SpeechConstant.VOLUME, "80")
                        speechSynthesizer.setParameter(SpeechConstant.PITCH, "50")
                        speechSynthesizer.setParameter(SpeechConstant.BACKGROUND_SOUND, "1")
                        speechSynthesizer.setParameter(SpeechConstant.TTS_AUDIO_PATH, "tts.pcm")
                        speechSynthesizer.setParameter(SpeechConstant.TTS_FADING, "true")
                    })

                    //
                    SpeechRecognizer.createRecognizer(App.applicationContext(), InitListener {
                        Log.d(TAG, "SpeechRecognizer value: $it")
                        speechRecognizer.setParameter(SpeechConstant.CLOUD_GRAMMAR, null)
                        speechRecognizer.setParameter(SpeechConstant.SUBJECT, null)
                        speechRecognizer.setParameter(SpeechConstant.RESULT_TYPE, "json")
                        speechRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, SpeechConstant.TYPE_CLOUD)
                        speechRecognizer.setParameter(SpeechConstant.LANGUAGE, "zh_cn")
                        speechRecognizer.setParameter(SpeechConstant.ACCENT, "mandarin")
                        speechRecognizer.setParameter(SpeechConstant.VAD_BOS, "4000")
                        speechRecognizer.setParameter(SpeechConstant.VAD_EOS, "1000")
                        speechRecognizer.setParameter(SpeechConstant.ASR_PTT, "1")
//                        speechSynthesizer.setParameter("dwa", "wpgs")
                    })

                    result.success(true)

                } ?: run {
                    result.error("1001", "appId is null", null)
                }
            }
            "pauseSpeaking" -> {
                speechSynthesizer?.pauseSpeaking()
                result.success(true)
            }
            "resumeSpeaking" -> {
                speechSynthesizer?.resumeSpeaking()
                result.success(true)
            }
            "stopSpeaking" -> {
                speechSynthesizer?.stopSpeaking()
                result.success(true)
            }
            "stopListening" -> {
                speechRecognizer?.stopListening()
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}