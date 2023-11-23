import 'dart:async';
import 'package:flutter/widgets.dart';
/// Widget Util.
class WidgetUtil {
  bool _hasMeasured = false;
  double _width = 0;
  double _height = 0;

  /// Widget rendering listener.
  /// Widget渲染监听.
  /// context: Widget context.
  /// isOnce: true,Continuous monitoring  false,Listen only once.
  /// onCallBack: Widget Rect CallBack.
  void asyncPrepare(
      BuildContext context, bool isOnce, ValueChanged<Rect>? onCallBack) {
    if (_hasMeasured) return;
    WidgetsBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      RenderBox? box = getRenderBox(context);
      if (box != null) {
        if (isOnce) _hasMeasured = true;
        double width = box.semanticBounds.width;
        double height = box.semanticBounds.height;
        if (_width != width || _height != height) {
          _width = width;
          _height = height;
          if (onCallBack != null) onCallBack(box.semanticBounds);
        }
      }
    });
  }

  /// Widget渲染监听.
  void asyncPrepares(bool isOnce, ValueChanged<Rect>? onCallBack) {
    if (_hasMeasured) return;
    WidgetsBinding.instance?.addPostFrameCallback((Duration timeStamp) {
      if (isOnce) _hasMeasured = true;
      if (onCallBack != null) onCallBack(Rect.zero);
    });
  }

  ///get Widget Bounds (width, height, left, top, right, bottom and so on).Widgets must be rendered completely.
  ///获取widget Rect
  static Rect getWidgetBounds(BuildContext context) {
    RenderBox? box = getRenderBox(context);
    return box?.semanticBounds ?? Rect.zero;
  }

  static RenderBox? getRenderBox(BuildContext context) {
    RenderObject? renderObject = context.findRenderObject();
    RenderBox? box;
    if (renderObject != null) {
      box = renderObject as RenderBox;
    }
    return box;
  }

  ///Get the coordinates of the ui.widget on the screen.Widgets must be rendered completely.
  ///获取widget在屏幕上的坐标,widget必须渲染完成
  static Offset getWidgetLocalToGlobal(BuildContext context) {
    RenderBox? box = getRenderBox(context);
    return box == null ? Offset.zero : box.localToGlobal(Offset.zero);
  }

}
