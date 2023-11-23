

import 'package:flutter/widgets.dart';
import 'package:third_party_base/app/init/lib_base_init.dart';
import 'package:third_party_base/third_party_base.dart';

class AppInit extends LibBaseInit{
  AppInit(super.config, super.uLogLibConfig);

  @override
  Future syncInit() {
    return super.syncInit().then((value) async{
      Map<Environment, Map<String, String?>> envs = {};
      var product = envs[Environment.PRODUCT] = {};
      product[SysConfig.envName] = "生产";
      // product[AppConfig.apiNameYapi] = "http://yapi.zkhyedu.com/";
      product[AppConfig.apiName] = "https://bxlm.zkhyedu.com/";
      var dev = envs[Environment.DEV] = {};
      dev[SysConfig.envName] = "开发";
      // dev[AppConfig.apiNameYapi] = "http://yapi.zkhyedu.com/";
      dev[AppConfig.apiName] = "http://dev.qdedu.cn/";
      var local = envs[Environment.LOCAL] = {};
      local[SysConfig.envName] = "本地";
      // local[AppConfig.apiNameYapi] = "http://yapi.zkhyedu.com/";
      local[AppConfig.apiName] = "http://yapi.zkhyedu.com/mock/203/";
      var test = envs[Environment.TEST] = {};
      test[SysConfig.envName] = "测试";
      // test[AppConfig.apiNameYapi] = "http://yapi.zkhyedu.com/";
      test[AppConfig.apiName] = "http://qc-bxlm.zkhyedu.com/";
      AppEnvironment.init(envs, defalutEnv: Environment.TEST);
      var config = AppEnvironment.envConfig;
      ULog.d(config);
    });
  }

  @override
  Future otherthirdParty() async{

  }

  @override
  Future thirdPartyForAndroid() async{

  }


}