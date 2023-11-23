
/// 业务基本异常
class BusinessErrorException implements Exception {
  final int _errorCode;
  final String? _errorMsg;

  BusinessErrorException(this._errorCode, this._errorMsg);

  int get errorCode {
    return _errorCode;
  }

  String? get errorMsg => _errorMsg;
}

/// Token超时异常
class TokenTimeOutException implements Exception {
  final String? _errorMsg;
  TokenTimeOutException(this._errorMsg);
  String? get errorMsg => _errorMsg;
}

///返回请求状态码code异常
class RequestCodeErrorException implements Exception {
  final String? _errorMsg;
  final int _errorCode;
  RequestCodeErrorException(this._errorCode, this._errorMsg);
  int get errorCode {
    return _errorCode;
  }
  String? get errorMsg => _errorMsg;
}