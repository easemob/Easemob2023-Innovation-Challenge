
import 'package:path_provider/path_provider.dart' as path;
import 'dart:io';

import 'package:base_lib/base_lib.dart';

class PathProviderImpl implements IPathProvider{
  @override
  Future<Directory> getApplicationDocumentsDirectory() => path.getApplicationDocumentsDirectory();

  @override
  Future<Directory?> getExternalStorageDirectory() => path.getExternalStorageDirectory();

  @override
  Future<Directory> getTemporaryDirectory() => path.getTemporaryDirectory();

}