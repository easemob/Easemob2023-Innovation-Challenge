import 'dart:io';
import 'package:flutter/foundation.dart';

class PlatformUtil {

  static late IPlatform _platform;

  static void init(IPlatform iPlatform){
    _platform = iPlatform;
  }


  static bool get isWeb => _platform.isWeb();

  static bool get isAndroid => _platform.isAndroid();

  static bool get isIOS => _platform.isIOS();

  static bool get isMacOS => _platform.isMacOS();

  static bool get isWindows => _platform.isWindows();

  static bool get isFuchsia => _platform.isFuchsia();

  static bool get isLinux => _platform.isLinux();
}

abstract class IPlatform{
  bool isIOS();
  bool isWeb();
  bool isMacOS();
  bool isWindows();
  bool isLinux();
  bool isAndroid();
  bool isFuchsia();
}