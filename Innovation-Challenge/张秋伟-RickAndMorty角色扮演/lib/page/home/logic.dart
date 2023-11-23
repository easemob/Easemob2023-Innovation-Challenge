import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:third_party_base/third_party_base.dart';
import 'state.dart';

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  void currentIndex(int currentIndex){
    state.currentIndex = currentIndex;
    update();
  }

}
