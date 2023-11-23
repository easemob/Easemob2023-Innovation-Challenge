import 'package:base_lib/app/sys_config.dart';
import 'package:business_lib/app/business_config.dart';
import 'package:dio/dio.dart';
import 'package:third_party_base/third_party_base.dart';

class TokenInterceptor extends Interceptor {

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    saveToken(response);
    super.onResponse(response, handler);
  }

  void saveToken(Response? response){
    if(response!=null){
      var token = response.headers.value(BusinessConfig.responseAuthHeader);
      LogManager.log.d("TokenInterceptor onResponse",tag: SysConfig.libNetTag);
      if(token!=null){
        SysStore.putSysNetToken(token);
        HttpPersistent.setPersistent(
            AppEnvironment.envConfig![AppConfig.apiName]!,
            BusinessConfig.requestAuthHeader,
            token,
            type: HttpPersistent.headerPresistent);
      }
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    saveToken(err.response);
    super.onError(err, handler);
  }

}

