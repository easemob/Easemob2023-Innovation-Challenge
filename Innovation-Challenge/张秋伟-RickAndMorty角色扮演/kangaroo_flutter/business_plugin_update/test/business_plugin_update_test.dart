import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:business_plugin_update/business_plugin_update.dart';

void main() {
  const MethodChannel channel = MethodChannel('business_plugin_update');

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
    expect(await BusinessPluginUpdate.platformVersion, '42');
  });
}
