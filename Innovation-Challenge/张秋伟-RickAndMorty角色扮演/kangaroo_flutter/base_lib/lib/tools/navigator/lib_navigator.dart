
import 'dart:collection';

import 'package:base_lib/app/lifecycle/page_lifecycle.dart';
import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/tools/log/log_manager.dart';
import 'package:flutter/widgets.dart';

class LibNavigator{
  LibNavigator._();

  static final LibNavigator _instance = LibNavigator._();

  static LibNavigator get instance {
    return _instance;
  }

  final LinkedHashMap<int, String> _routes = LinkedHashMap();

  void didPush(Route route, Route? previousRoute) {
    //入栈
    _pageStart(route);
  }

  void didPop(Route route, Route? previousRoute) {
    //出栈
    _pageEnd(route);
  }

  void didReplace({Route? newRoute, Route? oldRoute}) {
    //替换调用
    _pageEnd(oldRoute);
    _pageStart(newRoute);
  }

  void didRemove(Route route, Route? previousRoute) {
    //移除
    _pageEnd(route);
  }

  void _pageEnd(Route? route) {
    if(route?.settings.name!=null){
      _routes.remove(route!.settings.hashCode);
      LogManager.log.d("out stack from: ${route.settings.name!} uid： ${route.settings.hashCode}",tag: SysConfig.libApplicationTag);
      PageLifecycleBinding.instance.dispatchPagePopEvent(route);
    }
  }

  void _pageStart(Route? route) {
    if(route?.settings.name!=null){
      _routes[route!.settings.hashCode] = route.settings.name!;
      LogManager.log.d("in stack from: ${route.settings.name!} uid： ${route.settings.hashCode}",tag: SysConfig.libApplicationTag);
      PageLifecycleBinding.instance.dispatchPagePushEvent(route);
    }
  }

  /// how page
  @Deprecated("不是太准确")
  int pageSize() {
    return _routes.length;
  }

  Route? _top;
  @Deprecated("不是太准确")
  void setCurrentPage(Route? route){
    _top = route;
  }

  /// get page
  @Deprecated("不是太准确")
  Route? getCurrentPage() {
    return _top;
  }

  bool isCurrent(BuildContext context){
    return ModalRoute.of(context)!.isCurrent;
  }

  String? getYouRoute(BuildContext context){
    return ModalRoute.of(context)?.settings.name;
  }

}