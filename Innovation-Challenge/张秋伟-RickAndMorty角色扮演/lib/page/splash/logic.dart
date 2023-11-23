import 'package:get/get.dart';
import 'package:third_party_base/third_party_base.dart';
import 'package:base_lib/auth/authentication_event.dart';


class SplashLogic extends GetxController {

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(seconds: 3));
    Authentication.instance.sendEvent(AppStart());
  }

}
