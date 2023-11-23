
import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/tools/log/log_manager.dart';
import 'package:base_lib/tools/navigator/lib_navigator.dart';
import 'package:base_lib/tools/navigator/lib_route_navigator_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'lib_lifecycle_binding.dart';

class AppLifecycleObserver {
  void appCreate(){
    LogManager.log.d(
        '应用启动',tag: '${SysConfig.libLifeCycleTag}LibFlutterBinding');
  }
  void appQuit(){
    LogManager.log.d(
        '应用退出',tag: '${SysConfig.libLifeCycleTag}LibFlutterBinding');
  }
  void appPause(){
    LogManager.log.d(
        '应用退到后台',tag: '${SysConfig.libLifeCycleTag}LibFlutterBinding');
  }
  void appResumed(){
    LogManager.log.d(
        '应用回到前台',tag: '${SysConfig.libLifeCycleTag}LibFlutterBinding');
  }
}

///此类用于钩住绑定，以处理生命周期事件
mixin LibFlutterBinding on WidgetsFlutterBinding{

  ///监听所有页面事件
  final Set<AppLifecycleObserver> _appListeners = <AppLifecycleObserver>{AppLifecycleObserver()};

  @override
  void initInstances() {
    super.initInstances();
    _instance = this;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      for (var element in _appListeners) {
        element.appCreate();
      }
    });
    // _appLifecycleStateLocked = false;
    changeAppLifecycleState(AppLifecycleState.resumed);
  }


  bool _appLifecycleStateLocked = true;
  static LibFlutterBinding get instance => _instance;
  static late LibFlutterBinding _instance;
  @override
  void handleAppLifecycleStateChanged(AppLifecycleState state) {
    if (_appLifecycleStateLocked) {
      return;
    }

    switch(state){
      case AppLifecycleState.resumed:
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          LibLifecycleBinding.instance.appDidEnterForeground( ModalRoute.of(LibRouteNavigatorObserver.instance.navigator!.context));
          for (var element in _appListeners) {
            element.appResumed();
          }
        });
        break;
      case AppLifecycleState.paused:
        LibLifecycleBinding.instance.appDidEnterBackground(ModalRoute.of(LibRouteNavigatorObserver.instance.navigator!.context));
        for (var element in _appListeners) {
          element.appPause();
        }
        break;
      case AppLifecycleState.detached:
        for (var element in _appListeners) {
          element.appQuit();
        }
        break;
    }
    super.handleAppLifecycleStateChanged(state);
  }



  ///添加
  void addAppObserver(AppLifecycleObserver observer) {
    _appListeners.add(observer);
    LogManager.log.d( '#addAppObserver, $observer',tag: '${SysConfig.libLifeCycleTag}LibFlutterBinding');
  }
  ///取消组测 [observer] 从 [_globalListeners] set
  void removeAppObserver(AppLifecycleObserver observer) {
    _appListeners.remove(observer);
    LogManager.log.d(' #removeAppObserver, $observer',tag: '${SysConfig.libLifeCycleTag}LibFlutterBinding');
  }

  void changeAppLifecycleState(AppLifecycleState state) {
    if (SchedulerBinding.instance.lifecycleState == state) {
      return;
    }
    _appLifecycleStateLocked = false;
    // handleAppLifecycleStateChanged(state);
    // _appLifecycleStateLocked = true;
  }

}