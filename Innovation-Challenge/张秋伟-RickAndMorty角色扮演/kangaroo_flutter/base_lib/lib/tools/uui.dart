
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'dart:ui';

class UUi{
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isTablet(){
    var originalSize = window.physicalSize / window.devicePixelRatio;
    var originalWidth = originalSize.width;
    var originalHeight = originalSize.height;
    var screenSize = min(originalWidth,originalHeight);
    if(screenSize>600){
      return true;
    }
    return false;
  }

}