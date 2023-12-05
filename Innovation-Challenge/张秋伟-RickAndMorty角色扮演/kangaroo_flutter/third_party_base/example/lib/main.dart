import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:third_party_base/third_party_base.dart';

import 'app.dart';
import 'app/app_init.dart';

void main() {
  Application.init(AppInit(ConfigBuilder()
          .setDebugState(true)
          .setLibLog(ULogLibLogBuilder().build())
          .build(),ULogLibConfigBuilder().setTag("my-app").build()),
      syncinitFin: () {
        runApp(const MyApp());
      });
}

