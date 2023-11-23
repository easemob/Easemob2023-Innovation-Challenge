

import 'package:flutter/material.dart';

enum TipType {
  normal(Colors.black),
  info(Color(0xff3F51B5)),
  success(Color(0xff388E3C)),
  warning(Color(0xffFFA900)),
  error(Color(0xffD50000));

  final Color backColor;
  const TipType(this.backColor);


}