import 'dart:io';

import 'package:base_lib/tools/log/log_manager.dart';

import 'config.dart';
import 'init/i_init.dart';
import 'sys_config.dart';

typedef InitFinish = void Function();
typedef SyncinitFinish = void Function();

class Application{


  static Config config = ConfigBuilder().build();
  static late IInit initImpl;

  static void init(IInit init,{InitFinish? initFin,SyncinitFinish? syncinitFin}) {
    initImpl = init;
    init.init();
    if(initFin!=null){
      initFin();
    }
    LogManager.log.d("app config init",tag: SysConfig.libApplicationTag);
    init.syncInit().then((_) {
      LogManager.log.d("app config syncinit",tag: SysConfig.libApplicationTag);
      if(syncinitFin!=null){
        syncinitFin();
      }
    });
  }

}
