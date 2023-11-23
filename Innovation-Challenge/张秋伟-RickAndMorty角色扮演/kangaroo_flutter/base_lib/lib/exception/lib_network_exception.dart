typedef CreateNetError = LibNetWorkException Function();

///网络异常
class LibNetWorkException implements Exception{

  final String _message;
  final int _code;

  int get code{
    return _code;
  }

  String get message{
    return _message;
  }

  LibNetWorkException( this._code,this._message);

  @override
  String toString() {
    return "$_code : $_message";
  }

  factory LibNetWorkException.create(CreateNetError fun) {
    return fun();
  }
}

