

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:third_party_base/third_party_base.dart';

import 'andios/web_controller.dart';
import 'package:base_lib/base_lib.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'for_view.dart';

@immutable
class WebView extends StatefulWidget {
  final IController? innercontroller;
  final WebControllerCreateBack? webControllerCreate;
  final String? _url;
  final JavascriptChannels? javascriptChannels;
  final UrlIntercept? urlIntercept;
  final WebNavigationDelegate? navigationDelegate;

  const WebView(this._url,{Key? key,this.innercontroller,this.javascriptChannels,this.urlIntercept,this.navigationDelegate,this.webControllerCreate}) : super(key: key);

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebView> {
  late WebViewController _controller;
  late IController _localController;
  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features
    if(widget.innercontroller==null){
      _localController = WebController()..setController(_controller);
    }else{
      (widget.innercontroller! as WebController).setController(_controller);
      _localController = widget.innercontroller!;
    }
    widget.webControllerCreate?.call(_localController);

    widget.urlIntercept?.controller = _localController;
    widget.navigationDelegate?.onPageInit(_localController);
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 是否支持js，默认是不支持的
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            LogManager.log.d('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            widget.navigationDelegate?.onPageStarted(_localController);
            EasyLoading.show();
            LogManager.log.d("$url loading start");
          },
          onPageFinished: (String url) {
            widget.navigationDelegate?.onPageFinished(_localController);
            EasyLoading.dismiss();
            LogManager.log.d("$url loading finish");
          },
          onWebResourceError: (WebResourceError error) {
            EasyLoading.dismiss();
            LogManager.log.d("loading error -> ${error.errorCode},${error.description},${error.errorType}, ${error.isForMainFrame}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (widget.urlIntercept?.baseUrlIntercept(request.url)??false) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            LogManager.log.d('url change to ${change.url}');
          },
        ),
      );
    widget.javascriptChannels?.controller = _localController;
    widget.javascriptChannels?.baseJavascriptChannels(context)?.forEach((element) {
      _controller.addJavaScriptChannel(element.name, onMessageReceived: (javaScriptMessage){
        element.onMessageReceived(JsMessage(message: javaScriptMessage.message));
      });
    });
    if(widget._url!=null){
      _localController.loadUrl(context, widget._url!);
    }

    // #docregion platform_features
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }



  // //加载本地文件
  // _loadHtmlAssets(IController controller) async {
  //   String htmlPath = await DefaultAssetBundle.of(context).loadString(widget._url);
  //   controller.loadUrl(Uri.dataFromString(htmlPath,mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       .toString());
  // }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();

  }

}

