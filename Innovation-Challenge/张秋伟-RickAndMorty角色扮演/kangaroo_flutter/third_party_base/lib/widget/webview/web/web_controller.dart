
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:base_lib/base_lib.dart';


class WebController extends IController{

  late PlatformWebViewController _controller;

  WebController();

  void setController(PlatformWebViewController controller){
    _controller = controller;
  }


  @override
  Future<bool> canGoBack() => _controller.canGoBack();
  @override
  Future<void> goBack() => _controller.goBack();

  @override
  Future<void> reload() => _controller.reload();

  @override
  Future<Object?> runJSReturningResult(String javaScriptString) => _controller.runJavaScriptReturningResult(javaScriptString);

  @override
  Future<void> runJS(String javaScriptString) => _controller.runJavaScript(javaScriptString);

  @override
  Future<void> clearCache() => _controller.clearCache();

  @override
  Future<void> clearLocalStorage() => _controller.clearLocalStorage();

  @override
  Future<String?> getTitle() => _controller.getTitle();

  @override
  Future<void> loadFile(String absoluteFilePath) => _controller.loadFile(absoluteFilePath);

  @override
  Future<void> loadHtmlString(String html) => _controller.loadHtmlString(html);


  @override
  Future<void> clearCookies() {
    // TODO: implement clearCookies
    throw UnimplementedError();
  }

  @override
  Future<void> loadSimpleUrl(String url, {Map<String, String>? headers})  => _controller.loadRequest(LoadRequestParams(
      uri: Uri.parse(url),headers: headers??(<String, String>{})
  ));
}