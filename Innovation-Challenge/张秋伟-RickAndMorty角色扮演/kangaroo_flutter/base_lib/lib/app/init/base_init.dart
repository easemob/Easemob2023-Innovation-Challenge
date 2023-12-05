
import 'dart:io';

import 'package:base_lib/app/lifecycle/lib_flutter_binding.dart';
import 'package:base_lib/app/permission_manager.dart';
import 'package:base_lib/app/application.dart';
import 'package:base_lib/app/package_info_manager.dart';
import 'package:base_lib/base_lib.dart';
import 'package:base_lib/tools/lib_localizations.dart';
import 'package:base_lib/tools/log/i_log.dart';
import 'package:base_lib/tools/log/log_manager.dart';
import 'package:base_lib/tools/navigator/lib_route_navigator_observer.dart';
import 'package:base_lib/tools/net/connect_manager.dart';
import 'package:base_lib/tools/platform_util.dart';
import 'package:base_lib/tools/secret_util.dart';
import 'package:base_lib/tools/store/filestore/diskspace_manager.dart';
import 'package:base_lib/tools/store/filestore/storage_util.dart';
import 'package:base_lib/tools/store/i_store.dart';
import 'package:base_lib/tools/store/path_provider_manager.dart';
import 'package:base_lib/tools/store/store_manager.dart';
import 'package:base_lib/tools/tip/tip_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../tools/tip/i_tip.dart';
import '../config.dart';
import 'i_init.dart';

///系统级别初始化
class BaseInit implements IInit{

  final ILog _ilog;
  final IStore _iStore;
  final IPathProvider _iPathProvider;
  final ISecret _iSecret;
  final IDiskspace _iDiskspace;
  final IPackageInfo _iPackageInfo;
  final IPermession _iPermession;
  final ITip _iTip;
  final IConnect _iConnect;
  final IPlatform _iPlatform;
  final ILaunch _iLaunch;

  BaseInit(Config config,this._ilog, this._iStore, this._iPathProvider, this._iSecret, this._iDiskspace,this._iPackageInfo,this._iPermession,this._iTip,this._iConnect,this._iPlatform,this._iLaunch){
    Application.config = config;
    LogManager.init(_ilog);
    StoreManager.init(_iStore);
    PathProviderManager.init(_iPathProvider);
    SecretUtil.init(_iSecret);
    DiskspaceManager.init(_iDiskspace);
    PackageInfoManager.init(_iPackageInfo);
    PermissionManager.init(_iPermession);
    TipToast.init(_iTip);
    ConnectManager.init(_iConnect);
    PlatformUtil.init(_iPlatform);
    LaunchTools.init(_iLaunch);
  }

  static late String appName;
  static late String packageName;
  static late String version;
  static late String buildNumber;
  static late String uniqueId;

  @override
  void init() {
    bindingInit();
  }

  Future _package() async{
    PackageModel packageModel = await PackageInfoManager.packageInfo.getPackageModel();
    appName = packageModel.appName;
    packageName = packageModel.packageName;
    version = packageModel.version;
    buildNumber = packageModel.buildNumber;
    uniqueId = packageModel.uniqueId;
  }

  Future _storage() async{
    if (await PermissionManager.permission.hasStoragePermission()) {
      if(PlatformUtil.isAndroid){
        var dir = await PathProviderManager.pathProvider.getExternalStorageDirectory();
        if(dir!=null){
          StorageUtil.init(dir.path);
        }else{
          StorageUtil.init((await PathProviderManager.pathProvider.getApplicationDocumentsDirectory()).path);
        }
      } else {
        if(!PlatformUtil.isWeb){
          StorageUtil.init((await PathProviderManager.pathProvider.getApplicationDocumentsDirectory()).path);
        }
      }
    }else{
      if(!PlatformUtil.isWeb){
        StorageUtil.init((await PathProviderManager.pathProvider.getApplicationDocumentsDirectory()).path);
      }
    }
  }

  @override
  Future syncInit() => Future.wait([_package(),_storage()]);

  void bindingInit() {
    CustomLibFlutterBinding();
  }

  @override
  List<LocalizationsDelegate>? localizationsDelegates() => [
    LibLocalizations.delegate, ...GlobalMaterialLocalizations.delegates,
  ];

  @override
  List<Locale>? supportedLocales() => [
    const Locale('en'),
    const Locale('zh'),
    const Locale('ja'),
  ];

  @override
  TransitionBuilder? transitionBuilder() => TipToast.tp.builder();

  @override
  List<NavigatorObserver>? navigatorObservers() => [LibRouteNavigatorObserver.instance];

}

class CustomLibFlutterBinding extends WidgetsFlutterBinding with LibFlutterBinding {

}