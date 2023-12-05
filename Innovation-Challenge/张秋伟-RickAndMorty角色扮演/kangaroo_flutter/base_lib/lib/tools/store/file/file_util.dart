import 'dart:io';

class FileUtil {
  static final int unit_b = 1024;
  static final int unit_kb = unit_b * unit_b;
  static final int unit_mb = unit_kb * unit_b;

  static String formatFileSize(int size) {
    String formatSize = "";
    if (size == 0) {
      return '0B';
    }
    if (size < unit_b) {
      formatSize = size.toString() + "B";
    } else if (size < unit_kb) {
      formatSize = (size / unit_b).toStringAsFixed(2) + "KB";
    } else if (size < unit_mb) {
      formatSize = (size / unit_kb).toStringAsFixed(2) + "MB";
    } else {
      formatSize = (size / unit_mb).toStringAsFixed(2) + "GB";
    }
    return formatSize;
  }

  ///创建目录
  static Future makeDirectory(String path) async{
    var p = Directory(path);
    if(!await p.exists()){
      await p.create(recursive: true);
    }
  }

  ///创建文件
  static create(String filePath) async {
    var f = File(filePath);
    await f.create(recursive: true);
  }

  ///删除文件夹下所有文件、或者单一文件
  static Future<Null> deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDirectory(child);
        await child.delete();
      }
    }
  }
}
