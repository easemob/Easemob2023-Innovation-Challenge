
import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/tools/log/log_manager.dart';
import 'package:base_lib/tools/navigator/lib_navigator.dart';
import 'package:flutter/widgets.dart';

///观察所有页面的生命周期
class GlobalPageLifecycleObserver {
  void onPagePush(Route<dynamic> route) {}

  void onPageShow(Route<dynamic> route) {}

  void onPageHide(Route<dynamic> route) {}

  void onPagePop(Route<dynamic> route) {}

  void onForeground(Route<dynamic> route) {}

  void onBackground(Route<dynamic> route) {}
}

///单页可视性观察者
class PageLifecycleObserver {

  ///
  ///提示：如果要在创建页面时执行操作，
  ///请输入[StatefulWidget]的[State]
  ///并在[initState]方法中编写代码进行初始化
  ///
  ///如果你想在销毁的时候做点什么，
  ///请使用[dispose]方法编写代码
  ///
  ///它可以被视为Android“onResume”或iOS“ViewDidDisplay”
  void onPageShow() {}

  /// 它可以被看作是Android的“onStop”或iOS的“ViewDidEnglish”
  void onPageHide() {}

  void onForeground() {}

  void onBackground() {}
}

class PageLifecycleBinding {
  PageLifecycleBinding._();

  static final PageLifecycleBinding instance = PageLifecycleBinding._();

  ///监听所有页面事件
  final Set<GlobalPageLifecycleObserver> _globalListeners =
  <GlobalPageLifecycleObserver>{};

  ///监听所有页面事件
  final Map<Route<dynamic>, Set<PageLifecycleObserver>> _listeners =
  <Route<dynamic>, Set<PageLifecycleObserver>>{};


  /// 将给定对象和路由注册为绑定观察者。
  void addObserver(PageLifecycleObserver observer, Route<dynamic> route) {
    final observers =
    _listeners.putIfAbsent(route, () => <PageLifecycleObserver>{});
    observers.add(observer);
    LogManager.log.d(
        '#addObserver, $observers, ${route.settings.name}',tag: '${SysConfig.libLifeCycleTag}page');
  }

  /// 取消注册给定的观察者。
  void removeObserver(PageLifecycleObserver observer) {
    for (final route in _listeners.keys) {
      final observers = _listeners[route];
      observers?.remove(observer);
    }
    LogManager.log.d(
        '#removeObserver, $observer',tag: '${SysConfig.libLifeCycleTag}page');
  }


  ///注册 [observer] 到 [_globalListeners] set
  void addGlobalObserver(GlobalPageLifecycleObserver observer) {
    _globalListeners.add(observer);
    LogManager.log.d( '#addGlobalObserver, $observer',tag: '${SysConfig.libLifeCycleTag}page');
  }
  ///取消组测 [observer] 从 [_globalListeners] set
  void removeGlobalObserver(GlobalPageLifecycleObserver observer) {
    _globalListeners.remove(observer);
    LogManager.log.d(' #removeGlobalObserver, $observer',tag: '${SysConfig.libLifeCycleTag}page');
  }

  void dispatchPagePushEvent(Route<dynamic> route) {
    ///只需全局观察
    dispatchGlobalPagePushEvent(route);
  }

  void dispatchPageShowEvent(Route<dynamic> route) {
    LibNavigator.instance.setCurrentPage(route);
    final observers = _listeners[route]?.toList();
    if (observers != null) {
      for (var observer in observers) {
        try {
          observer.onPageShow();
        } on Exception catch (e) {
          LogManager.log.e(e.toString(),error: e,tag: '${SysConfig.libLifeCycleTag}page');
        }
      }
    }
    LogManager.log.d(
        ' #dispatchPageShowEvent, ${route.settings.name}',tag: '${SysConfig.libLifeCycleTag}page');

    dispatchGlobalPageShowEvent(route);
  }

