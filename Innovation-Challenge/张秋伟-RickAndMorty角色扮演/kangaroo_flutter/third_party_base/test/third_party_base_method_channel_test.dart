import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:third_party_base/third_party_base_method_channel.dart';

void main() {
  MethodChannelThirdPartyBase platform = MethodChannelThirdPartyBase();
  const MethodChannel channel = MethodChannel('third_party_base');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
