

import 'package:base_ui/style/common_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:base_lib/base_lib.dart';

@immutable
class DebugFloatWidget extends StatefulWidget {
  ///移除widget
  final Function? onClear;

  const DebugFloatWidget({super.key, this.onClear});

  @override
  State<StatefulWidget> createState() => _DebugFloatState();
}

class _DebugFloatState extends State<DebugFloatWidget> implements ILog{
  bool _consoleLarge = false;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    LogManager.addListener(this);
  }

  @override
  void dispose() {
    super.dispose();
    LogManager.removeListener(this);
  }


  @override
  Widget build(BuildContext context) {
    _init();
    return Column(
      children: <Widget>[
        DecoratedBox(
          decoration: const BoxDecoration(color: Color(0x5f000000)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: double.infinity, //宽度尽可能大
                minHeight: 30.0),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                const Center(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(
                    "console",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: LibColors.libColorWhite,
                        fontSize: 16),
                  )),
                ),
                const Positioned(
                    left: 0,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        LibIconFonts.libIconTerminal,
                        color: LibColors.libColorWhite,
                        size: 20,
                      ),
                    )),
                Positioned(
                    right: 0,
                    child: Row(
                      children: [
                        _buildFont(_iconfont, () {
                          setState(() {
                            _consoleLarge = !_consoleLarge;
                          });
                        }),
                        _buildFont(LibIconFonts.libIconBin, () {
                          setState(() {
                            _list = List.from([]);
                          });
                        }),
                        _buildFont(LibIconFonts.libIconCross, () {
                          if (widget.onClear != null) {
                            widget.onClear!();
                          }
                        })
                      ].map((e) => Padding(
                                padding: const EdgeInsets.all(5),
                                child: e,
                              ))
                          .toList(),
                    )),
              ],
            ),
          ),
        ),
        DecoratedBox(
            decoration: const BoxDecoration(color: Color(0x66000000)),
            child: SizedBox(
              width: double.infinity,
              height: _consoleHeight,
              child: SingleChildScrollView(
                  controller: scrollController,
                  physics: _consoleLarge
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  child: Material(
                    color: Colors.transparent,
                    child: Text.rich(
                      TextSpan(children: _list),
                    ),
                  )),
            )),
      ],
      // )
    );
  }

  ///可点击按钮
  Widget _buildFont(IconData data, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        data,
        color: LibColors.libColorWhite,
        size: 17,
      ),
    );
  }

  void _scrollToend() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  // @override
  // void deactivate() {
  //   super.deactivate();
  //   _scrollToend();
  // }
  late double _consoleHeight;

  late IconData _iconfont;

  void _init() {
    if (_consoleLarge) {
      _consoleHeight = ScreenUtil.getScreenH(context) * 0.7;
      _iconfont = LibIconFonts.libIconShrink2;
    } else {
      _consoleHeight = 80;
      _iconfont = LibIconFonts.libIconEnlarge2;
    }
  }

  List<TextSpan> _list = [];


  @override
  void d(message, {String? tag}) {
    var color = LibColors.libColorWhite;
    var type = "D";
    toPrint(color, type, message);
  }

  @override
  void e(message, {error, StackTrace? stackTrace, String? tag}) {
    var color = LibColors.libErrorColor;
    var type = "E";
    toPrint(color, type, message);
  }

  @override
  void i(message, {String? tag}) {
    var color = LibColors.libInfoColor;
    var type = "I";
    toPrint(color, type, message);
  }

  @override
  void w(message, {String? tag}) {
    var color = LibColors.libWarningColor;
    var type = "W";
    toPrint(color, type, message);
  }

  void toPrint(Color color,String type,String message,{String? tag}){
    var msg = "$type>$tag\n $message \n";
    var text =
    TextSpan(text: msg, style: TextStyle(color: color, fontSize: 12));
    setState(() {
      _list = List.from(_list);
      _list.add(text);
      _scrollToend();
    });
  }
}
