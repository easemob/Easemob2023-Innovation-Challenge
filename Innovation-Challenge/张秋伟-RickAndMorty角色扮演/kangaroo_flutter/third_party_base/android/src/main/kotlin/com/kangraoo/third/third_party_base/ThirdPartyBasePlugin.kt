package com.kangraoo.third.third_party_base

import android.content.Context
import androidx.annotation.NonNull
import com.kangraoo.third.third_party_base.app.AppPluginInit
import com.kangraoo.third.third_party_base.app.CHANNEL

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
/** ThirdPartyBasePlugin */
class ThirdPartyBasePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var flutterPluginBinding: FlutterPluginBinding
  private lateinit var mContext: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    mContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)
    this.flutterPluginBinding = flutterPluginBinding
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    when (call.method) {
      "init" -> {
        val debugStatic = call.argument<Boolean>("debugStatic")!!
        val privacy = call.argument<Boolean>("privacy")!!
        AppPluginInit.init(mContext,debugStatic,privacy)
        result.success(null);
      }
      "update" -> {
        val privacy = call.argument<Boolean>("privacy")!!
        AppPluginInit.update(mContext,privacy)
        result.success(null);
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
