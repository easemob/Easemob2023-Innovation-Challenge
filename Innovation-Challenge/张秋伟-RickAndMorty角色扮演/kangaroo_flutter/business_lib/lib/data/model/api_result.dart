
import 'package:third_party_base/third_party_base.dart';

import 'page_entity.dart';
@JsonSerializable(genericArgumentFactories: true)
class ApiResult<T> {
  int? code;
  String? message;
  T? data;
  PageEntity? page;

  ApiResult({this.code, this.message, this.data,this.page});

  factory ApiResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$ApiResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResultToJson(this, toJsonT);
}



ApiResult<T> _$ApiResultFromJson<T>(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
    ) =>
    ApiResult<T>(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      page: json['page'] == null
          ? null
          : PageEntity.fromJson(json['page'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiResultToJson<T>(
    ApiResult<T> instance,
    Object? Function(T value) toJsonT,
    ) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'page': instance.page,
    };

T? _$nullableGenericFromJson<T>(
    Object? input,
    T Function(Object? json) fromJson,
    ) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
    T? input,
    Object? Function(T value) toJson,
    ) =>
    input == null ? null : toJson(input);
