
import 'package:permission_handler/permission_handler.dart';
import 'package:base_lib/base_lib.dart';

class PermessionImpl implements IPermession{

  @override
  Future<bool> hasStoragePermission() => Permission.storage.isGranted;

}