  ///当页面第一次显示时，我们应该在[FrameCallback]中调度事件
  ///为避免页面无法接收显示事件
  void dispatchPageShowEventOnPageShowFirstTime(Route<dynamic> route) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      dispatchPageShowEvent(route);
    });
  }

  void dispatchPageHideEvent(Route<dynamic> route) {
    LibNavigator.instance.setCurrentPage(null);
    final observers = _listeners[route]?.toList();
    if (observers != null) {
      for (var observer in observers) {
        try {
          observer.onPageHide();
        } on Exception catch (e) {
          LogManager.log.e(e.toString(),error: e,tag: '${SysConfig.libLifeCycleTag}page');
        }
      }
    }
    LogManager.log.d(
        ' #dispatchPageHideEvent, ${route.settings.name}',tag: '${SysConfig.libLifeCycleTag}page');

    dispatchGlobalPageHideEvent(route);
  }

  void dispatchPagePopEvent(Route<dynamic> route) {
    ///只需全局观察
    dispatchGlobalPagePopEvent(route);
  }

  void dispatchPageForgroundEvent(Route<dynamic> route) {
    final observers = _listeners[route]?.toList();
    if (observers != null) {
      for (var observer in observers) {
        try {
          observer.onForeground();
        } on Exception catch (e) {
          LogManager.log.e(e.toString(),error: e,tag: '${SysConfig.libLifeCycleTag}page');
        }
      }
    }

    LogManager.log.d(
        ' #dispatchPageForgroundEvent, ${route.settings.name??"无路由名页面"}',tag: '${SysConfig.libLifeCycleTag}page');

    dispatchGlobalForgroundEvent(route);
  }

  void dispatchPageBackgroundEvent(Route<dynamic> route) {
    final observers = _listeners[route]?.toList();
    if (observers != null) {
      for (var observer in observers) {
        try {
          observer.onBackground();
        } on Exception catch (e) {
          LogManager.log.e(e.toString(),error: e,tag: '${SysConfig.libLifeCycleTag}page');
        }
      }
    }

    LogManager.log.d(' '
        '#dispatchPageBackgroundEvent, ${route.settings.name}??"无路由名页面"',tag: '${SysConfig.libLifeCycleTag}page');

    dispatchGlobalBackgroundEvent(route);
  }


  void dispatchGlobalPagePushEvent(Route<dynamic> route) {

    final globalObserversList = _globalListeners.toList();

    for (var observer in globalObserversList) {
      observer.onPagePush(route);
    }

    LogManager.log.d(' #dispatchGlobalPagePushEvent, '
        '${route.settings.name}',tag: '${SysConfig.libLifeCycleTag}page');
  }

  void dispatchGlobalPageShowEvent(Route<dynamic> route) {
    final globalObserversList = _globalListeners.toList();

    for (var observer in globalObserversList) {
      observer.onPageShow(route);
    }

    LogManager.log.d(' #dispatchGlobalPageShowEvent, '
        '${route.settings.name}',tag: '${SysConfig.libLifeCycleTag}page');
  }

  void dispatchGlobalPageHideEvent(Route<dynamic> route) {
    final globalObserversList = _globalListeners.toList();

    for (var observer in globalObserversList) {
      observer.onPageHide(route);
    }

    LogManager.log.d(' #dispatchGlobalPageHideEvent, '
        '${route.settings.name}',tag: '${SysConfig.libLifeCycleTag}page');
  }

  void dispatchGlobalPagePopEvent(Route<dynamic> route) {

    final globalObserversList = _globalListeners.toList();
    for (var observer in globalObserversList) {
      observer.onPagePop(route);
    }

    LogManager.log.d(' #dispatchGlobalPagePopEvent, '
        '${route.settings.name}',tag: '${SysConfig.libLifeCycleTag}page');
  }

  void dispatchGlobalForgroundEvent(Route<dynamic> route) {
    final globalObserversList = _globalListeners.toList();
    for (var observer in globalObserversList) {
      observer.onForeground(route);
    }

    LogManager.log.d(' #dispatchGlobalForgroudEvent',tag: '${SysConfig.libLifeCycleTag}page');
  }

  void dispatchGlobalBackgroundEvent(Route<dynamic> route) {
    final globalObserversList = _globalListeners.toList();
    for (var observer in globalObserversList) {
      observer.onBackground(route);
    }

    LogManager.log.d(' #dispatchGlobalBackgroundEvent',tag: '${SysConfig.libLifeCycleTag}page');
  }
}