
import 'package:base_lib/app/application.dart';
import 'package:base_lib/tools/platform_util.dart';
import 'package:third_party_base/app/init/lib_base_init.dart';

import 'third_party_base_platform_interface.dart';
import 'tools/privacy_utils.dart';

export 'package:base_lib/base_lib.dart';
export 'package:base_ui/base_ui.dart';
export 'package:flutter_ulog/flutter_ulog.dart';
export 'package:retrofit/retrofit.dart';
export 'package:json_annotation/json_annotation.dart';
export 'package:flutter_easyloading/flutter_easyloading.dart';
export 'tools/net/interceptor/time_interceptor.dart';
export 'tools/net/interceptor/retry_on_connection_change_interceptor.dart';
export 'tools/net/interceptor/error_interceptor.dart';
export 'tools/net/interceptor/lib_log_interceptor.dart';
export 'tools/net/interceptor/presistent_interceptor.dart';

class ThirdPartyBase {

  Future<void> init() async{
    var init = await ThirdPartyBasePlatform.instance.init();
    var privacy = PrivacyUtils.getPrivacy();
    if(PlatformUtil.isAndroid){
      if(privacy){
        (Application.initImpl as LibBaseInit).thirdPartyForAndroid();
      }
    }else{
      (Application.initImpl as LibBaseInit).otherthirdParty();
    }
    return init;
  }

  Future<void> update(bool privacy) async{
    await PrivacyUtils.setPrivacy(privacy);
    var update = await ThirdPartyBasePlatform.instance.update();
    if(PlatformUtil.isAndroid){
      if(privacy){
        (Application.initImpl as LibBaseInit).thirdPartyForAndroid();
      }
    }
    return update;
  }

}
