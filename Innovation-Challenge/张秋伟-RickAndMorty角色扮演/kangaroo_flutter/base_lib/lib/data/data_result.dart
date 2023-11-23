
///数据统一返回
class DataResult<T>{
  final T? data;
  DataResult(this.data);
}

///成功数据封装
class Success<T> extends DataResult<T>{
  Success(T data) : super(data);
}

///错误数据封装
class Error<T> extends DataResult<T>{
  final dynamic exception;
  Error(this.exception) : super(null);
}
