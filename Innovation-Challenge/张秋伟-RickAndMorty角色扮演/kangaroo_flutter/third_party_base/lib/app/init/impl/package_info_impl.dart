
import 'dart:io';

import 'package:base_lib/tools/platform_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:base_lib/base_lib.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PackageInfoImpl implements IPackageInfo{

  @override
  Future<PackageModel> getPackageModel() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    BaseDeviceInfo da = await deviceInfo.deviceInfo;
    String uni;
    if(PlatformUtil.isWindows){
      uni = SecretUtil.hashMD5(da.toString()+packageInfo.packageName+Directory.current.path);
    }else{
      uni = SecretUtil.hashMD5(da.toString()+packageInfo.packageName);
    }
    return PackageModel(packageInfo.appName, packageInfo.packageName, packageInfo.version, packageInfo.buildNumber,uni);
  }

}