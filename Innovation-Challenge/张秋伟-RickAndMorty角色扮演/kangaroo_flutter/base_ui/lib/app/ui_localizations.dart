

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UiLocalizations {

  final Locale locale;

  UiLocalizations(this.locale);

  Map<String, UiString> values = {
    'en': EnUiString(),
    'zh': ChUiString(),
    'ja': JpUiString(),
  };

  UiString? get currentLocalization {
    if (values.containsKey(locale.languageCode)) {
      return values[locale.languageCode];
    }
    return values["en"];
  }

  static const UiLocalizationsDelegate delegate = UiLocalizationsDelegate();

  //为了使用方便，我们定义一个静态方法
  static UiLocalizations? of(BuildContext context) {
    return Localizations.of<UiLocalizations>(context, UiLocalizations);
  }

  static UiString getUiString(BuildContext context) {
    return Localizations.of<UiLocalizations>(context, UiLocalizations)?.currentLocalization??EnUiString();
  }


}


class UiLocalizationsDelegate extends LocalizationsDelegate<UiLocalizations> {

  const UiLocalizationsDelegate();
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
  Future<UiLocalizations> load(Locale locale) {
    return SynchronousFuture<UiLocalizations>(
        UiLocalizations(locale));
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
  bool shouldReload(covariant LocalizationsDelegate<UiLocalizations> old) => false;

}



abstract class UiString {

  String? libDebugModeIntroduce;

  String? libDebugConsole;

  String? libDebugInterception;

  String? libDebugProxy;

  String? libAgreementTitle;

  String? libAgreementSure;

  String? libAgreementQuit;

  String? libAgreementContent;

  String? libAgreementContentAnd;

  String? libUserAgreement;

  String? libPrivacyPolicy;
  String? libEmptyPageNetError;
  String? libEmptyPageNoData;
  String? libEmptyPageLoding;
  String? libRefresh;

}

/// Simplified Chinese
class ChUiString implements UiString {
  @override
  String? libDebugModeIntroduce = "调式模式：在开发阶段，为了方便调式及测试方便，提供测试阶段的环境切换，此页面发布后的线上环境不显示";

  @override
  String? libDebugConsole = "控制台";

  @override
  String? libDebugInterception = "网络拦截";

  @override
  String? libAgreementContent = "本应用尊重并保护所有用户的个人隐私权。为了给您提供更准确、更有个性化的服务，本应用会按照隐私政策的规定使用和披露您的个人信息。可阅读";

  @override
  String? libAgreementContentAnd = "和";

  @override
  String? libAgreementQuit = "不同意并退出App";

  @override
  String? libAgreementSure = "同意";

  @override
  String? libAgreementTitle = "隐私政策";

  @override
  String? libPrivacyPolicy = "隐私政策";

  @override
  String? libUserAgreement = "用户协议";

  @override
  String? libDebugProxy = "代理";

  @override
  String? libEmptyPageNetError = "Oops，遇到问题了，刷新试试";

  @override
  String? libEmptyPageNoData = "暂时没有任何数据，去别处看看吧";

  @override
  String? libRefresh = "刷新";

  @override
  String? libEmptyPageLoding = "数据加载中";


}

// /// Traditional Chinese
// class TChUiString implements UiString {
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
class EnUiString implements UiString {
  @override
  String? libDebugModeIntroduce = "Debug mode: in the development stage, for debugging and testing convenience,Provide environment switch during the test phase. The online environment after this page is not displayed.";

  @override
  String? libDebugConsole = "console";

  @override
  String? libDebugInterception = "Network interception";

  @override
  String? libAgreementContent = "This application respects and protects the personal privacy of all users. In order to provide you with more accurate and personalized services, this app will use and disclose your personal information in accordance with the privacy policy. Readable";

  @override
  String? libAgreementContentAnd = " and ";

  @override
  String? libAgreementQuit = "Disagree and quit app";

  @override
  String? libAgreementSure = "Agree";

  @override
  String? libAgreementTitle = "Privacy Policy";

  @override
  String? libPrivacyPolicy = " privacy policy ";

  @override
  String? libUserAgreement = " user agreement ";


  @override
  String? libDebugProxy = "Proxy";
  @override
  String? libEmptyPageNetError = "Oops, encountered problems, refresh try";

  @override
  String? libEmptyPageNoData = "there is no data for the time being. Let\'s look elsewhere.";

  @override
  String? libRefresh = "refresh";

  @override
  String? libEmptyPageLoding = "Data loading";
}

/// Japanese
class JpUiString implements UiString {
  @override
  String? libDebugModeIntroduce = "テストモード：開発段階で、テストやテストのために便利なようにテスト段階の環境の切り替えを提供します。このページの発表後の線上の環境は表示されません。";

  @override
  String? libDebugConsole = "コントロール台";

  @override
  String? libDebugInterception = "ネットワークブロック";
  
  @override
  String? libAgreementContent = "本アプリケーションは、すべてのユーザーのプライバシーを尊重し、保護します。本アプリケーションは、より正確で個性的なサービスを提供するために、プライバシーポリシーの規定に従って個人情報を使用し、開示します。読み取り可能";

  @override
  String? libAgreementContentAnd = "と";

  @override
  String? libAgreementQuit = "Appに同意せずに終了";

  @override
  String? libAgreementSure = "同意する";

  @override
  String? libAgreementTitle = "プライバシーポリシー";

  @override
  String? libPrivacyPolicy = "プライバシーポリシー";

  @override
  String? libUserAgreement = "ユーザプロトコル";

  @override
  String? libDebugProxy = "プロキシ";

  @override
  String? libEmptyPageNetError = "Oops、問題に遭遇し、更新してみた。";

  @override
  String? libEmptyPageNoData = "今は何のデータもなく、他のところへ行ってみましょう。";


  @override
  String? libRefresh = "更新";

  @override
  String? libEmptyPageLoding = "データロード中";
}