

import 'package:base_lib/tools/platform_util.dart';
import 'package:universal_platform/universal_platform.dart';

class PlatformImpl implements IPlatform{
  @override
  bool isAndroid() => UniversalPlatform.isAndroid;

  @override
  bool isFuchsia() => UniversalPlatform.isFuchsia;

  @override
  bool isIOS() => UniversalPlatform.isIOS;

  @override
  bool isLinux() => UniversalPlatform.isLinux;

  @override
  bool isMacOS() => UniversalPlatform.isMacOS;

  @override
  bool isWeb() => UniversalPlatform.isWeb;
  @override
  bool isWindows() => UniversalPlatform.isWindows;

}