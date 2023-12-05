

import 'dart:ui';

import 'package:base_lib/base_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

///支持全部平台
class FTip implements IFTip{
  FToast fToast;
  FTip(): fToast = FToast();

  @override
  void init(BuildContext context) => fToast.init(context);

  @override
  void removeCustomToast() => fToast.removeCustomToast();

  @override
  void removeQueuedCustomToasts() => fToast.removeQueuedCustomToasts();

  @override
  void showToast(String msg, {TipType tipType = TipType.normal, TipDuration duration = TipDuration.LENGTH_SHORT, TipGravity gravity = TipGravity.BOTTOM, double fontSize = 14, Color? backgroundColor, Color textColor = Colors.white}) {

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

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
      ),
      child: Text(msg,style: TextStyle(fontSize: fontSize,color: textColor),),
    );
    fToast.showToast(
      child: toast,
      gravity: grav,
      toastDuration:Duration(seconds: duration.timeSec),
    );
  }

}