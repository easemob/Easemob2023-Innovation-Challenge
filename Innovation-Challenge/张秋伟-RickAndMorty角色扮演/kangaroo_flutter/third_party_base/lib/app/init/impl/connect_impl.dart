

import 'package:base_lib/base_lib.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectImpl implements IConnect{
  @override
  Future<bool> isConnected() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

}