import 'dart:io';

extension FileExt on File {
  int get sizeInBytes => lengthSync();
}
