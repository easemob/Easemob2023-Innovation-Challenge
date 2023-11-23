import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:third_party_base/app/init/lib_base_init.dart';
import 'package:third_party_base/third_party_base.dart';
// import '../../data/model/login_model.dart';
// import '../../data/source/app_responsitory.dart';
import 'state.dart';

class LoginLogic extends GetxController  {
  final LoginState state = LoginState();


  @override
  void onReady() {
    super.onReady();
    // AccountResponsitory.instance.login(LoginModel("123","123"));
  }


  void login(String userName,String password) async{
    EasyLoading.show(status: '登录中',maskType: EasyLoadingMaskType.black);
    try {
      await EMClient.getInstance.login(userName, SecretUtil.hashMD5(password));
      SysStore.putSysNetToken(userName);
      EasyLoading.dismiss();
      TipToast.showToast("登录成功");
      Authentication.instance.sendEvent(LogIn());
    } on EMError catch (e) {
      EasyLoading.dismiss();
      TipToast.showToast(e.description);
    }
  }

  void obscure(){
    state.isObscure = !state.isObscure;
    state.eyeColor = (state.isObscure ? Colors.grey : LibColors.libColorRoyalblue);
    update();
  }


}
