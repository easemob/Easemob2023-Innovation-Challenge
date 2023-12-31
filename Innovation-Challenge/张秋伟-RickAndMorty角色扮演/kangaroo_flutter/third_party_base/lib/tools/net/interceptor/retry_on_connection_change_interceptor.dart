
import 'dart:async';
import 'dart:io';
import 'package:base_lib/app/application.dart';
import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/base_lib.dart';
import 'package:dio/dio.dart';

import 'error_interceptor.dart';

/// 重试拦截器
class RetryOnConnectionChangeInterceptor extends Interceptor {
  Dio? dio;

  RequestInterceptorHandler? mHandler;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    mHandler = handler;
    super.onRequest(options, handler);
  }


  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async{
    if (dio!=null&&Application.config.httpConfig.retry&&await _shouldRetry(err)) {
      return await retryLoop(err,handler,1);
    }
    return super.onError(err, handler);
  }

  Future retryLoop(DioError err, ErrorInterceptorHandler handler,int retry) async {
    try {
      LogManager.log.d("${err.requestOptions.uri.toString()} retry : $retry",tag: "${SysConfig.libNetTag}Retry");
      await retryHttp(err,handler);
    } on DioError catch (err) {
      if(await _shouldRetry(err)&&retry<Application.config.httpConfig.retryCount){
        await retryLoop(err,handler,retry+1);
      }else{
        return super.onError(err, handler);
      }
    }
  }

  Future retryHttp(DioError err, ErrorInterceptorHandler handler) async {
    RequestOptions requestOptions = err.requestOptions;
    Options options = Options(
      method: requestOptions.method,
      sendTimeout: requestOptions.sendTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
      extra: requestOptions.extra,
      headers: requestOptions.headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      validateStatus: requestOptions.validateStatus,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      followRedirects: requestOptions.followRedirects,
      maxRedirects: requestOptions.maxRedirects,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      listFormat: requestOptions.listFormat,
    );

    var res = await dio?.request(
      requestOptions.path,
      cancelToken: requestOptions.cancelToken,
      data: requestOptions.data,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );

    return handler.resolve(res!);
  }

  ///要重试的类型
  Future<bool> _shouldRetry(DioError err) async{
    return err.error != null && err.error is SocketException && await ConnectManager.connect.isConnected();
  }
}