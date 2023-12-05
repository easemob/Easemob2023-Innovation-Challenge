
import 'dart:io';

abstract class IPathProvider{
  Future<Directory> getTemporaryDirectory();
  Future<Directory> getApplicationDocumentsDirectory();
  Future<Directory?> getExternalStorageDirectory();
}

class PathProviderManager{

  static late IPathProvider pathProvider;

  static void init(IPathProvider iPathProvider){
    pathProvider = iPathProvider;
  }
}