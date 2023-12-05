

abstract class IConnect{
  Future<bool> isConnected();
}

class ConnectManager{
  static late IConnect connect;

  static void init(IConnect iConnect){
    connect = iConnect;
  }
}