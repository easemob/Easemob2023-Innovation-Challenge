abstract class IPermession{
  Future<bool> hasStoragePermission();
}

class PermissionManager{
  static late IPermession permission;

  static void init(IPermession iPermession){
    permission = iPermession;
  }
}