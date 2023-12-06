import 'dart:async';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart'
    hide TypewriterAnimatedText;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:kid_chat/pages/services/iflytek.dart';
import 'package:kid_chat/pages/services/llm.dart';
import 'package:kid_chat/pages/story.dart';
import 'package:kid_chat/utils/easemob.dart';
import 'package:kid_chat/utils/memory.dart';
import 'package:kid_chat/utils/throttle.dart';
import 'package:kid_chat/widgets/indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../widgets/animated_text.dart';
import '../widgets/sound_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

enum EngineState {
  idle,
  listening,
  thinking,
  speaking,
}

class HomePageState extends State<HomePage>
    with TempIgnoreTouchEventHandler, EaseMob {
  late final _recorder = AudioRecorder();
  late final _player = AudioPlayer();

  final _scrollController = ScrollController();
  final _llm = LLM();

  StreamSubscription? listeningSubscription;

  var _state = EngineState.idle;
  var _showText = false;
  final _memory = Memory();
  final _soundData = <int>[];

  IndicatorProgress? _bufferProgress;
  IndicatorProgress? _playProgress;

  var _playing = false;

  void _turnState(EngineState state) {
    setState(() {
      _state = state;
      switch (_state) {
        case EngineState.idle:
          _memory.append("", role: Role.system);
          break;
        case EngineState.listening:
          _memory.append("", role: Role.user);
          break;
        case EngineState.thinking:
          _memory.append("", role: Role.assistant);
          break;
        case EngineState.speaking:
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // 请求所有权限

    [Permission.microphone, Permission.storage, Permission.audio].request();

    IFlyTek.init();

    _memory.addListener(() {
      if (_showText) {
        //
        setState(() {});
      }
    });

    _player.onPositionChanged.listen((event) {
      debugPrint(event.toString());
    });

    setupEaseMob();
  }

  void _scrollListViewToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  // 听 用户输入
  void _startListening() {
    tempIgnoreTouchEvent();
    listeningSubscription = IFlyTek.startListening().listen(
      (event) {
        if (event is FluentBeginEvent) {
          // 语音听写引擎启动成功
          _memory.append("正在聆听, 请说出绘本故事梗概...", role: Role.system);
          _turnState(EngineState.listening);
        } else if (event is FluentResultEvent) {
          final result = event.result;
          final text = result["ws"]
              .listValue
              .map((e) => e["cw"].listValue.map((e) => e["w"].stringValue))
              .expand((element) => element)
              .join("");
          _memory.append(text, role: Role.user);
          if (result["ls"].booleanValue) {
            // 最后一个
            // 语音听写 识别完成 看看是什么东西
            _memory.append("正在构建故事请稍等...", role: Role.system);
            _startThinking(_memory.userLast.content);
          }
        } else if (event is FluentListenVolumeEvent) {
          // 语音听写 音量变化
          // 用此驱动 Soundbar
          _soundData.add(event.volume);
        }
      },
      onError: (err) {
        // 使用 snack bar 显示错误信息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("识别失败: $err"),
          ),
        );

        _turnState(EngineState.idle);
      },
      cancelOnError: true,
    );
  }

  // 思考 同时流失输出文本
  void _startThinking(String input) async {
    try {
      tempIgnoreTouchEvent();
      final stream = await _llm.run(
        input,
        clearMemory: true,
        userId: EMClient.getInstance.currentUserId,
      );
      _turnState(EngineState.thinking);

      stream.listen((event) {
        _memory.append(event.join());
      }, onDone: () {
        if (_showText) {
          // 不自动播放 直接返回
          _turnState(EngineState.idle);
        } else {
          // 自动播放ai生成的文本
          if (_memory.assistantLast.content.isNotEmpty) {
            _startSpeaking(_memory.assistantLast);
          } else {
            throw '生成的文本为空';
          }
        }
        // 将上一个用户输入的文本和ai生成的文本发送到自己的频道
        sendGeneratedContentToGroup(_memory.userLast, _memory.assistantLast);
      });
    } catch (e) {
      // 使用 snack bar 显示错误信息
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("创作失败: $e"),
          ),
        );
        _turnState(EngineState.idle);
      }
    }
  }

  // 播放
  void _startSpeaking(MemoryItem item) async {
    try {
      tempIgnoreTouchEvent();
      if (item.voicePath == null) {
        final cacheDir = await getApplicationCacheDirectory();
        final path =
            "${cacheDir.path}/${DateTime.now().millisecondsSinceEpoch}.pcm";
        item.voicePath = path;
      }

      // 判断如果语音文件已经存在了 那么直接播放
      if (File(item.voicePath!).existsSync()) {
        // 开始播放
        _player.play(
          DeviceFileSource(item.voicePath!),
          mode: PlayerMode.mediaPlayer,
        );
        return;
      }

      IFlyTek.startSpeaker(item.content, item.voicePath!).listen((event) {
        if (event is FluentBeginEvent) {
          _playing = true;
          _turnState(EngineState.speaking);
          return;
        }
        if (event is FluentEndEvent) {
          _playing = false;
          _turnState(EngineState.idle);
          return;
        }
        if (event is FluentResultEvent) {
          // 需要解析两个东西
          final result = event.result;
          final type = result["type"].stringValue;
          switch (type) {
            case "speakPaused":
              _playing = false;
              break;
            case "speakResumed":
              _playing = true;
              break;
            case "bufferProgress":
              // 转换进度
              _bufferProgress = IndicatorProgressUI.fromJson(result);
              break;
            case "speakProgress":
              // 文本播放进度
              _playProgress = IndicatorProgressUI.fromJson(result);
              break;
            default:
              break;
          }
          setState(() {});
        }
      });
    } catch (e) {
      // 使用 snack bar 显示错误信息
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("播放失败: $e"),
          ),
        );
        _turnState(EngineState.idle);
      }
    }
  }

  void _stop() {
    //
    listeningSubscription?.cancel();
    _llm.stop();
    IFlyTek.stopListening();
    IFlyTek.stopSpeaker();
    _turnState(EngineState.idle);
  }

  Widget _buildTipBar() {
    late final AnimatedText animatedText;
    switch (_state) {
      case EngineState.idle:
        animatedText = ColorizeAnimatedText(
          "点击开始创作新的绘本故事",
          colors: [Colors.purple, Colors.blue, Colors.yellow, Colors.red],
          textStyle: const TextStyle(
            fontSize: 14.0,
            fontFamily: 'Horizon',
          ),
        );
        break;
      case EngineState.listening:
        animatedText = FadeAnimatedText("正在聆听, 请说出绘本故事梗概...");
        break;
      case EngineState.thinking:
        animatedText = FadeAnimatedText("正在创作 ...");
      case EngineState.speaking:
        animatedText = FadeAnimatedText("正在朗读 ...");
    }
    return SizedBox(
      height: 30,
      child: AnimatedTextKit(
        isRepeatingAnimation: true,
        animatedTexts: [animatedText],
        repeatForever: true,
        pause: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Kid Chat",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        // recorder
                        //     .startStream(const RecordConfig(
                        //   encoder: AudioEncoder.pcm16bits,
                        //   sampleRate: 16000,
                        //   numChannels: 1,
                        //   echoCancel: true,
                        //   autoGain: true,
                        //   noiseSuppress: true,
                        // ))
                        //     .then(
                        //   (value) {
                        //     value.listen((event) {});
                        //   },
                        // );
                        // final random = Random();
                        // _memory.append("Test", role: Role.system);
                        // var i = 0;
                        // Timer.periodic(
                        //   const Duration(seconds: 3),
                        //   (timer) {
                        //     // setState(() {
                        //     //   _soundData.add(random.nextInt(100));
                        //     //   _memory.append("7858267");
                        //     // });
                        //     i++;
                        //     // _turnState(i.isOdd
                        //     //     ? EngineState.idle
                        //     //     : EngineState.thinking);
                        //     setState(() {
                        //       _playing = i.isOdd;
                        //     });
                        //   },
                        // );
                      },
                      child: Indicator(
                        thinking: _state == EngineState.thinking,
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(_showText ? 0.5 : 1),
                        bufferProgress: _bufferProgress,
                        playProgress: _playProgress,
                        playing: _playing,
                      ),
                    ),
                  ),
                  if (_showText)
                    Positioned.fill(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _showText ? 1 : 0,
                        child: ListView(
                          padding: const EdgeInsets.only(
                              left: 32, right: 32, bottom: 16),
                          controller: _scrollController,
                          children: [
                            TypewriterAnimatedText(
                              cursor: "|",
                              text: _memory.content,
                              textChanged: _scrollListViewToBottom,
                              inlineSpanBuilder: _memoryItemInlineSpanBuilder,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: _state != EngineState.listening
                  ? const EdgeInsets.all(8.0)
                  : EdgeInsets.zero,
              height: _state == EngineState.listening ? 20 : 0,
              transformAlignment: Alignment.center,
              child: SoundBar(soundData: _soundData, height: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  color: _showText
                      ? Colors.blue
                      : Theme.of(context).colorScheme.onBackground,
                  isSelected: _showText,
                  onPressed: () {
                    setState(() {
                      _showText = !_showText;

                      _recorder.stop();
                    });
                  },
                  icon: const Icon(Icons.abc),
                ),
                TextButton(
                  onPressed: () {
                    if (_state == EngineState.idle) {
                      _startListening();
                    } else {
                      _stop();
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor: Colors.white,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(_state == EngineState.idle
                            ? Icons.mic
                            : Icons.stop_circle),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(_state == EngineState.idle ? "开始" : "停止"),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.onBackground,
                  onPressed: () {
                    final route = MaterialPageRoute(
                      builder: (_) {
                        return const StoryPage();
                      },
                    );
                    Navigator.of(context).push(route);

                    // _turnState(EngineState.thinking);

                    // _startSpeaking("近日，特斯拉诉“上海车展事件”车主名誉权侵权一案，法院作出一审判决。");
                    // _memory.append("故人西辞黄鹤楼, 烟花三月下扬州", role: Role.user);
                    // _memory.append("古道西风瘦马，断肠人在天涯", role: Role.assistant);
                    // sendGeneratedContentToGroup(
                    //     _memory.userLast, _memory.assistantLast);
                    // _startThinking(_memory.userLast.content);
                  },
                  icon: const Icon(Icons.history),
                ),
              ],
            ),
            _buildTipBar(),
          ],
        ),
      ),
    );
  }

  TextStyle? _memoryItemPrefixStyle(MemoryItem item) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: item.role == Role.user
              ? Colors.green
              : item.role == Role.assistant
                  ? Colors.red
                  : Colors.yellow,
        );
  }

  TextStyle? _memoryContentStyle(MemoryItem item) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.normal,
        );
  }

  List<InlineSpan> _memoryItemInlineSpanBuilder(
      BuildContext context, int pos, String text) {
    final spans = <InlineSpan>[];
    final items = _memory.findMemoryItemByContentIndex(pos);

    if (items.isEmpty) return [];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (i == items.length - 1) {
        if (text.length > item.prefix.length) {
          spans.add(
            TextSpan(
              text: item.prefix,
              style: _memoryItemPrefixStyle(item),
            ),
          );
          spans.add(
            TextSpan(
              text: text.substring(item.prefix.length),
              style: _memoryContentStyle(item),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: text,
              style: _memoryItemPrefixStyle(item),
            ),
          );
        }
      } else {
        spans.add(
          TextSpan(
            text: item.prefix,
            style: _memoryItemPrefixStyle(item),
          ),
        );
        spans.add(
          WidgetSpan(
            child: GestureDetector(
              onTap: item.role == Role.assistant
                  ? () {
                      // 开始播放
                      _startSpeaking(item);
                    }
                  : null,
              child: Text(
                item.content,
                style: _memoryContentStyle(item)?.copyWith(
                  // decorationStyle: TextDecorationStyle,
                  decoration: item.role == Role.assistant
                      ? TextDecoration.underline
                      : null,
                  decorationColor: Colors.purple,
                ),
              ),
            ),
          ),
        );
        // spans.add(TextSpan(
        //   text: item.content,
        //   style: _memoryContentStyle(item),
        // ));
        spans.add(const TextSpan(text: "\n"));

        text = text.substring(item.prefix.length + item.content.length);
      }
    }

    return spans;
  }
}

extension IndicatorProgressUI on IndicatorProgress {
  static IndicatorProgress fromJson(JSON raw) {
    final result = raw["result"];
    return IndicatorProgress(
        progress: result["progress"].integerValue / 100,
        begin: result["begin"].integerValue,
        end: result["end"].integerValue);
  }
}
