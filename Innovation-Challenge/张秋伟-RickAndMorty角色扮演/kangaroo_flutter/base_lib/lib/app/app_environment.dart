import 'dart:io';

import 'package:base_lib/tools/log/log_manager.dart';
import 'package:base_lib/tools/store/store_manager.dart';

import 'application.dart';
import 'sys_config.dart';

enum Environment {
  PRODUCT,
  DEV,
  TEST,
  LOCAL,
}

class AppEnvironment {
  static Environment? _env;

  static late Map<Environment, Map<String, String?>> _envs;

  static void init(Map<Environment, Map<String, String?>> envs,{Environment defalutEnv = Environment.PRODUCT}) {
    LogManager.log.d(envs,tag: SysConfig.libEnvironmentTag);
    _envs = envs;
    if (Application.config.debugState) {
      _defalutEnv = defalutEnv;
    }
  }

  static set env(Environment env) {
    _env = env;
    StoreManager.store.setInt(SysConfig.sysEnv, env.index);
    // exit(0);
  }

  static Environment _defalutEnv = Environment.PRODUCT;


  static Environment get env {
    if (Application.config.debugState) {
      if (_env != null) {
        return _env!;
      }
      var index = StoreManager.store.getInt(SysConfig.sysEnv)??_defalutEnv.index;
      _env = Environment.values[index];
      return _env!;
    }
    return _defalutEnv;
  }

  static Map<String, String?>? get envConfig {
    return _envs[env];
  }

  static Map<Environment, Map<String, String?>> get envs {
    return _envs;
  }


}
