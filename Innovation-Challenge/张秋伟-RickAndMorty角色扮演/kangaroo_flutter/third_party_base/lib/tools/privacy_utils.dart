

import 'package:base_lib/base_lib.dart';

import '../app/third_party_contants.dart';

class PrivacyUtils{

  static bool getPrivacy(){
    return StoreManager.store.getBool(ThirdPartContants.privacy) ?? false;
  }

  static Future<bool> setPrivacy(bool privacy) async{
    return StoreManager.store.setBool(ThirdPartContants.privacy, privacy);
  }

  static Future<bool> clearPrivacy() async{
    return StoreManager.store.remove(ThirdPartContants.privacy);
  }

}