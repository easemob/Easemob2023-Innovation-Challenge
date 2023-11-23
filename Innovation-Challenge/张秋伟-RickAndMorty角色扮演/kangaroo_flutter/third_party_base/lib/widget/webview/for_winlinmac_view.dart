//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:third_party_base/third_party_base.dart';
// import 'package:virtual_machine/widget/webview/winlinmac/web_controller.dart';
//
// import 'package:base_lib/base_lib.dart';
// import 'package:desktop_webview_window/desktop_webview_window.dart';
//
// class DeskWebView {
//   final IController? innercontroller;
//   final String _url;
//   final JavascriptChannels? javascriptChannels;
//   final UrlIntercept? urlIntercept;
//   final BuildContext context;
//
//   DeskWebView(this.context,this._url,{this.innercontroller,this.javascriptChannels,this.urlIntercept});
//
//   late IController _localController;
//
//   void create() async {
//
//     final webview = await WebviewWindow.create(
//       configuration: CreateConfiguration(
//         userDataFolderWindows: StorageUtil.getWritePath("desktop_webview_window", StorageType.typeTemp)!,
//         titleBarTopPadding: PlatformUtil.isMacOS ? 20 : 0,
//       ),
//     );
//
//     if(innercontroller==null){
//       _localController = WebController()..setController(webview);
//     }else{
//       (innercontroller! as WebController).setController(webview);
//       _localController = innercontroller!;
//     }
//     javascriptChannels?.controller = _localController;
//     urlIntercept?.controller = _localController;
//
//     webview
//       ..setBrightness(Brightness.dark)
//       ..setApplicationNameForUserAgent(" DeskWebView/1.0.0")
//       ..addOnUrlRequestCallback((url) {
//         debugPrint('url: $url');
//         final uri = Uri.parse(url);
//         urlIntercept?.baseUrlIntercept(uri.path);
//       })
//       ..onClose.whenComplete(() {
//         LogManager.log.d("on close");
//       });
//
//     //todo 修改
//     // javascriptChannels?.baseJavascriptChannels(context)?.forEach((element) {
//     //   webview.registerJavaScriptMessageHandler(element.name, (name, body) {
//     //     LogManager.log.d(name+"heheheh"+body);
//     //     element.onMessageReceived(JsMessage(message: body));
//     //   });
//     // });
//
//     if(!TextUtil.isNetUrl(_url)){
//       _loadHtmlAssets(_localController);
//     }else{
//       _localController.loadUrl(_url);
//     }
//   }
//
//   //加载本地文件
//   _loadHtmlAssets(IController controller) async {
//     String htmlPath = await DefaultAssetBundle.of(context).loadString(_url);
//     controller.loadUrl(Uri.dataFromString(htmlPath,mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//         .toString());
//   }
//
//
// }
//
// // windowHeight: 1280,
// // windowWidth: 720,
//
// // ..setPromptHandler((prompt, defaultText) {
// // if (prompt == "test") {
// // return "Hello World!";
// // } else if (prompt == "init") {
// // return "initial prompt";
// // }
// // return "";
// // })
//
// // ..addScriptToExecuteOnDocumentCreated("""
// //   const mixinContext = {
// //     platform: 'Desktop',
// //     conversation_id: 'conversationId',
// //     immersive: false,
// //     app_version: '1.0.0',
// //     appearance: 'dark',
// //   }
// //   window.MixinContext = {
// //     getContext: function() {
// //       return JSON.stringify(mixinContext)
// //     }
// //   }
// // """)
//
// // await WebviewWindow.clearAll(
// // userDataFolderWindows: await _getWebViewPath(),
// // );
// //
// // const _javaScriptToEval = [
// //   """
// //   function test() {
// //     return;
// //   }
// //   test();
// //   """,
// //   'eval({"name": "test", "user_agent": navigator.userAgent})',
// //   '1 + 1',
// //   'undefined',
// //   '1.0 + 1.0',
// //   '"test"',
// // ];
//
// // Future<String> _getWebViewPath() async {
// //   final document = await PathProviderManager.pathProvider.getApplicationDocumentsDirectory();
// //   return p.join(
// //     document.path,
// //     'desktop_webview_window',
// //   );
// // }