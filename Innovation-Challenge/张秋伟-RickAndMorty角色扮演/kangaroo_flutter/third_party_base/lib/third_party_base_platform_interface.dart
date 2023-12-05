import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'third_party_base_method_channel.dart';

abstract class ThirdPartyBasePlatform extends PlatformInterface {
  /// Constructs a ThirdPartyBasePlatform.
  ThirdPartyBasePlatform() : super(token: _token);

  static final Object _token = Object();

  static ThirdPartyBasePlatform _instance = MethodChannelThirdPartyBase();

  /// The default instance of [ThirdPartyBasePlatform] to use.
  ///
  /// Defaults to [MethodChannelThirdPartyBase].
  static ThirdPartyBasePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ThirdPartyBasePlatform] when
  /// they register themselves.
  static set instance(ThirdPartyBasePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init();

  Future<void> update();

}
