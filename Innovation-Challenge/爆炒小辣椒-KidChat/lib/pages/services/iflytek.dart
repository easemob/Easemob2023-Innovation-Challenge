import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:g_json/g_json.dart';
import 'package:kid_chat/utils/constants.dart';

class IFlyTek {
  factory IFlyTek() => _instance;

  static final IFlyTek _instance = IFlyTek._internal();

  late MethodChannel _channel;

  late EventChannel _speechRecognizerChannel;
  late EventChannel _speechSynthesizerChannel;

  IFlyTek._internal() {
    _channel = const MethodChannel('tech.baici.app.kchat/iflytek');
    _channel.setMethodCallHandler(_handler);

    _speechRecognizerChannel = const EventChannel(
      'tech.baici.app.kchat/iflytek_listen',
      JSONMethodCodec(),
    );

    _speechSynthesizerChannel = const EventChannel(
      'tech.baici.app.kchat/iflytek_speak',
      JSONMethodCodec(),
    );
  }

  Future<dynamic> _handler(MethodCall call) async {
    throw UnimplementedError();
  }

  /// 初始化科大讯飞sdk
  static Future<void> init() async {
    return await _instance._channel.invokeMethod(
      'init',
      {'appId': Constants.ifAppId},
    );
  }

  // 开始听写
  static Stream<FluentEvent> startListening() {
    return _instance._speechRecognizerChannel
        .receiveBroadcastStream()
        .map((event) {
      final raw = JSON(event);
      debugPrint("receive: $raw");
      final type = raw['type'].stringValue;
      switch (type) {
        case 'begin':
          return FluentBeginEvent();
        case 'end':
          return FluentEndEvent();
        case 'result':
          return FluentResultEvent(raw['result']);
        case 'volume':
          return FluentListenVolumeEvent(raw['volume'].integerValue);
        default:
          throw Exception('Unknown event type: $type');
      }
    });
  }

  static Future<void> stopListening() async {
    return await _instance._channel.invokeMethod('stopListening');
  }

  // 开始朗读
  static Stream<FluentEvent> startSpeaker(String content, String filepath) {
    return _instance._speechSynthesizerChannel.receiveBroadcastStream(
        {'content': content, 'filepath': filepath}).map((event) {
      final raw = JSON(event);
      debugPrint("receive: $raw");
      final type = raw['type'].stringValue;
      switch (type) {
        case "begin":
          return FluentBeginEvent();
        case "end":
          return FluentEndEvent();
        default:
          return FluentResultEvent(raw);
      }
    });
  }

  static Future<void> pauseSpeaker() async {
    return await _instance._channel.invokeMethod('pauseSpeaking');
  }

  static Future<void> resumeSpeaker() async {
    return await _instance._channel.invokeMethod('resumeSpeaking');
  }

  static Future<void> stopSpeaker() async {
    return await _instance._channel.invokeMethod('stopSpeaking');
  }
}

sealed class FluentEvent {}

// 开始
final class FluentBeginEvent extends FluentEvent {}

// 结束
final class FluentEndEvent extends FluentEvent {}

// 结果
final class FluentResultEvent extends FluentEvent {
  final JSON result;

  FluentResultEvent(this.result);
}

// 识别时的音量变化， 会调用多次
final class FluentListenVolumeEvent extends FluentEvent {
  final int volume;
  FluentListenVolumeEvent(this.volume);
}
