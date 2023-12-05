import 'package:flutter_test/flutter_test.dart';
import 'package:third_party_base/third_party_base.dart';
import 'package:third_party_base/third_party_base_platform_interface.dart';
import 'package:third_party_base/third_party_base_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockThirdPartyBasePlatform
    with MockPlatformInterfaceMixin
    implements ThirdPartyBasePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ThirdPartyBasePlatform initialPlatform = ThirdPartyBasePlatform.instance;

  test('$MethodChannelThirdPartyBase is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelThirdPartyBase>());
  });

  test('getPlatformVersion', () async {
    ThirdPartyBase thirdPartyBasePlugin = ThirdPartyBase();
    MockThirdPartyBasePlatform fakePlatform = MockThirdPartyBasePlatform();
    ThirdPartyBasePlatform.instance = fakePlatform;

    expect(await thirdPartyBasePlugin.getPlatformVersion(), '42');
  });
}
