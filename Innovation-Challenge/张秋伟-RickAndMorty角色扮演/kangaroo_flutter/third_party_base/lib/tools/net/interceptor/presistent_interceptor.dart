
import 'package:base_lib/tools/net/http_persistent.dart';
import 'package:dio/dio.dart';

/// 持久化处理拦截器
class PresistentInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var urlPersitents = HttpPersistent.getPersistent(options.baseUrl,type: HttpPersistent.urlPresistent);
    var headerPersitents = HttpPersistent.getPersistent(options.baseUrl,
        type: HttpPersistent.headerPresistent);
    headerPersitents?.forEach((key, value) {
      options.headers[key] = value;
    });

    urlPersitents?.forEach((key, value) {
      options.queryParameters[key] = value;
    });
    super.onRequest(options, handler);
  }

}