
///存储异常
class LibStorageException implements Exception{

  final String _message;

  String get message{
    return _message;
  }

  LibStorageException(this._message);

  @override
  String toString() {
    return "$_message";
  }
}
///存储警告异常
class LibWarningStorageException implements Exception{

  final String _message;

  String get message{
    return _message;
  }

  LibWarningStorageException(this._message);

  @override
  String toString() {
    return "$_message";
  }
}