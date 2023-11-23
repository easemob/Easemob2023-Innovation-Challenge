

import 'package:base_lib/app/config.dart';
import 'package:base_lib/base_lib.dart';
import 'package:base_lib/tools/platform_util.dart';
import 'package:base_lib/tools/store/lib_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/binding.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ulog/flutter_ulog.dart';
import 'package:third_party_base/app/init/impl/connect_impl.dart';
import 'package:third_party_base/app/init/impl/diskspace_impl.dart';
import 'package:third_party_base/app/init/impl/log_impl.dart';
import 'package:base_lib/app/application.dart';
import 'package:third_party_base/app/init/impl/package_info_impl.dart';
import 'package:third_party_base/app/init/impl/path_provider_impl.dart';
import 'package:third_party_base/app/init/impl/permession_impl.dart';
import 'package:third_party_base/app/init/impl/platform_impl.dart';
import 'package:third_party_base/app/init/impl/secret_impl.dart';
import 'package:third_party_base/app/init/impl/store_impl.dart';
// import 'package:kg_density/kg_density.dart';
import 'package:third_party_base/app/init/impl/tip_impl.dart';
import 'package:third_party_base/third_party_base.dart';
import 'package:third_party_base/tools/privacy_utils.dart';
import 'package:base_ui/base_ui.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'impl/launch_impl.dart';

abstract class LibBaseInit extends BaseInit{


  LibBaseInit(Config config,ULogLibConfig uLogLibConfig) :
        super(config,LogImpl(uLogLibConfig), StoreImpl(), PathProviderImpl(), SecertImpl(), DiskspaceImpl(), PackageInfoImpl(), PermessionImpl(),TipImpl(),ConnectImpl(),PlatformImpl(),LaunchImpl());

  @override
  void init() {
    super.init();
  }

  void androidUiStyle({Brightness statusBarBrightness = Brightness.dark}){
    ///Android设置状态栏透明（去除遮罩层）
    if (PlatformUtil.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: statusBarBrightness); //状态栏黑色字体
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
  /// 强制竖屏
  void orientations(){
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Future syncInit() async{
    await ((StoreManager.store as LibStore).getRealStore() as StoreImpl).init();
    await super.syncInit();
    UiInit.init();
    await ThirdPartyBase().init();
  }

  // @override
  // void bindingInit() {
  //   KgDensity.initKgDensity(designWidth : UUi.isTablet()?768:375);
  //   MyFlutterBinding();
  // }

  @override
  TransitionBuilder? transitionBuilder() => EasyLoading.init(builder: UiInit.uiBuilder(builder: super.transitionBuilder()));
  //  ;

  ///同意协议后调用 Android
  Future thirdPartyForAndroid();
  ///其他直接调用
  Future otherthirdParty();

  @override
  List<LocalizationsDelegate>? localizationsDelegates() {
    return super.localizationsDelegates()!..addAll(UiInit.localizationsDelegates());
  }
}

///
/// 富含生命周期与屏幕适配
// class MyFlutterBinding extends WidgetsFlutterBinding with LibFlutterBinding,KgFlutterBinding {
//
// }