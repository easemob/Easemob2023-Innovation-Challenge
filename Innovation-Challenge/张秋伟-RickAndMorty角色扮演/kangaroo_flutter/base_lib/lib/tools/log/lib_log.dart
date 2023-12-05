
import 'package:base_lib/app/application.dart';
import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/base_lib.dart';
import 'package:base_lib/tools/log/i_log.dart';

class LibLog implements ILog{

  final ILog _realLog;

  const LibLog(this._realLog);

  @override
  void d(message, {String? tag}) {
    if(_isLog(tag)){
      _realLog.d(message,tag: tag);
      for (var element in LogManager.listener) {
        element.d(message,tag: tag);
      }
    }
  }

  @override
  void e(message, {error, StackTrace? stackTrace, String? tag}) {
    if(_isLog(tag)) {
      _realLog.e(message,tag: tag,stackTrace: stackTrace,error: error);
      for (var element in LogManager.listener) {
        element.e(message,tag: tag,stackTrace: stackTrace,error: error);
      }
    }
  }

  @override
  void i(message, {String? tag}) {
    if(_isLog(tag)) {
      _realLog.i(message,tag: tag);
      for (var element in LogManager.listener) {
        element.i(message,tag: tag);
      }
    }
  }

  @override
  void w(message, {String? tag}) {
    if(_isLog(tag)) {
      _realLog.w(message,tag: tag);
      for (var element in LogManager.listener) {
        element.w(message,tag: tag);
      }
    }
  }

  bool _isLog(String? tag){
    var log = Application.config.libLog;
    if(log.libLog){
      if(tag!=null){
        if(tag.contains(SysConfig.libApplicationTag)){
          if(!log.applicationLog){
            return false;
          }
        }else if(tag.contains(SysConfig.libEnvironmentTag)){
          if(!log.environmentLog){
            return false;
          }
        }else if(tag.contains(SysConfig.libLifeCycleTag)){
          if(!log.lifecycleLog){
            return false;
          }
        }else if(tag.contains(SysConfig.libNetTag)){
          if(!log.netLog){
            return false;
          }
        }
      }
    }else{
      if(tag!=null&&tag.contains(SysConfig.libTag)){
        return false;
      }
    }
    return true;
  }
  
}