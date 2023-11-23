import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:third_party_base/third_party_base.dart';

import '../../app/config.dart';
import 'logic.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key? key}) : super(key: key);

  final logic = Get.put(SplashLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255,17,17,17),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Center(
              child: Image.asset(
                '${VmAppConfig.img}background.png',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 150),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(BaseInit.appName,style: const TextStyle(fontSize: 25,color: Colors.white),)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
