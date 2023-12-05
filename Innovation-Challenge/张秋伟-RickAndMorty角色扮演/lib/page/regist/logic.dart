import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:third_party_base/third_party_base.dart';

import '../../data/model/login_model.dart';
import 'state.dart';

class RegistLogic extends GetxController with WidgetsBindingObserver{
  final RegistState state = RegistState();

  void obscure(){
    state.isObscure = !state.isObscure;
    state.eyeColor = (state.isObscure ? Colors.grey : LibColors.libColorRoyalblue);
    update();
  }


  void regist(String userName,String password) async{
    EasyLoading.show(status: '注册中',maskType: EasyLoadingMaskType.black);

    try {
      await EMClient.getInstance.createAccount(userName,SecretUtil.hashMD5(password));
      EasyLoading.dismiss();
      Get.back(result: LoginModel(userName,password));
    } on EMError catch (e) {
      EasyLoading.dismiss();
      TipToast.showToast(e.description);
    }
    // var data = await AccountResponsitory.instance.regist(LoginModel(userName,SecretUtil.hashMD5(password)));
    // EasyLoading.dismiss();
    // if(data is Success){
    //   TipToast.showToast(data.data!.message!);
    //   Get.back(result: LoginModel(userName,password));
    // }else if (data is Error){
    //   final error = (data as Error);
    //   if (error.exception is BusinessErrorException) {
    //     final exc = error.exception as BusinessErrorException;
    //     TipToast.showToast(exc.errorMsg!);
    //   }
    // }
  }
}
