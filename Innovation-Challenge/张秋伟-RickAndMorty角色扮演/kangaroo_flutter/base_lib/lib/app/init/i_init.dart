
import 'package:flutter/widgets.dart';

abstract class IInit{
  ///主线程初始化
  void init();

  ///Future初始化
  Future syncInit();

  TransitionBuilder? transitionBuilder();

  List<LocalizationsDelegate<dynamic>>? localizationsDelegates();

  List<Locale>? supportedLocales();

  List<NavigatorObserver>? navigatorObservers();
}