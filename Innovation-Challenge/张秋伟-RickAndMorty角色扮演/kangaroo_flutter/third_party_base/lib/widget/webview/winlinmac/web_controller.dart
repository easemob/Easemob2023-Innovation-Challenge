//
//
// import 'package:desktop_webview_window/desktop_webview_window.dart';
// import 'package:base_lib/base_lib.dart';
//
// import '../interface/i_contorller.dart';
//
// class WebController extends IController{
//
//   late Webview _controller;
//
//   WebController();
//
//   void setController(Webview controller){
//     _controller = controller;
//   }
//
//
//   @override
//   Future<bool> canGoBack(){
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> goBack() => _controller.back();
//
//   @override
//   Future<void> reload() => _controller.reload();
//
//   @override
//   Future<Object?> runJSReturningResult(String javaScriptString) => _controller.evaluateJavaScript(javaScriptString);
//
//   @override
//   Future<void> runJS(String javaScriptString) => _controller.evaluateJavaScript(javaScriptString);
//
//   @override
//   Future<void> clearCache() {
//     throw UnimplementedError();
//   }
//
//   Future<void> clearLocalStorage() {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<String?> getTitle() {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> loadFile(String absoluteFilePath) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> loadHtmlString(String html) {
//     throw UnimplementedError();
//   }
//
//   @override
//   Future<void> loadUrl(String url, {Map<String, String>? headers}) async{
//     _controller.launch(url);
//   }
//
//   void close(){
//     _controller.close();
//   }
//
//   void addScriptToExecuteOnDocumentCreated(String javascript){
//     _controller.addScriptToExecuteOnDocumentCreated(javascript);
//   }
//
//   void clearAll() async {
//     await WebviewWindow.clearAll(
//         userDataFolderWindows: StorageUtil.getReadPath("desktop_webview_window", StorageType.typeTemp)!,
//     );
//   }
// }