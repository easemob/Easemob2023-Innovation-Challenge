
import 'package:webview_windows/webview_windows.dart';
import 'package:base_lib/base_lib.dart';

class WebController extends IController{

  late WebviewController _controller;

  WebController():title = "";

  void setController(WebviewController controller){
    _controller = controller;
  }



  @override
  Future<bool> canGoBack() {
    throw UnimplementedError();
  }

  @override
  Future<void> goBack() => _controller.goBack();

  @override
  Future<void> reload() => _controller.reload();

  @override
  Future<Object?> runJSReturningResult(String javaScriptString) async{
    return null;
  }

  @override
  Future<void> runJS(String javaScriptString) => _controller.executeScript(javaScriptString);

  @override
  Future<void> clearCache() => _controller.clearCache();



  String title;

  void setTitle(String title){
    this.title = title;
  }

  @override
  Future<String?> getTitle() async{
    return title;
  }

  @override
  Future<void> loadFile(String absoluteFilePath){
    throw UnimplementedError();
  }

  @override
  Future<void> loadHtmlString(String html) => _controller.loadStringContent(html);

  @override
  Future<void> loadSimpleUrl(String url, {Map<String, String>? headers}) => _controller.loadUrl(url);

  @override
  Future<void> clearLocalStorage() async{
    LogManager.log.i("win has not LocalStorage");
  }

  @override
  Future<void> clearCookies() => _controller.clearCookies();
}