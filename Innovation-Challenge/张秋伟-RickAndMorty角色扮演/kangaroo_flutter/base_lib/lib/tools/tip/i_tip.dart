
import 'dart:ui';

import 'package:base_lib/tools/tip/tip.dart';
import 'package:flutter/material.dart';

enum TipDuration {
  /// Show Short toast for 1 sec
  LENGTH_SHORT,

  /// Show Long toast for 5 sec
  LENGTH_LONG;

  int get timeSec{
    switch(this){
      case TipDuration.LENGTH_SHORT:
        return 1;
      case TipDuration.LENGTH_LONG:
        return 5;
    }
  }
}


enum TipGravity {
  TOP,
  BOTTOM,
  CENTER,
}

abstract class ITip{

  TransitionBuilder builder();

  IFTip ifTip();

  void cancel();

  void showToast(String msg,{
    TipType tipType = TipType.normal,
    TipDuration duration = TipDuration.LENGTH_SHORT,
    TipGravity gravity = TipGravity.BOTTOM,
    double fontSize = 14,
    Color? backgroundColor,
    Color textColor = Colors.white,
  });


}

abstract class IFTip{
// if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
  void init(BuildContext context);

  void removeCustomToast();

  void removeQueuedCustomToasts();

  void showToast(String msg,{
    TipType tipType = TipType.normal,
    TipDuration duration = TipDuration.LENGTH_SHORT,
    TipGravity gravity = TipGravity.BOTTOM,
    double fontSize = 14,
    Color? backgroundColor,
    Color textColor = Colors.white,
  });


}