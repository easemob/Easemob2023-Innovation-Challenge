

import 'package:get/get.dart';
import 'package:base_lib/base_lib.dart';

class AuthenticationController extends GetxController{
  Rx<AuthenticationState> state = AuthenticationState().obs;
  Rx<AuthenticationEvent> event = AuthenticationEvent().obs;
  late IUserAuthentication iUserAuthentication;
  AuthenticationController(this.iUserAuthentication);

  void sendEvent(AuthenticationEvent event){
    this.event(event);
  }

  @override
  void onInit() {
    super.onInit();
    ever(state, (callback) {
      var value = state.value;

      if (value is AuthenticationAuthenticated) {
        iUserAuthentication.authPage();
      } else if (value is AuthenticationUnauthenticated) {
        iUserAuthentication.unAuthPage();
      }
    });

    ever(event, (callback) async {
      var value = event.value;
      if(value is AppStart){
        // 判断是否有Token
        if(iUserAuthentication.hasToken()){
          state(AuthenticationAuthenticated());
        } else {
          state(AuthenticationUnauthenticated());
        }
      }else if(value is LogIn){
        await iUserAuthentication.saveToken(value.token);
        state(AuthenticationAuthenticated());
      }else if(value is LogOut){
        iUserAuthentication.deleteToken();
        state(AuthenticationUnauthenticated());
      }
    });
  }
}