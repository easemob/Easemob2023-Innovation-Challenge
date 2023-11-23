


import 'package:base_lib/tools/tip/i_tip.dart';
import 'package:base_lib/tools/tip/tip.dart';
import 'package:flutter/material.dart';

class LibTip implements ITip{
  final ITip _realTip;

  const LibTip(this._realTip);

  @override
  void cancel() {
    _realTip.cancel();
  }

  @override
  void showToast(String msg, {TipType tipType = TipType.normal, TipDuration duration = TipDuration.LENGTH_SHORT, TipGravity gravity = TipGravity.BOTTOM, double fontSize = 14, Color? backgroundColor, Color textColor = Colors.white}) {
    _realTip.showToast(msg,tipType: tipType,duration: duration,gravity: gravity,fontSize: fontSize,backgroundColor: backgroundColor??tipType.backColor,textColor: textColor);
  }

  @override
  TransitionBuilder builder() => _realTip.builder();

  @override
  IFTip ifTip() => _realTip.ifTip();

}