import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:third_party_base/third_party_base.dart';
import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

import 'package:base_lib/base_lib.dart';
import 'for_view.dart';
import 'win/web_controller.dart';

@immutable
class WinWebView extends StatefulWidget {
  final WebControllerCreateBack? webControllerCreate;

  final IController? innercontroller;
  final String? _url;
  final JavascriptChannels? javascriptChannels;
  final UrlIntercept? urlIntercept;
  final WebNavigationDelegate? navigationDelegate;

  const WinWebView(this._url,{Key? key,this.innercontroller,this.javascriptChannels,this.urlIntercept,this.navigationDelegate,this.webControllerCreate}) : super(key: key);

  @override
  WinWebViewState createState() => WinWebViewState();
}

class WinWebViewState extends State<WinWebView> {
  late WebviewController _controller;

  late IController _localController;

  @override
  void initState() {
    super.initState();
    initPlatformState(widget.javascriptChannels?.baseJavascriptChannels(context)).then((value) {
      if(widget._url!=null){
        _localController.loadUrl(context, widget._url!);
      }
    });
  }

  Future<void> initPlatformState(Set<JsChannel>? jsChannel) async {
    _controller = WebviewController();
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

    await _controller.initialize();

    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    widget.navigationDelegate?.onPageInit(_localController);

    _controller.loadingState.listen((event) {

      switch(event){
        case LoadingState.navigationCompleted:
          EasyLoading.dismiss();
          widget.navigationDelegate?.onPageFinished(_localController);
          LogManager.log.d(event.name);
          break;
        case LoadingState.loading:
          LogManager.log.d(event.name);
          break;
        case LoadingState.none:
          EasyLoading.dismiss();
          LogManager.log.d(event.name);
          break;
      }
    });

    _controller.webMessage.listen((event) {
      LogManager.log.d(event);
      try{
        var map = event;
        jsChannel?.forEach((element) {
          if(map["name"]==element.name){
            element.onMessageReceived(JsMessage(message: map["value"]));
          }
        });
      }catch(e){
        LogManager.log.e("非jsbridge数据",error: e);
      }

    });

    _controller.title.listen((event) {
      (_localController as WebController).setTitle(event);
    });

    String jsBridge = "";
    jsChannel?.forEach((element) {
      var js = """
      var ${element.name} = {
        postMessage : function(o) {
          window.chrome.webview.postMessage({"name" : "${element.name}","value" : o})
        }
      };
      """;
      jsBridge = jsBridge+js;
    });
    LogManager.log.d(jsBridge);
    _controller.addScriptToExecuteOnDocumentCreated(jsBridge);

    //
    // ?.forEach((element) {
    //   _controller.addJavaScriptChannel(JavaScriptChannelParams(name: element.name, onMessageReceived: (message){
    //     element.onMessageReceived(JsMessage(message: message.message));
    //   }));
    // });

    _controller.url.listen((url) {
      LogManager.log.d(url+"listen:");
      var navigate = widget.urlIntercept?.baseUrlIntercept(url)??false;
      if (navigate){
        _controller.stop();
      }
    });

    // onNavigationRequest: (NavigationRequest request) {
    //   if (widget.urlIntercept?.baseUrlIntercept(request.url)??false) {
    //     return NavigationDecision.prevent;
    //   }
    //   return NavigationDecision.navigate;
    // },

    _controller.onLoadError.listen((event) {
      EasyLoading.dismiss();
      LogManager.log.d("${event.name} loading onLoadError");
    });


    // if(!TextUtil.isNetUrl(widget._url)){
    //   await _loadHtmlAssets(_localController);
    // }else{
    //   await _localController.loadUrl(widget._url);
    // }
    widget.javascriptChannels?.controller = _localController;
    widget.urlIntercept?.controller = _localController;

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.show();
    if(Application.config.debugState){
      return Stack(
        children: [
          Webview(
            _controller,
            // permissionRequested: _onPermissionRequested,
          ),
          Column(children: [
            IconButton(
              icon: const Icon(Icons.developer_mode),
              tooltip: 'Open DevTools',
              splashRadius: 20,
              onPressed: () {
                _controller.openDevTools();
              },
            ),
            // IconButton(
            //   icon: const Icon(Icons.add),
            //   tooltip: 'Open DevTools',
            //   splashRadius: 20,
            //   onPressed: () {
            //     // _controller.postWebMessage('{"key" : 520,"key1" : 1314}');
            //     _controller.postWebMessage(json.encode([1,2,3]));
            //   },
            // )
          ],)

        ],
      );
    }else{
      return Webview(
        _controller,
        // permissionRequested: _onPermissionRequested,
      );
    }


    //flutter 发送消息到页面

    // flutter端（发送端）：
    // _controller.postWebMessage(json.encode([1,2,3]));
    //
    // web端（接收端）：
    // window.chrome.webview.addEventListener('message',(e)=>{
    //   console.log(e)
    // },false)

  }
  //
  // Future<WebviewPermissionDecision> _onPermissionRequested(
  //     String url, WebviewPermissionKind kind, bool isUserInitiated) async {
  //   final decision = await showDialog<WebviewPermissionDecision>(
  //     context: LibRouteNavigatorObserver.instance.navigator!.context,
  //     builder: (BuildContext context) => AlertDialog(
  //       title: const Text('WebView permission requested'),
  //       content: Text('WebView has requested permission \'$kind\''),
  //       actions: <Widget>[
  //         TextButton(
  //           onPressed: () =>
  //               Navigator.pop(context, WebviewPermissionDecision.deny),
  //           child: const Text('Deny'),
  //         ),
  //         TextButton(
  //           onPressed: () =>
  //               Navigator.pop(context, WebviewPermissionDecision.allow),
  //           child: const Text('Allow'),
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   return decision ?? WebviewPermissionDecision.none;
  // }
  //加载本地文件
  // Future<void> _loadHtmlAssets(IController controller) async {
  //   String htmlPath = await DefaultAssetBundle.of(context).loadString(widget._url);
  //   return controller.loadUrl(Uri.dataFromString(htmlPath,mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //       .toString());
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    EasyLoading.dismiss();
  }

}



