import 'package:rick_and_morty/data/model/ai_model.dart';
import 'package:third_party_base/third_party_base.dart';

part 'ai_response.g.dart';

@JsonSerializable()
class AiResponse{
  String reply;


  AiResponse(this.reply);

  factory AiResponse.fromJson(Map<String, dynamic> json) => _$AiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AiResponseToJson(this);
}