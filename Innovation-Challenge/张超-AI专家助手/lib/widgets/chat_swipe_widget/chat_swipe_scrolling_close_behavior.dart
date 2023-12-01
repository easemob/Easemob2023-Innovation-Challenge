import 'package:flutter/material.dart';

import 'chat_swipe_gesture_controller.dart';

class ChatSwipeScrollingCloseBehavior extends StatefulWidget {
  const ChatSwipeScrollingCloseBehavior({
    super.key,
    required this.child,
    required this.controller,
  });

  final ChatSwipeGestureController? controller;

  final Widget child;

  @override
  ChatSwipeScrollingCloseBehaviorState createState() =>
      ChatSwipeScrollingCloseBehaviorState();
}

class ChatSwipeScrollingCloseBehaviorState
    extends State<ChatSwipeScrollingCloseBehavior> {
  ScrollPosition? scrollPosition;
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    removeScrollingListener();
    addScrollingListener();
  }

  void addScrollingListener() {
    scrollPosition = Scrollable.of(context).position;
    if (scrollPosition != null) {
      scrollPosition!.isScrollingNotifier.addListener(handleScrollingChanged);
    }
  }

  void removeScrollingListener() {
    scrollPosition?.isScrollingNotifier.removeListener(handleScrollingChanged);
  }

  @override
  void dispose() {
    removeScrollingListener();
    super.dispose();
  }

  void handleScrollingChanged() {
    widget.controller?.willClear(context);
    widget.controller?.close();
  }
}
