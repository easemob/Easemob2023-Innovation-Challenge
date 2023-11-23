import 'package:third_party_base/third_party_base.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel{
  String sender_type;
  String sender_name;
  String text;


  ChatModel(this.sender_type, this.sender_name, this.text);

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}