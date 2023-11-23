import 'package:base_lib/tools/log/log_manager.dart';

import 'i_contorller.dart';

abstract class UrlIntercept{
  WebPageCallBack? webPageCallBack;

  IController? controller;

  bool baseUrlIntercept(String url){
    LogManager.log.d('intercept: $url');
    return _libUrlIntercept( url)||otherUrlIntercept( url);
  }

  bool otherUrlIntercept(String url);

  bool _libUrlIntercept(String url) {
    return openPay(url);
  }

  // 跳转外部支付
  bool openPay(String url) {
    if (url.startsWith('alipays:') || url.startsWith('weixin:')) {
      return toAliWeiPay(url);
    }
    return false;
  }

  bool toAliWeiPay(String url);
}