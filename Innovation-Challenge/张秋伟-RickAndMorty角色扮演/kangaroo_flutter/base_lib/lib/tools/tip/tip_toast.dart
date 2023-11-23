
import 'dart:ui';

import 'package:base_lib/tools/platform_util.dart';
import 'package:base_lib/tools/tip/lib_tip.dart';
import 'package:base_lib/tools/tip/tip.dart';
import 'package:flutter/material.dart';

import '../navigator/lib_route_navigator_observer.dart';
import 'i_tip.dart';
import 'lib_f_toast.dart';


class TipToast{

  static late ITip tp;

  static void init(ITip iTip){
    tp = LibTip(iTip);
  }

  static void showToast(String msg,{
    TipType tipType = TipType.normal,
    TipDuration duration = TipDuration.LENGTH_SHORT,
    TipGravity gravity = TipGravity.BOTTOM,
    double fontSize = 14,
    Color? backgroundColor,
    Color textColor = Colors.white,
    BuildContext? context
  }){
    if(PlatformUtil.isAndroid||PlatformUtil.isIOS){
      tp.cancel();
      tp.showToast(msg,tipType: tipType,duration: duration,gravity: gravity,fontSize: fontSize,backgroundColor: backgroundColor,textColor: textColor);
    }else{
      var toast = LibFToast()..init(context??LibRouteNavigatorObserver.instance.navigator!.context);
      toast.removeQueuedCustomToasts();
      toast.showToast(msg,tipType: tipType,duration: duration,gravity: gravity,fontSize: fontSize,backgroundColor: backgroundColor,textColor: textColor);
    }
  }

}