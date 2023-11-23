import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:rick_and_morty/page/chart/view.dart';
import 'package:rick_and_morty/page/home/view.dart';
import 'package:rick_and_morty/page/login/view.dart';
import 'package:rick_and_morty/page/regist/view.dart';
import 'package:rick_and_morty/page/splash/view.dart';
import 'package:third_party_base/third_party_base.dart';
import 'package:base_lib/auth/authentication.dart';
import 'package:get/get.dart';
import 'package:page_getx/page_getx.dart';
import 'app/app_init.dart';
import 'app/router_name.dart';
import 'page/unknown_route_page.dart';

class Auth extends IUserAuthentication{

  Auth(){
    // _userMMKV = MMKVStore.appMMKV(name: "123");
  }
  @override
  void authPage() {
    LogManager.log.d("authPage");
    Get.offNamed(RouterName.home);
  }

  @override
  void deleteToken() {
    super.deleteToken();
    EasyLoading.dismiss();
    StoreManager.store.clear();
    // UserStore().clearUser();
  }

  @override
  void unAuthPage() {
    LogManager.log.d("unAuthPage");
    Get.offNamed(RouterName.login);
  }

}



void main() {
  Application.init(AppInit(ConfigBuilder()
      .setDebugState(true)
      .setLibLog(ULogLibLogBuilder().build())
      .build(),ULogLibConfigBuilder().setTag("tg-app").build()),
      syncinitFin: () {
        runApp(LibApp((navigatorObservers, initialRoute, onGenerateRoute, builder, localizationsDelegates, supportedLocales) {
          Authentication.instance.iAuthentication = AuthenticationGetx();
          Authentication.instance.init(Auth());
          return GetMaterialApp(
            title: "Rick And Morty",
            builder: builder,
            navigatorObservers: navigatorObservers??[],
            onGenerateRoute: onGenerateRoute,
            unknownRoute: GetPage(name: RouterName.notfound, page: () => const UnknownRoutePage()),
            initialRoute: initialRoute,
            // //名为"splash"的路由作为应用的开屏页面
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales??[],
            getPages: [
              GetPage(name: RouterName.splash, page: () => SplashPage()),
              GetPage(name: RouterName.login, page: () => LoginPage()),
              GetPage(name: RouterName.regist, page: () => RegistPage()),
              GetPage(name: RouterName.home, page: () => HomePage()),
              GetPage(name: RouterName.chartpage, page: () => ChartPage()),
            ],
            routingCallback: null,
          );
        }, null, RouterName.splash));
      });


}