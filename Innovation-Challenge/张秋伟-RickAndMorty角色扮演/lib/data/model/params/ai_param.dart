import 'package:third_party_base/third_party_base.dart';

import '../chat_model.dart';

part 'ai_param.g.dart';

@JsonSerializable()
class AiParma{
  int tokens_to_generate;
  String model;
  Map<String,String> reply_constraints;
  List<Map<String,String>> bot_setting;
  List<ChatModel> messages;


  AiParma(this.tokens_to_generate, this.model, this.reply_constraints,
      this.bot_setting, this.messages);

  factory AiParma.fromJson(Map<String, dynamic> json) => _$AiParmaFromJson(json);
  Map<String, dynamic> toJson() => _$AiParmaToJson(this);
}