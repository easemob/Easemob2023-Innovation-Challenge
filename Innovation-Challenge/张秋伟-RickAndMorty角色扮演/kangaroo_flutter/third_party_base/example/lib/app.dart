

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:third_party_base/third_party_base.dart';
import 'package:third_party_base_example/app/router_name.dart';
import 'package:third_party_base_example/page/home_page.dart';
import 'package:third_party_base_example/page/two_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return LibApp((navigatorObservers, initialRoute, onGenerateRoute, builder, localizationsDelegates, supportedLocales) {
      return MaterialApp(
        title: "三方库",
        builder: builder,
        navigatorObservers: navigatorObservers??[],
        onGenerateRoute: onGenerateRoute,
        initialRoute: initialRoute,
        // //名为"splash"的路由作为应用的开屏页面
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales??[],
      );
    }, (settings){
      return MaterialPageRoute(
          builder: (context) {
            switch(settings.name){
              case RouterName.home:
                return const HomePage();
              case RouterName.two:
                return const TwoPage();
            }
            return const HomePage();
          },
          settings: settings);
    }, RouterName.home);


  }
}
