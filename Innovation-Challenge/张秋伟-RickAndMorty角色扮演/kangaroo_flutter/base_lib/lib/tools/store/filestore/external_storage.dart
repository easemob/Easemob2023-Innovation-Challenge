import 'dart:io';

import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/tools/log/log_manager.dart';
import 'package:base_lib/tools/store/file/file_util.dart';

import 'storage_type.dart';

class ExternalStorage{

  String sdkStorageRoot;

  ExternalStorage(this.sdkStorageRoot){
    if(!sdkStorageRoot.endsWith("/")){
      sdkStorageRoot = "$sdkStorageRoot/";
    }
    _createSubFolders();
  }

  static const String noMediaFileName = ".nomedia";

  void _createSubFolders(){
    List<Future> list = [];
    StorageType.values.forEach((element) {
      list.add(_makeDirectory(element));
    });
    Future.wait(list).then((value) => {
      _createNoMediaFile(sdkStorageRoot)
    }).catchError((e){
      LogManager.log.e(e,tag: "${SysConfig.libApplicationTag}Storage");
    });
  }

  Future _makeDirectory(StorageType storageType) {
    return FileUtil.makeDirectory(sdkStorageRoot + storageType.storageDirectoryName);
  }

  void _createNoMediaFile(String path) async {
    File("$path/$noMediaFileName").create(recursive: true);
  }

  ///根据输入的文件名和类型，找到该文件的全路径。如果存在该文件，返回路径，否则返回空
  String? getReadPath(String fileName,StorageType type){
    if (fileName.isEmpty){
      return null;
    }
    return _pathForName(fileName, type, false, true);
  }

  ///文件全名转绝对路径（写）
  String? getWritePath(String fileName,StorageType type) {
    return _pathForName(fileName, type, false, false);
  }

  String? _pathForName(String fileName, StorageType type, bool dir, bool check) {
    var directory = getDirectoryByDirType(type);
    var path = StringBuffer(directory);
    if(!dir){
      path.write(fileName);
    }
    var pathString = path.toString();
    var file = File(pathString);
    var direct = Directory(pathString);
    if(check){
      if(dir){
        if(direct.existsSync()){
          return pathString;
        }
      } else {
        if(file.existsSync()){
          return pathString;
        }
      }
    }else{
      return pathString;
    }
  }

  ///返回指定类型的文件夹路径
  String getDirectoryByDirType(StorageType type) {
    return sdkStorageRoot + type.storageDirectoryName;
  }

}