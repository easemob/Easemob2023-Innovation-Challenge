

import 'dart:io';
import 'file/file_util.dart';
import 'filestore/storage_util.dart';
import 'path_provider_manager.dart';

class ClearUtil{


  ///递归计算文件、文件夹的大小
  static Future<double> getTotalSizeOfFilesInDir(
      final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      for (final FileSystemEntity child in children) {
        total += await getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0;
  }

  ///缓存大小格式转换
  static String formatSize(double? value) {
    if (null == value) {
      return '0';
    }
    List<String> unitArr = []..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value! > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  static Future<Directory> getTemporary = PathProviderManager.pathProvider.getTemporaryDirectory();

  static Future<Directory> getApplicationDocuments = PathProviderManager.pathProvider.getApplicationDocumentsDirectory();

  static Directory getStorage (){
    return Directory(StorageUtil.storageRoot()!);
  }

  /// 删除项目所有缓存
  static void clearApplicationCache() async {
    Directory docDirectory = await getApplicationDocuments;
    Directory tempDirectory = await getTemporary;
    Directory storage = getStorage();
    if (docDirectory.existsSync()) {
      await FileUtil.deleteDirectory(docDirectory);
    }

    if (tempDirectory.existsSync()) {
      await FileUtil.deleteDirectory(tempDirectory);
    }

    if (storage.existsSync()) {
      await FileUtil.deleteDirectory(storage);
    }
  }


}