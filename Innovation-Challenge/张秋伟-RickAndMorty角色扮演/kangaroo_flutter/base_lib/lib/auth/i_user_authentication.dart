
import 'package:base_lib/app/sys_config.dart';

import '../app/app_config.dart';
import '../app/app_environment.dart';
import '../tools/log/log_manager.dart';
import '../tools/net/http_persistent.dart';
import '../tools/store/sys_store.dart';

abstract class IUserAuthentication{

  bool hasToken(){
    LogManager.log.d("hasToken",tag: SysConfig.libApplicationTag);
    return SysStore.hasUserToken();
  }

  ///token 可能在header中处理
  Future saveToken(String? token) async{
    LogManager.log.d("saveToken",tag: SysConfig.libApplicationTag);
    if(token!=null){
      await SysStore.putSysNetToken(token);
    }
  }

  void deleteToken(){
    LogManager.log.d("deleteToken",tag: SysConfig.libApplicationTag);
    ///清理token
    SysStore.clearToken();
    ///移除默认api地址的持久化操作，如有其他api则还需要手动操作
    HttpPersistent.removeAllPersistent(AppEnvironment.envConfig![AppConfig.apiName]!);
  }

  void authPage();

  void unAuthPage();
}