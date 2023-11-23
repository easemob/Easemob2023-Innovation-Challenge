
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:base_lib/base_lib.dart';
import 'package:third_party_base/tools/tip/f_tip.dart';
///支持IOS,ANDROID,WEB平台
class TipImpl implements ITip{
  @override
  void cancel() {
    Fluttertoast.cancel();
  }

  @override
  void showToast(String msg, {TipType tipType = TipType.normal, TipDuration duration = TipDuration.LENGTH_SHORT, TipGravity gravity = TipGravity.BOTTOM, double fontSize = 14, Color? backgroundColor, Color textColor = Colors.white}) {
    Toast toast = Toast.LENGTH_SHORT;
    switch(duration){
      case TipDuration.LENGTH_SHORT:
        toast = Toast.LENGTH_SHORT;
        break;
      case TipDuration.LENGTH_LONG:
        toast = Toast.LENGTH_LONG;
        break;
    }
    ToastGravity grav = ToastGravity.BOTTOM;
    switch(gravity){
      case TipGravity.BOTTOM:
        grav = ToastGravity.BOTTOM;
        break;
      case TipGravity.CENTER:
        grav = ToastGravity.CENTER;
        break;
      case TipGravity.TOP:
        grav = ToastGravity.TOP;
        break;
    }
    Fluttertoast.showToast(msg: msg,toastLength: toast,timeInSecForIosWeb: duration.timeSec,fontSize: fontSize,backgroundColor: backgroundColor,textColor: textColor,gravity: grav);
  }

  @override
  TransitionBuilder builder() => FToastBuilder();

  @override
  IFTip ifTip() => FTip();

}