

import 'package:base_lib/base_lib.dart';
import 'package:base_lib/tools/tip/tip.dart';
import 'package:flutter/material.dart';
import 'i_tip.dart';

class LibFToast implements IFTip{

  final IFTip _realTip;
  LibFToast():_realTip= TipToast.tp.ifTip();

  @override
  void init(BuildContext context) => _realTip.init(context);

  @override
  void removeCustomToast() => _realTip.removeCustomToast();

  @override
  void removeQueuedCustomToasts() => _realTip.removeQueuedCustomToasts();

  @override
  void showToast(String msg, {TipType tipType = TipType.normal, TipDuration duration = TipDuration.LENGTH_SHORT, TipGravity gravity = TipGravity.BOTTOM, double fontSize = 14, Color? backgroundColor, Color textColor = Colors.white}) {
    _realTip.showToast(msg,tipType: tipType,duration: duration,gravity: gravity,fontSize: fontSize,backgroundColor: backgroundColor??tipType.backColor,textColor: textColor);
  }

}