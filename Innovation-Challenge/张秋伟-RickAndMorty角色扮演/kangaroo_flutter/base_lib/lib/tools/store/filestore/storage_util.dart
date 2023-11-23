
import 'package:base_lib/app/init/base_init.dart';
import 'package:base_lib/exception/lib_storage_exception.dart';
import 'package:base_lib/tools/lib_localizations.dart';
import 'package:base_lib/tools/platform_util.dart';
import 'dart:io';
import '../../secret_util.dart';
import 'diskspace_manager.dart';
import 'external_storage.dart';
import 'storage_type.dart';
import 'package:path/path.dart';

class StorageUtil{
  ///kb
  static const _k = 1024;
  ///mb
  static const _m = 1024 * _k;

  ///外置存储卡默认预警临界值
  static const thresholdWraningSpcae = 100 * _m;

  ///保存文件时所需的最小空间的默认值
  static const thresholdMinSpcae = 20 * _m;

  static ExternalStorage? _externalStorage;

  static void init(String sdkStorageRoot)async{
    if(PlatformUtil.isWindows){

      sdkStorageRoot = join(
        sdkStorageRoot,
        BaseInit.appName,
        SecretUtil.hashMD5(Directory.current.path),
      );
    }
    _externalStorage = ExternalStorage(sdkStorageRoot);
  }

  static String? storageRoot(){
    return _externalStorage?.sdkStorageRoot;
  }

  ///根据输入的文件名和类型，找到该文件的全路径。
  static String? getReadPath(String fileName,StorageType type){
    return _externalStorage!.getReadPath(fileName, type);
  }

  ///判断外部存储是否存在，以及是否有足够空间保存指定类型的文件
  static void hasEnoughSpaceForWrite() async{
    if(_externalStorage?.sdkStorageRoot==null){
      throw LibStorageException(LibLocalizations.getLibString().libSpaceDoesNotExist!);
    }
    var residual = await DiskspaceManager.diskspace.getFreeDiskSpaceForPath(_externalStorage!.sdkStorageRoot);
    if(residual! < thresholdMinSpcae){
      throw LibStorageException(LibLocalizations.getLibString().libInsufficientStorageSpace!);
    }else if(residual < thresholdWraningSpcae){
      throw LibWarningStorageException(LibLocalizations.getLibString().libInsufficientStorageWarning!);
    }
  }

  /// 返回指定类型的文件夹路径
  static String getDirectoryByDirType(StorageType fileType){
    return _externalStorage!.getDirectoryByDirType(fileType);
  }

  ///可用的保存路径
  static String? getWritePath(String fileName,StorageType type){
    return _externalStorage!.getWritePath(fileName,type);
  }

}