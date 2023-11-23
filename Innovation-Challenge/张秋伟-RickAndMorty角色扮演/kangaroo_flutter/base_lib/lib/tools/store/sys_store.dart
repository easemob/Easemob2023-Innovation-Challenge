

import 'package:base_lib/tools/store/store_manager.dart';

import '../../app/sys_config.dart';
import 'lib_store.dart';

class SysStore{

  static Future<bool> putSysNetToken(String token) => (StoreManager.store as LibStore).setString(SysConfig.sysNetToken, token,safe: true);


  static String? getSysToken() {
    return (StoreManager.store as LibStore).getString(SysConfig.sysNetToken,safe: true);
  }

  static bool hasUserToken() {
    return StoreManager.store.hasKey(SysConfig.sysNetToken);
  }

  static clearToken(){
    StoreManager.store.remove(SysConfig.sysNetToken);
  }
}