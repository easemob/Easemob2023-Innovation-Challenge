
import 'package:base_lib/app/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef LibUiAppBuilder = Widget Function(List<NavigatorObserver>? navigatorObservers,String initialRoute,RouteFactory? onGenerateRoute,
    TransitionBuilder? builder,Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    Iterable<Locale>? supportedLocales);

///基本框架初始化
class LibApp extends StatefulWidget{

  final LibUiAppBuilder appBuilder;
  final String initialRoute;
  final RouteFactory? onGenerateRoute;
  const LibApp(this.appBuilder,this.onGenerateRoute ,this.initialRoute, {super.key});
  @override
  State<StatefulWidget> createState() => LibUiAppState();

}

class LibUiAppState extends State<LibApp> {
  @override
  Widget build(BuildContext context) {
    var init = Application.initImpl;
    return widget.appBuilder(init.navigatorObservers(),widget.initialRoute,widget.onGenerateRoute,init.transitionBuilder(),init.localizationsDelegates(),init.supportedLocales());
  }

  @override
  void initState() {
    super.initState();
  }

}
