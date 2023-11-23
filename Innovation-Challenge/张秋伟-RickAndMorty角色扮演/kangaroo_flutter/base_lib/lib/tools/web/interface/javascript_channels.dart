

import 'package:base_lib/tools/log/log_manager.dart';
import 'package:base_lib/tools/tip/tip_toast.dart';
import 'package:flutter/widgets.dart';

import 'i_contorller.dart';

abstract class JavascriptChannels{

  WebPageCallBack? webPageCallBack;
  IController? controller;
  JavascriptChannels();

  void logFunctionName(String functionName, String data) {
    LogManager.log.d("JS functionName -> $functionName JS params -> $data");
  }

  Set<JsChannel>? baseJavascriptChannels(BuildContext context){
    var javascriptChannels = {
      _alertJavascriptChannel(context),
      _closeWindowJavascriptChannel(context),
      _logJavascriptChannel(context),
    };
    var other = otherJavascriptChannels(context);
    if(other!=null){
      javascriptChannels.addAll(other);
    }
    return javascriptChannels;
  }

  JsChannel _alertJavascriptChannel(BuildContext context) {
    var jname = 'nat_toast';
    return JsChannel(
        name: jname,
        onMessageReceived: (JsMessage message) {
          logFunctionName(jname,message.message);
          TipToast.showToast(message.message);
        });
  }

  JsChannel _closeWindowJavascriptChannel(BuildContext context) {
    var jname = 'nat_close';
    return JsChannel(
        name: jname,
        onMessageReceived: (JsMessage message) {
          logFunctionName(jname,message.message);
          Navigator.of(context).pop();
        });
  }


  JsChannel _logJavascriptChannel(BuildContext context) {
    var jname = 'nat_log';
    return JsChannel(
        name: jname,
        onMessageReceived: (JsMessage message) {
          logFunctionName(jname,message.message);
          LogManager.log.d(message.message);
        });
  }


  Set<JsChannel>? otherJavascriptChannels(BuildContext context);

}

class JsMessage {
  const JsMessage({
    required this.message,
  });

  final dynamic message;
}


typedef JsMessageHandler = void Function(JsMessage message);

class JsChannel {
  JsChannel({
    required this.name,
    required this.onMessageReceived,
  })  : assert(name != null),
        assert(onMessageReceived != null);
  final String name;

  final JsMessageHandler onMessageReceived;
}
