
import 'package:disk_space/disk_space.dart';
import 'package:base_lib/base_lib.dart';

class DiskspaceImpl implements IDiskspace{
  @override
  Future<double?> getFreeDiskSpaceForPath(String path) => DiskSpace.getFreeDiskSpaceForPath(path);

}