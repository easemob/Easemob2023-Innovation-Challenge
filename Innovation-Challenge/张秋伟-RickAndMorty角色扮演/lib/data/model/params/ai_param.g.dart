// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiParma _$AiParmaFromJson(Map<String, dynamic> json) => AiParma(
      json['tokens_to_generate'] as int,
      json['model'] as String,
      Map<String, String>.from(json['reply_constraints'] as Map),
      (json['bot_setting'] as List<dynamic>)
          .map((e) => Map<String, String>.from(e as Map))
          .toList(),
      (json['messages'] as List<dynamic>)
          .map((e) => ChatModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AiParmaToJson(AiParma instance) => <String, dynamic>{
      'tokens_to_generate': instance.tokens_to_generate,
      'model': instance.model,
      'reply_constraints': instance.reply_constraints,
      'bot_setting': instance.bot_setting,
      'messages': instance.messages,
    };
