

import 'dart:io';
import 'package:base_lib/app/application.dart';
import 'package:base_lib/tools/image/mime_converter.dart';
import 'package:dio/dio.dart';
import 'package:third_party_base/tools/net/interceptor/lib_log_interceptor.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:clock/clock.dart';

class LibCacheManager {
  static const key = 'libCacheKey';

  ///缓存配置 {最多缓存 100 个文件，并且每个文件只应缓存 7天}
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
        fileService : DioHttpFileService(Dio()..interceptors.add(LibLogInterceptor(requestBody: Application.config.debugState,responseBody: Application.config.debugState)))
    ),
  );

}


class DioHttpFileService extends FileService {
  final Dio _dio;

  DioHttpFileService(this._dio);

  @override
  Future<FileServiceResponse> get(String url, {Map<String, String>? headers}) async {
    Options options = Options(headers: headers ?? {}, responseType: ResponseType.stream);
    Response<ResponseBody> httpResponse = await _dio.get<ResponseBody>(url, options: options);
    return DioGetResponse(httpResponse);
  }
}

class DioGetResponse implements FileServiceResponse {
  DioGetResponse(this._response);

  final DateTime _receivedTime = clock.now();

  final Response<ResponseBody> _response;

  @override
  int get statusCode => _response.statusCode!;


  @override
  Stream<List<int>> get content => _response.data!.stream;

  @override
  int? get contentLength => _getContentLength();

  int _getContentLength() {
    try {
      return int.parse(
          _header(HttpHeaders.contentLengthHeader) ?? '-1');
    } catch (e) {
      return -1;
    }
  }

  String? _header(String name) {
    return _response.headers[name]?.first;
  }


  @override
  DateTime get validTill {
    // Without a cache-control header we keep the file for a week

    var ageDuration = const Duration(days: 7);
    final controlHeader = _header(HttpHeaders.cacheControlHeader);
    if (controlHeader != null) {
      final controlSettings = controlHeader.split(',');
      for (final setting in controlSettings) {
        final sanitizedSetting = setting.trim().toLowerCase();
        if (sanitizedSetting == 'no-cache') {
          ageDuration = const Duration();
        }
        if (sanitizedSetting.startsWith('max-age=')) {
          var validSeconds = int.tryParse(sanitizedSetting.split('=')[1]) ?? 0;
          if (validSeconds > 0) {
            ageDuration = Duration(seconds: validSeconds);
          }
        }
      }
    }

    return _receivedTime.add(ageDuration);
  }

  @override
  String? get eTag => _header(HttpHeaders.etagHeader);

  @override
  String get fileExtension {
    var fileExtension = '';
    final contentTypeHeader = _header(HttpHeaders.contentTypeHeader);
    if (contentTypeHeader != null) {
      final contentType = ContentType.parse(contentTypeHeader);
      fileExtension = contentType.fileExtension;
    }
    return fileExtension;
  }
}

///Converts the most common MIME types to the most expected file extension.
extension ContentTypeConverter on ContentType {
  String get fileExtension => mimeTypes[mimeType] ?? '.$subType';
}
