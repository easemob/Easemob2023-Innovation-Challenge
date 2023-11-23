
abstract class IDiskspace{
  Future<double?> getFreeDiskSpaceForPath(String path);
}

class DiskspaceManager{

  static late IDiskspace diskspace;

  static void init(IDiskspace iDiskspace){
    diskspace = iDiskspace;
  }
}