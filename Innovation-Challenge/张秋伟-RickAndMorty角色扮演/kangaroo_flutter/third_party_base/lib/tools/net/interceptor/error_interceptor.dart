
import 'dart:io';

import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/base_lib.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Future<bool> isConnected() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   return connectivityResult != ConnectivityResult.none;
// }

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
// 是否有网

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    DioError newErr;
    if (err.type == DioErrorType.unknown) {
      bool isConnectNetWork = await ConnectManager.connect.isConnected();
      if (!isConnectNetWork && err.error is SocketException) {
        newErr = err.copyWith(error: SocketException(LibLocalizations.getLibString().libNetWorkNoConnect!));
      }else if (err.error is SocketException){
        newErr = err.copyWith(error: SocketException(LibLocalizations.getLibString().libNetWorkError!));
      }
    }
    newErr = err.copyWith(error: LibNetWorkException.create((){
      switch (err.type) {
        case DioErrorType.cancel:{
          return LibNetWorkException(-1, LibLocalizations.getLibString().libNetRequestCancel!);
        }
        case DioErrorType.connectionTimeout:{
          return LibNetWorkException(-1, LibLocalizations.getLibString().libNetFailCheck!);
        }
        case DioErrorType.sendTimeout:{
          return LibNetWorkException(-1, LibLocalizations.getLibString().libNetTimeOutCheck!);
        }
        case DioErrorType.receiveTimeout:{
          return LibNetWorkException(-1, LibLocalizations.getLibString().libNetResponseTimeOut!);
        }
        case DioErrorType.badResponse:{
          try{
            return LibNetWorkException(err.response!.statusCode!,"HTTP ${err.response!.statusCode!}:${LibLocalizations.getLibString().libNetServerError!}");
          } catch (_) {
            return LibNetWorkException(-1, "${LibLocalizations.getLibString().libNetDataError!}:${err.error.toString()}");
          }
        }
        case DioErrorType.unknown:{
          if (err.error is SocketException) {
            return LibNetWorkException(-1, (err.error as SocketException).message);
          } else {
            return LibNetWorkException(-1, err.error.toString());
          }
        }
        case DioErrorType.connectionError:{
          return LibNetWorkException(-1, LibLocalizations.getLibString().libNetConnectionError!);
        }
        default:{
          return LibNetWorkException(-1, err.error.toString());
        }
      }
    }));
    LogManager.log.d('DioError : ${newErr.error.toString()}',tag: "${SysConfig.libNetTag}Interceptor");
    super.onError(newErr, handler);
  }

}