

import 'dart:io';

import 'package:base_lib/app/application.dart';
import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/base_lib.dart';
import 'package:base_lib/tools/net/http_config.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'interceptor/error_interceptor.dart';
import 'interceptor/lib_log_interceptor.dart';
import 'interceptor/presistent_interceptor.dart';
import 'interceptor/retry_on_connection_change_interceptor.dart';
import 'interceptor/time_interceptor.dart';

class DioUtil{

  final String _baseUrl;
  final HttpConfig _config;
  final List<Interceptor> _interceptors;

  late Dio _dio;

  Dio get dio{
    return _dio;
  }

  DioUtil._internal(this._baseUrl, this._config, this._interceptors){
    BaseOptions options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: Duration(milliseconds: _config.connectTimeout),
      receiveTimeout: Duration(milliseconds: _config.receiveTimeOut),
    );
    _dio = Dio(options);
    var retry = Dio(options);
    for (var element in _interceptors) {
      if(element is RetryOnConnectionChangeInterceptor){
        element.dio = retry;
      }else{
        if(element is! ErrorInterceptor){
          retry.interceptors.add(element);
        }
      }
      _dio.interceptors.add(element);
    }
    proxy(_dio);
    proxy(retry);
  }

  void proxy(Dio dio){
    if (StoreManager.store.getBool(SysConfig.PROXY_ENABLE)??false) {
      String? porxy = StoreManager.store.getString(SysConfig.PROXY_IP_PROT);
      if(porxy!=null){
        (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.findProxy = (uri) {
            return "PROXY $porxy";
          };
          //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
        };
      }
    }
  }

  static final Map<String,DioUtil> _dioUtils = {};

  static DioUtil instance(String baseUrl,{HttpConfig? config, List<Interceptor>? interceptors,List<Interceptor>? applyInterceptors}){
    if(!_dioUtils.containsKey(baseUrl)){
      List<Interceptor> list = [PresistentInterceptor(),TimeInterceptor(),RetryOnConnectionChangeInterceptor(),LibLogInterceptor(requestBody: Application.config.debugState,responseBody: Application.config.debugState),ErrorInterceptor()];
      var inter = interceptors??list;
      if(applyInterceptors!=null){
        inter.addAll(applyInterceptors);
      }
      _dioUtils[baseUrl] = DioUtil._internal(baseUrl,config??Application.config.httpConfig,inter);
    }
    return _dioUtils[baseUrl]!;
  }

  static final Map<String,Dio> _dioB = {};

  static void add(String key,Dio dio){
    _dioB[key] = dio;
  }

  static Dio getDio(String key) => _dioB[key]!;


}