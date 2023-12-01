import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'chat_swipe_gesture_controller.dart';

class ChatSwipeGestureDetector extends StatefulWidget {
  const ChatSwipeGestureDetector(
      {super.key,
      this.enable = true,
      required this.child,
      required this.controller,
      this.dragStartBehavior = DragStartBehavior.start});

  final bool enable;
  final Widget child;
  final ChatSwipeGestureController controller;
  final DragStartBehavior dragStartBehavior;

  @override
  State<ChatSwipeGestureDetector> createState() =>
      _ChatSwipeGestureDetectorState();
}

class _ChatSwipeGestureDetectorState extends State<ChatSwipeGestureDetector> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: !widget.enable ? null : _horizontalDragDown,
      onPanUpdate: !widget.enable ? null : _horizontalDragUpdate,
      onPanEnd: !widget.enable ? null : _horizontalDragEnd,
      child: ValueListenableBuilder(
        valueListenable: widget.controller.dxNotifier,
        builder: (BuildContext context, double value, Widget? child) {
          return Transform.translate(
            offset: Offset(value, 0),
            child: widget.child,
          );
        },
      ),
    );
  }

  void _horizontalDragDown(DragDownDetails details) {
    widget.controller.startMove(context);
  }

  @override
  void dispose() {
    widget.controller.willClear(context);
    super.dispose();
  }

  void _horizontalDragUpdate(DragUpdateDetails details) {
    widget.controller.setDx(details.delta.dx);
  }

  void _horizontalDragEnd(DragEndDetails details) {
    widget.controller
        .scrollEnd(context, speed: details.velocity.pixelsPerSecond.dx);
  }
}
