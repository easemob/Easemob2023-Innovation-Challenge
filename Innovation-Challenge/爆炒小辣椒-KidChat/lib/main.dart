import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:kid_chat/app.dart';
import 'package:kid_chat/utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  GetStorage.init();

  _initialEasemob();

  runApp(const KidChatApp());
}

void _initialEasemob() async {
  final options = EMOptions(
    appKey: Constants.emAppKey,
    deleteMessagesAsExitGroup: false,
  );

  EMClient.getInstance.init(options);
}
