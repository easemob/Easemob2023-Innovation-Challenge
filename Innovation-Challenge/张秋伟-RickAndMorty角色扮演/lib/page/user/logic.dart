import 'package:get/get.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:third_party_base/third_party_base.dart';


class UserLogic extends GetxController {

  void logout() async{
    try {
      await EMClient.getInstance.logout(true);
      Authentication.instance.sendEvent(LogOut());
    } on EMError catch (e) {
      EasyLoading.dismiss();
      TipToast.showToast(e.description);
    }
  }

}
