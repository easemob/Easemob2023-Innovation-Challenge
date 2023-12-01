import 'package:flutter/widgets.dart';

const Color _kDefaultGlowColor = Color(0xFFFFFFFF);

class ChatScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    // When modifying this function, consider modifying the implementation in
    // the Material and Cupertino subclasses as well.
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.android:
        return child;
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          axisDirection: details.direction,
          color: _kDefaultGlowColor,
          child: child,
        );
    }
  }
}
