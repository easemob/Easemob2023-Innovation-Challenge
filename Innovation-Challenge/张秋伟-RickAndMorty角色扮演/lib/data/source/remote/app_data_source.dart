

import 'package:third_party_base/third_party_base.dart';
import '../../model/login_model.dart';
import 'package:rick_and_morty/data/model/params/ai_param.dart';
import 'package:rick_and_morty/data/model/responses/ai_response.dart';
import 'package:third_party_base/tools/net/dio_utli.dart';
import '../../../app/config.dart';
import '../../services/api_service.dart';

abstract class IAppDataSource {

  Future<AiResponse> chatcompletionPro(AiParma payload);
}

class AppDataSource extends BaseRemoteDataSource
    implements IAppDataSource {
  var rest = RestClient(DioUtil.getDio(VmAppConfig.baseDio));

  @override
  Future<AiResponse> chatcompletionPro(AiParma payload) {
    return rest.chatcompletionPro(payload);
  }

}
