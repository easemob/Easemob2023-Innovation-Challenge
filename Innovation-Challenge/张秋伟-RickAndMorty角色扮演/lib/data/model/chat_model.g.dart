// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      json['sender_type'] as String,
      json['sender_name'] as String,
      json['text'] as String,
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'sender_type': instance.sender_type,
      'sender_name': instance.sender_name,
      'text': instance.text,
    };
