// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestClient implements RestClient {
  _RestClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AiResponse> chatcompletionPro(
    payload, {
    groupId = VmAppConfig.aiGroupId,
  }) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'GroupId': groupId};
    final _headers = <String, dynamic>{
      r'Authorization':
          'Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJOYW1lIjoiYWnmi5vogZgiLCJTdWJqZWN0SUQiOiIxNjk4ODA2NjA4MzYxMjY5IiwiUGhvbmUiOiJNVFUyTWpBMk9UTXpPVFE9IiwiR3JvdXBJRCI6IjE2OTg4MDY2MDg3NjAzNzQiLCJQYWdlTmFtZSI6IiIsIk1haWwiOiIyOTcxNjUzMzFAcXEuY29tIiwiQ3JlYXRlVGltZSI6IjIwMjMtMTEtMTMgMTA6MTA6MTYiLCJpc3MiOiJtaW5pbWF4In0.SAzdLRUccgR-X9p6GkOkTR-PO9GR1uUOnv_sLzun0P3jGREr8dwUcS7kGIc32Y-G7VihI0z4WVA5-5ITbYFzceXwxRnrtMGvV5HssYx2OXXKzBY2n6BT53EKqVAnA5_JtgAzT-GIagUjZZx-ykIm5otCrJnpm4Jar-CiUNXA1G_pt5mdcR4oqDa5QvCKApIkScs52Q0CYGmJLsxfYx2eAQjnNkNDuHDwLN98PKiHJlr65IZZ7cy-wgkgE_Z478jV5cRZX3bym95aKMc0q4orqUFVGNxmf735owDBEwxqfRe4MZb5eJKHqvGVDKgZYgSgWC1ttojwWopR113cPDTFng',
      r'Content-Type': 'application/json',
    };
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(payload.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<AiResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/json',
    )
            .compose(
              _dio.options,
              'v1/text/chatcompletion_pro',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AiResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
