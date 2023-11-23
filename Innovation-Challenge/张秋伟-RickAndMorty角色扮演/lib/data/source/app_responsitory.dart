

import 'package:rick_and_morty/data/model/params/ai_param.dart';
import 'package:rick_and_morty/data/model/responses/ai_response.dart';
import 'package:third_party_base/third_party_base.dart';
import 'remote/app_data_source.dart';

class AppResponsitory extends BaseRepository<Null, AppDataSource>
    implements IAppDataSource {
  AppResponsitory() : super(remoteDataSource: AppDataSource());

  static AppResponsitory? _instance;

  static AppResponsitory _getInstance() {
    _instance ??= AppResponsitory();
    return _instance!;
  }

  static AppResponsitory get instance => _getInstance();

  @override
  Future<AiResponse> chatcompletionPro(AiParma payload) {
    return remoteDataSource!.chatcompletionPro(payload);
  }


}