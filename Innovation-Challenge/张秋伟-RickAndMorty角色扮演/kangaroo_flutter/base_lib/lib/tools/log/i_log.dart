

abstract class ILog{

  void d(dynamic message,{String? tag});
  void i(dynamic message,{String? tag});
  void w(dynamic message,{String? tag});
  void e(dynamic message,{dynamic error, StackTrace? stackTrace, String? tag});

}