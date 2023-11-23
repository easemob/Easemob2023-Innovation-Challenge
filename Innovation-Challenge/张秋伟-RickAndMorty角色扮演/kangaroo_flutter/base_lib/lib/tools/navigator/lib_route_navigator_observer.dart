import 'package:base_lib/app/lifecycle/lib_lifecycle_binding.dart';
import 'package:flutter/material.dart';

class LibRouteNavigatorObserver extends RouteObserver{

  LibRouteNavigatorObserver._();

  static final LibRouteNavigatorObserver _instance = LibRouteNavigatorObserver._();

  static LibRouteNavigatorObserver get instance {
    return _instance;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    LibLifecycleBinding.instance.routeDidPush(route, previousRoute);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    LibLifecycleBinding.instance.routeDidPop(route, previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    LibLifecycleBinding.instance.routeDidReplace(oldRoute: oldRoute,newRoute: newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    LibLifecycleBinding.instance.routeDidRemove(route, previousRoute);
    super.didRemove(route, previousRoute);
  }
}