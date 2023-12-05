

import 'package:base_lib/base_lib.dart';
import 'package:get/get.dart';

import 'authentication_controller.dart';


class AuthenticationGetx extends IAuthentication{
  @override
  void init(IUserAuthentication iUserAuthentication) {
    Get.put(AuthenticationController(iUserAuthentication));
  }

  @override
  void sendEvent(AuthenticationEvent event) {
    Get.find<AuthenticationController>().sendEvent(event);
  }
}
