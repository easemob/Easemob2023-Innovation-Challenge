import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:third_party_base/app/init/lib_base_init.dart';
import 'package:third_party_base/third_party_base.dart';
import 'package:third_party_base/tools/net/dio_utli.dart';
import 'package:third_party_base/tools/notification/h_notification.dart';

import 'config.dart';

class AppInit extends LibBaseInit {
  AppInit(super.config, super.uLogLibConfig);

  @override
  void init() {
    super.init();
    HNotification.initNotification("@mipmap/ic_launcher");
    androidUiStyle();
    orientations();
  }

  @override
  Future syncInit() {
    return super.syncInit().then((value) async {
      Map<Environment, Map<String, String?>> envs = {};
      var product = envs[Environment.PRODUCT] = {};
      product[SysConfig.envName] = "生产";
      product[AppConfig.apiName] = "https://api.minimax.chat/";
      product[AppConfig.htmlName] = "http://192.168.1.45:5173/#/";
      var dev = envs[Environment.DEV] = {};
      dev[SysConfig.envName] = "开发";
      dev[AppConfig.apiName] = "https://api.minimax.chat/";
      dev[AppConfig.htmlName] = "http://192.168.1.45:3000/#/";
      var local = envs[Environment.LOCAL] = {};
      local[SysConfig.envName] = "本地";
      local[AppConfig.apiName] = "https://api.minimax.chat/";
      local[AppConfig.htmlName] = "http://192.168.1.45:3000/#/";
      var test = envs[Environment.TEST] = {};
      test[SysConfig.envName] = "测试";
      test[AppConfig.apiName] = "https://api.minimax.chat/";
      test[AppConfig.htmlName] = "http://192.168.1.45:3000/#/";
      AppEnvironment.init(envs, defalutEnv: Environment.PRODUCT);
      var config = AppEnvironment.envConfig;
      ULog.d(config);
      DioUtil.add(VmAppConfig.baseDio, DioUtil
          .instance(AppEnvironment.envConfig![AppConfig.apiName]!,
          interceptors: [
            LibLogInterceptor(requestBody: Application.config.debugState,
                responseBody: Application.config.debugState),
            ErrorInterceptor()
          ])
          .dio);

      //http刷新通用参数
      HttpPersistent.flushPersistent(
          AppEnvironment.envConfig![AppConfig.apiName]!,
          type: HttpPersistent.headerPresistent);
      _initSDK();
    });
  }

  void _initSDK() async {
    EMOptions options = EMOptions(
      appKey: VmAppConfig.emOptionsKey,
      autoLogin: false,
    );
    await EMClient.getInstance.init(options);
    // 通知 SDK UI 已准备好。该方法执行后才会收到 `EMChatRoomEventHandler`、`EMContactEventHandler` 和 `EMGroupEventHandler` 回调。
    await EMClient.getInstance.startCallback();
  }

  @override
  Future otherthirdParty() async {

  }

  @override
  Future thirdPartyForAndroid() async {

  }

  @override
  void bindingInit() {
    // KgDensity.initKgDensity(designWidth: UUi.isTablet() ? 768 : 375);
    CustomLibFlutterBinding();
  }
}