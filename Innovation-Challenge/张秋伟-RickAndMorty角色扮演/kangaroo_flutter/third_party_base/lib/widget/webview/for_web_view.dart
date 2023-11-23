import 'dart:convert';
import 'dart:typed_data';
import 'package:third_party_base/third_party_base.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:flutter/material.dart';

import 'package:base_lib/base_lib.dart';
import 'for_view.dart';
import 'web/web_controller.dart';

@immutable
class WebView extends StatefulWidget {
  final WebControllerCreateBack? webControllerCreate;
  final IController? innercontroller;
  final String? _url;
  final JavascriptChannels? javascriptChannels;
  final UrlIntercept? urlIntercept;
  final WebNavigationDelegate? navigationDelegate;

  const WebView(this._url,{Key? key,this.innercontroller,this.javascriptChannels,this.urlIntercept,this.navigationDelegate,this.webControllerCreate}) : super(key: key);

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebView> {
  late PlatformWebViewController _controller;
  late IController _localController;
  @override
  void initState() {
    super.initState();
    WebViewPlatform.instance = WebWebViewPlatform();
    _controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    );
    if(widget.innercontroller==null){
      _localController = WebController()..setController(_controller);
    }else{
      (widget.innercontroller! as WebController).setController(_controller);
      _localController = widget.innercontroller!;
    }
    widget.webControllerCreate?.call(_localController);


    // 是否支持js
    // _controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    // _controller.setPlatformNavigationDelegate(PlatformNavigationDelegate(const PlatformNavigationDelegateCreationParams())
    //   ..setOnWebResourceError((error) {
    //     EasyLoading.dismiss();
    //     LogManager.log.d("loading error -> ${error.errorCode},${error.description},${error.errorType}");
    // })..setOnHttpError((error) {
    //
    // })..setOnNavigationRequest((navigationRequest) {
    //     if (widget.urlIntercept?.baseUrlIntercept(navigationRequest.url)??false) {
    //       return NavigationDecision.prevent;
    //     }
    //     return NavigationDecision.navigate;
    // })..setOnPageFinished((url) {
    //     LogManager.log.d("$url loading finish");
    //     EasyLoading.dismiss();
    // })..setOnPageStarted((url) {
    //     LogManager.log.d("$url loading start");
    //     EasyLoading.show();
    // })..setOnProgress((progress) {
    //
    // })..setOnUrlChange((change) {
    //
    // }));
    // widget.javascriptChannels?.baseJavascriptChannels(context)?.forEach((element) {
    //   _controller.addJavaScriptChannel(JavaScriptChannelParams(name: element.name, onMessageReceived: (message){
    //     element.onMessageReceived(JsMessage(message: message.message));
    //   }));
    // });

    if(widget._url!=null){
      _localController.loadUrl(context, widget._url!);
    }

    // if(!TextUtil.isNetUrl(widget._url)){
    //   _loadHtmlAssets(_localController);
    // }else{
    //   _localController.loadUrl(widget._url);
    // }
    widget.javascriptChannels?.controller = _localController;
    widget.urlIntercept?.controller = _localController;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams(controller: _controller),
    ).build(context);
  }

  // //加载本地文件
  // _loadHtmlAssets(IController controller) async {
  //   String htmlPath = await DefaultAssetBundle.of(context).loadString(widget._url);
  //   controller.loadUrl(Uri.dataFromString(htmlPath,mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       .toString());
  // }

}


