import 'package:base_lib/tools/navigator/lib_navigator.dart';
import 'package:flutter/widgets.dart';
import 'page_lifecycle.dart';

class LibLifecycleBinding {
  LibLifecycleBinding._();

  static final LibLifecycleBinding instance = LibLifecycleBinding._();

  ///路由push
  void routeDidPush(Route route, Route? previousRoute) {
    LibNavigator.instance.didPush(route, previousRoute);
    PageLifecycleBinding.instance
        .dispatchPageShowEventOnPageShowFirstTime(route);
    if(previousRoute!=null){
      PageLifecycleBinding.instance.dispatchPageHideEvent(previousRoute);
    }
  }

  ///路由pop
  void routeDidPop(Route route, Route? previousRoute) {
    PageLifecycleBinding.instance.dispatchPageHideEvent(route);
    if(previousRoute!=null){
      PageLifecycleBinding.instance.dispatchPageShowEvent(previousRoute);
    }
    LibNavigator.instance.didPop(route, previousRoute);
  }

  ///路由pop
  void routeDidReplace({Route? newRoute, Route? oldRoute}) {
    LibNavigator.instance.didReplace(newRoute: newRoute);
    if(oldRoute!=null){
      PageLifecycleBinding.instance.dispatchPageHideEvent(oldRoute);
    }
    LibNavigator.instance.didReplace(oldRoute: oldRoute);
    if(newRoute!=null){
      PageLifecycleBinding.instance.dispatchPageShowEventOnPageShowFirstTime(newRoute);
    }
  }

  ///移除路由
  void routeDidRemove(Route route, Route? previousRoute) {
    LibNavigator.instance.didRemove(route, previousRoute);
  }


  ///app进入前台
  void appDidEnterForeground(Route? route) {
    if(route!=null){
      PageLifecycleBinding.instance
          .dispatchPageForgroundEvent(route);
    }
  }
  ///app进入后台
  void appDidEnterBackground(Route? route) {
    if(route!=null){
      PageLifecycleBinding.instance
          .dispatchPageBackgroundEvent(route);
    }
  }
  
}