import 'package:flutter/material.dart';

import 'chat_swipe_change_notification.dart';
import 'chat_swipe_gesture_controller.dart';

class ChatSwipeAutoCloseBehavior extends StatefulWidget {
  const ChatSwipeAutoCloseBehavior({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  State<StatefulWidget> createState() => _ChatSwipeAutoCloseBehaviorState();
}

class _ChatSwipeAutoCloseBehaviorState
    extends State<ChatSwipeAutoCloseBehavior> {
  ChatSwipeGestureController? _lastController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = NotificationListener<ChatSwipeControllerClearNotification>(
      onNotification: (notification) {
        if (_lastController == notification.controller) {
          _lastController = null;
        }
        return true;
      },
      child: widget.child,
    );

    return NotificationListener<ChatSwipeChangeNotification>(
      onNotification: (notification) {
        if (_lastController != null &&
            _lastController != notification.controller) {
          _lastController?.close();
        }
        _lastController = notification.controller;
        return true;
      },
      child: content,
    );
  }

  @override
  void didUpdateWidget(covariant ChatSwipeAutoCloseBehavior oldWidget) {
    _lastController = null;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _lastController = null;
    super.dispose();
  }
}
