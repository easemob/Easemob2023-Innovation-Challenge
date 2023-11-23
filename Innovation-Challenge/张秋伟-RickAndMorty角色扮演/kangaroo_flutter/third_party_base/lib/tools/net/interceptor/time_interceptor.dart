import 'package:base_lib/app/sys_config.dart';
import 'package:dio/dio.dart';

class TimeInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Map<String, dynamic> extra = options.extra;
    bool connect = extra.containsKey(SysConfig.connectTimeout);
    bool receive = extra.containsKey(SysConfig.receiveTimeOut);
    if(connect||receive){
      if(connect){
        int connectTimeout = options.extra[SysConfig.connectTimeout];
        options.connectTimeout = Duration(milliseconds: connectTimeout);
      }
      if(receive){
        int receiveTimeOut = options.extra[SysConfig.receiveTimeOut];
        options.receiveTimeout = Duration(milliseconds: receiveTimeOut);
      }
    }
    super.onRequest(options, handler);

  }

}

