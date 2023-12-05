import 'dart:collection';

import 'package:retrofit/retrofit.dart';
import 'package:rick_and_morty/data/model/params/ai_param.dart';
import 'package:rick_and_morty/data/model/responses/ai_response.dart';
import '../../app/config.dart';
import 'api_methods.dart';
import 'package:dio/dio.dart' hide Headers;
part 'api_service.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST(ApiMethods.chatcompletionPro)
  // @Headers(
  //     "Authorization:Bearer $AI_SCRICT",
  //     "Content-Type:application/json"
  // )
  @Headers(<String, dynamic>{
    'Authorization': "Bearer ${VmAppConfig.aiScrict}",
    'Content-Type': 'application/json',
  })
  Future<AiResponse> chatcompletionPro(@Body() AiParma payload,{@Query("GroupId") int groupId = VmAppConfig.aiGroupId});

}
