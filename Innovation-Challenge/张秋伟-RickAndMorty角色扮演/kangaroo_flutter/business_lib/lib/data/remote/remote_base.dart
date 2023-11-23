import '../model/api_result.dart';
import 'package:third_party_base/third_party_base.dart';
import 'package:dio/dio.dart';


const int httpSuccessCode = 200;
const int forbidden = 403;
const int httpTokenExt = 600;
const int httpTokenIsNot = 601;

extension SuccessExt<T> on Success<T> {
  Success<T> appSuccess() {
    var data = this.data;
    if (data is ApiResult) {
      if (data.code != httpSuccessCode) {
        switch (data.code){
          case forbidden:
            TipToast.showToast(data.message ?? LibLocalizations.getLibString().libBussinessTokenTimeOut!,tipType: TipType.warning);
            throw RequestCodeErrorException(data.code!,data.message);
          case httpTokenExt:
          case httpTokenIsNot:
            TipToast.showToast(data.message ?? LibLocalizations.getLibString().libBussinessTokenTimeOut!,tipType: TipType.warning);
            Authentication.instance.sendEvent(LogOut());
            throw TokenTimeOutException(data.message);
          // case httpErrorCode:
          //   TipToast.instance.tip(data.msg ?? LibLocalizations.getLibString().libBussinessRequestCodeError!,tipType: TipType.error);
          //   throw RequestCodeErrorException(data.code!,data.msg);
          default:
            throw BusinessErrorException(data.code!, data.message);
        }

      }
    }
    return this;
  }
}

extension ErrorExt<T> on Error<T> {
  void appError() {
    var exception = this.exception;
    if (exception is LibNetWorkException) {
      TipToast.showToast(exception.message,tipType: TipType.error);
    }
  }
}



typedef ResultF<T> = Future<ApiResult<T>> Function();

mixin RemoteBase {

  Future<DataResult<ApiResult<T>>> remoteDataResult<T>(ResultF<T> resultF) async {
    try {
      var data = await resultF.call();
      return Success(data).appSuccess();
    } on DioError catch (err, stack) {
      var e = err.error;
      LogManager.log.e(e.toString(), error: e, stackTrace: stack);
      return Error(e)..appError();
    } catch (e, stack) {
      LogManager.log.e(e.toString(), error: e, stackTrace: stack);
      return Error(e)..appError();
    }
  }

}