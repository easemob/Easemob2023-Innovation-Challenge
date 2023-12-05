

import 'package:flutter/material.dart';

import 'package:base_lib/base_lib.dart';

typedef WebControllerCreateBack = Function(IController iController);

class WebView extends StatelessWidget{
  final IController? innercontroller;
  final WebControllerCreateBack? webControllerCreate;
  final String? _url;
  final JavascriptChannels? javascriptChannels;
  final UrlIntercept? urlIntercept;
  final WebNavigationDelegate? navigationDelegate;
  const WebView(this._url,{Key? key,this.innercontroller,this.javascriptChannels,this.urlIntercept,this.navigationDelegate,this.webControllerCreate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}