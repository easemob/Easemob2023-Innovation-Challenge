import 'package:base_lib/app/application.dart';
import 'package:base_lib/tools/platform_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:third_party_base/tools/privacy_utils.dart';
import 'dart:io';
import 'third_party_base_platform_interface.dart';

/// An implementation of [ThirdPartyBasePlatform] that uses method channels.
class MethodChannelThirdPartyBase extends ThirdPartyBasePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('third_party_base');

  @override
  Future<void> init() async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['debugStatic'] = Application.config.debugState;
    params['privacy'] = PrivacyUtils.getPrivacy();
    if(PlatformUtil.isAndroid){
      return await methodChannel.invokeMethod('init',params);
    }else{
      return;
    }
  }

  @override
  Future<void> update() async {
    Map<String, dynamic> params = <String, dynamic>{};
    params['privacy'] = PrivacyUtils.getPrivacy();
    if(PlatformUtil.isAndroid){
      return await methodChannel.invokeMethod('update',params);
    }else{
      return;
    }
  }
}
