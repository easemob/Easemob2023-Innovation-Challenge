
import 'dart:convert';

import 'package:base_lib/tools/log/log_manager.dart';
import 'package:flutter/widgets.dart';

import '../../text_util.dart';

typedef WebPageCallBack = Function(String name,dynamic value);

abstract class IController{

  Future<void> runJavascript(String funname,List<String>? param,bool brackets) {
    String javaScriptString = _getJavaScriptString(funname,param,brackets);
    return runJS(javaScriptString);
  }

  Future<Object?> runJavascriptReturningResult(String funname,List<String>? param,bool brackets) {
    String javaScriptString = _getJavaScriptString(funname,param,brackets);
    return runJSReturningResult(javaScriptString);
  }

  Future<Object?> runJSReturningResult(String javaScriptString);

  Future<void> runJS(String javaScriptString);

  Future<bool> canGoBack();

  Future<void> goBack();

  Future<void> reload();

  Future<void> clearCache();

  Future<String?> getTitle();

  Future<void> clearLocalStorage();

  Future<void> clearCookies();

  Future<void> loadHtmlString(String html);

  Future<void> loadFile(String absoluteFilePath);

  Future<void> loadSimpleUrl(String url, { Map<String, String>? headers });

  String _getJavaScriptString(String funname, List<String>? param,bool brackets) {
    var strb = StringBuffer(funname);
    if(brackets){
      strb.write("(");
    }
    if(param!=null&&param.isNotEmpty){
      for(int i=0;i<param.length;i++){
        strb.write("'${param[i]}'");
        if(i<param.length-1){
          strb.write(",");
        }
      }
    }
    if(brackets){
      strb.write(")");
    }
    LogManager.log.d("JS function -> ${strb.toString()}");
    return strb.toString();
  }

  Future<void> loadUrl(BuildContext context,String url, { Map<String, String>? headers }){
    if(!TextUtil.isNetUrl(url)){
      return _loadHtmlAssets(context,url,headers:headers);
    }else{
      return loadSimpleUrl(url,headers: headers);
    }
  }


  Future<void> _loadHtmlAssets(BuildContext context,String url, { Map<String, String>? headers }) async {
    String htmlPath = await DefaultAssetBundle.of(context).loadString(url);
    return loadSimpleUrl(Uri.dataFromString(htmlPath,mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString(),headers: headers);
  }

}


abstract class WebNavigationDelegate{
  onPageFinished(IController _controller);
  onPageInit(IController _controller);
  onPageStarted(IController _controller);
}