import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:business_plugin_update/business_plugin_update.dart';
import 'package:business_plugin_update/src/update_dialog.dart';
import 'package:package_info/package_info.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage()
    );
  }


}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }

}

class _HomePage extends State<HomePage> {

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _initData();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await BusinessPluginUpdate.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }
  String vInfo = '';
  String progress = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('版本升级'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                color: Colors.black38,
                onPressed: _updateVersion,
                child: Text('版本升级')
            ),
            Container(
              child: Text('$vInfo'),
            ),
            Container(
              child: Text('$progress'),
            ),
          ],
        ),
      ),
    );
  }


  void _initData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    setState(() {
      vInfo = Platform.isIOS ? 'iOS_$version' : 'android_$version';
    });
  }

  void _updateVersion() async{

    UpdateService.instance.checkNewVersion(context,
        UpdateAndroid(update: UpdateType.yes,updateLog: "123",constraint: false,newVersion: "123.1",targetSize: "10m",
          apkFileUrl: "itms-apps://itunes.apple.com/cn/app/id414478124?mt=8",
          updateDefDialogTitle: "title",
        ));
  }


  UpdateDialog? dialog;

  void defaultStyle() {
    if (dialog != null && dialog!.isShowing()) {
      return;
    }
    dialog = UpdateDialog.showUpdate(context,
        title: '是否升级到4.1.4版本？',
        updateContent: '新版本大小:2.0M\n1.xxxxxxx\n2.xxxxxxx\n3.xxxxxxx',
        onUpdate: onUpdate);
  }
  double progresspp = 0.0;

  void onUpdate() {
    Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      progresspp = progresspp + 0.02;
      if (progresspp > 1.0001) {
        timer.cancel();
        dialog!.dismiss();
        progresspp = 0;
      } else {
        dialog!.update(progresspp);
      }
    });
  }

}