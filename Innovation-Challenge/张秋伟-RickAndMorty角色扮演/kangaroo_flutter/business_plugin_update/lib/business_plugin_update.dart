
import 'dart:async';

import 'package:flutter/services.dart';
export 'package:ota_update/ota_update.dart';
export 'package:business_plugin_update/src/update.dart';
export 'package:business_plugin_update/src/update_service.dart';
export 'package:business_plugin_update/src/update_localizations.dart';
//
// class BusinessPluginUpdate {
//   static const MethodChannel _channel = MethodChannel('business_plugin_update');
//
//   static void init(){
//     _channel.setMethodCallHandler((call) async {
//       switch(call.method) {
//         case "download": {
//           //监听器
//           return "成功";
//         }
//         case "appConfig": {
//           //监听器
//           return "成功";
//         }
//         case "appfile": {
//           //监听器
//           return "成功";
//         }
//         case "notification": {
//           return "成功";
//         }
//       }
//       return null;
//     });
//   }
//
//   static Future<String?> get platformVersion async {
//     final String? version = await _channel.invokeMethod('getPlatformVersion');
//     return version;
//   }
// }
