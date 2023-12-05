


import 'package:base_lib/tools/log/lib_log.dart';

import 'i_log.dart';

class LogManager{

  static late ILog log;

  static void init(ILog iLog){
    log = LibLog(iLog);
  }

  static List<ILog> listener = [];

  static void addListener(ILog iLog){
    listener.add(iLog);
  }

  static void removeListener(ILog iLog){
    listener.remove(iLog);
  }
}