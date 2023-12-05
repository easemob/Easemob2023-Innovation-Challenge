

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UpdateLocalizations {

  final Locale locale;

  UpdateLocalizations(this.locale);

  Map<String, UpdateString> values = {
    'en': EnUpdateString(),
    'zh': ChUpdateString(),
    'ja': JpUpdateString(),
  };

  UpdateString? get currentLocalization {
    if (values.containsKey(locale.languageCode)) {
      return values[locale.languageCode];
    }
    return values["en"];
  }

  static const UpdateLocalizationsDelegate delegate = UpdateLocalizationsDelegate();

  //为了使用方便，我们定义一个静态方法
  static UpdateLocalizations? of(BuildContext context) {
    return Localizations.of<UpdateLocalizations>(context, UpdateLocalizations);
  }

  static UpdateString getUpdateString(BuildContext context) {
    return Localizations.of<UpdateLocalizations>(context, UpdateLocalizations)?.currentLocalization??EnUpdateString();
  }


}


class UpdateLocalizationsDelegate extends LocalizationsDelegate<UpdateLocalizations> {

  const UpdateLocalizationsDelegate();
  ///是否支持某个Local
  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'zh',
      'ja',
    ].contains(locale.languageCode);
  }
/// Flutter会调用此类加载相应的Locale资源类
  @override
  Future<UpdateLocalizations> load(Locale locale) {
    return SynchronousFuture<UpdateLocalizations>(
        UpdateLocalizations(locale));
  }

  ///shouldReload的返回值决定当Localizations组件重新build时，
  ///是否调用load方法重新加载Locale资源。一般情况下，
  ///Locale资源只应该在Locale切换时加载一次，
  ///不需要每次在Localizations重新build时都加载，
  ///所以返回false即可。可能有些人会担心返回false的话在APP
  ///启动后用户再改变系统语言时load方法将不会被调用，所以Locale资源将不会被加载。
  ///事实上，每当Locale改变时Flutter都会再调用load方法加载新的Locale，
  ///无论shouldReload返回true还是false。
  @override
  bool shouldReload(covariant LocalizationsDelegate<UpdateLocalizations> old) => false;

}



abstract class UpdateString {

  String? forceUpgradeVersion;

  String? upgradeToVersion;

  String? version;

  String? newVersionSize;

  String? jumpToAppStore;

  String? update;

  String? connectingToServer;

  String? startDownloading;

  String? downloadPathWrong;

  String? downloading;

  String? insufficientPermissions;


}

/// Simplified Chinese
class ChUpdateString implements UpdateString {
  @override
  String? forceUpgradeVersion = "强制升级";

  @override
  String? upgradeToVersion = "是否升级到";

  @override
  String? version = "版本";

  @override
  String? newVersionSize = "新版本大小";

  @override
  String? jumpToAppStore = "跳转appStore";

  @override
  String? update = "更新";

  @override
  String? connectingToServer = "正在连接服务器";

  @override
  String? downloadPathWrong = "更新失败，新版本下载路径错误";

  @override
  String? downloading = "正在下载";

  @override
  String? insufficientPermissions = "更新失败，权限不足";

  @override
  String? startDownloading = "开始下载";


}

// /// Traditional Chinese
// class TChUpdateString implements UpdateString {
//   @override
//   String? libDebugConsole = "調試模式：在開發階段，為了調試及測試方便，提供測試階段的環境切換，此頁面發佈後的線上環境不顯示。";
//
//   @override
//   String? libDebugInterception = "控制台";
//
//   @override
//   String? libDebugModeIntroduce = "網絡攔截";
//
// }

/// English
class EnUpdateString implements UpdateString {
  @override
  String? forceUpgradeVersion = "Force upgrade";

  @override
  String? upgradeToVersion = "Upgrade to";

  @override
  String? version = "version";

  @override
  String? newVersionSize = "New version size";


  @override
  String? jumpToAppStore = "Jump to AppStore";


  @override
  String? update = "update";

  @override
  String? connectingToServer = "Connecting to server";

  @override
  String? downloadPathWrong = "Update failed,The download path of the new version is wrong";

  @override
  String? downloading = "Downloading";

  @override
  String? insufficientPermissions = "Update failed,Insufficient permissions";

  @override
  String? startDownloading = "Start downloading";

}

/// Japanese
class JpUpdateString implements UpdateString {
  @override
  String? forceUpgradeVersion = "強制アップグレード";

  @override
  String? upgradeToVersion = "アップグレード先";

  @override
  String? version = "バージョン";

  @override
  String? newVersionSize = "新しいバージョンのサイズ";


  @override
  String? jumpToAppStore = "ジャンプアプリストア";


  @override
  String? update = "更新";

  @override
  String? connectingToServer = "サーバーに接続中";

  @override
  String? downloadPathWrong = "更新に失敗しました，新しいバージョンのダウンロードパスエラー";

  @override
  String? downloading = "ダウンロード中";

  @override
  String? insufficientPermissions = "更新に失敗しました，権限不足";

  @override
  String? startDownloading = "ダウンロード開始";

}