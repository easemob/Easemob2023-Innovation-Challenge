
import 'package:base_ui/app/ui_localizations.dart';
import 'package:base_ui/empty/lib_empty_view.dart';
import 'package:base_ui/widget/debug/debug_widget.dart';
import 'package:flutter/widgets.dart';

class UiInit{

  static void init({LibEmptyConfig? libEmptyConfig}) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      LibEmptyManager.instance.init(libEmptyConfig: libEmptyConfig);
    });
  }

  static TransitionBuilder? uiBuilder({
    TransitionBuilder? builder,
  }){
    return LibDebugBtn.init(builder:builder);
    // return LibLoading.init(builder:LibDebugBtn.init(builder:builder));
  }

  static List<LocalizationsDelegate<dynamic>> localizationsDelegates(){
    return [
      UiLocalizations.delegate,
      // InterceptorLocalizations.delegate,
      // FreeLocalizations.delegate
    ];
  }
}
