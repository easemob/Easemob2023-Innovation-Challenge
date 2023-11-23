
import 'package:base_lib/app/application.dart';
import 'package:base_lib/base_lib.dart';
import 'package:flutter_ulog/flutter_ulog.dart';

class LogImpl implements ILog{

  LogImpl(ULogLibConfig uLogLibConfig){
    ULog.addLogAdapter(ConsoleAdapter(formatStrategy: ULogLibConsoleFormatStrategy()..config = uLogLibConfig));
  }

  @override
  void d(message, {String? tag}) {
    ULog.d(message,tag: tag);
  }

  @override
  void e(message, {error, StackTrace? stackTrace, String? tag}) {
    ULog.e(message,tag: tag,error: error,stackTrace: stackTrace);
  }

  @override
  void i(message, {String? tag}) {
    ULog.i(message,tag: tag);
  }

  @override
  void w(message, {String? tag}) {
    ULog.w(message,tag: tag);
  }

}

class ConsoleAdapter extends ULogConsoleAdapter{

  ConsoleAdapter({ULogFormatStrategy? formatStrategy}):super(formatStrategy:formatStrategy);

  @override
  bool isLoggable(ULogType type, String? tag) => Application.config.debugState;

}