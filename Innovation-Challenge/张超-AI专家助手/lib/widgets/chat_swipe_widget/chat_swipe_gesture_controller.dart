import 'package:flutter/material.dart';

import 'chat_swipe_change_notification.dart';

class ChatSwipeGestureController {
  ChatSwipeGestureController(
    TickerProvider vsync, {
    this.leftDragDistance = 0,
    this.rightDragDistance = 0,
    Duration duration = const Duration(milliseconds: 200),
  }) {
    gestureAnimationController = AnimationController(
      upperBound: leftDragDistance,
      lowerBound: -rightDragDistance,
      vsync: vsync,
      duration: duration,
    )..addListener(() {
        dxNotifier.value = gestureAnimationController.value;
      });

    dismissAnimationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 300));

    sizeAnimationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 500));
  }

  late AnimationController gestureAnimationController;
  late AnimationController dismissAnimationController;
  late AnimationController sizeAnimationController;

  double leftDragDistance = 0;
  double rightDragDistance = 0;
  ValueNotifier<double> dxNotifier = ValueNotifier(0);

  void dispose() {
    _cleanAnimController();
  }

  void _cleanAnimController() {
    gestureAnimationController.stop();
    gestureAnimationController.dispose();
    dismissAnimationController.stop();
    dismissAnimationController.dispose();
    sizeAnimationController.stop();
    sizeAnimationController.dispose();
  }

  void setDx(double dx) {
    dxNotifier.value =
        (dxNotifier.value + dx).clamp(-rightDragDistance, leftDragDistance);
  }

  void startMove(BuildContext context) {
    ChatSwipeChangeNotification(this).dispatch(context);
  }

  void willClear(BuildContext context) {
    ChatSwipeControllerClearNotification(this).dispatch(context);
  }

  void scrollEnd(BuildContext context, {double speed = 0}) async {
    gestureAnimationController.value = dxNotifier.value;
    double target = 0.0;

    if (dxNotifier.value > leftDragDistance / 2) {
      target = leftDragDistance;
    } else if (dxNotifier.value < -rightDragDistance / 2) {
      target = -rightDragDistance;
    }

    if (target == gestureAnimationController.value) return;

    await gestureAnimationController.animateBack(
      target,
      curve: Curves.easeOut,
    );
  }

  Future<void> close() async {
    if (dxNotifier.value == 0) {
      return;
    }

    await gestureAnimationController.animateBack(
      0,
      curve: Curves.ease,
    );
  }

  Future<void> dismiss() async {
    await dismissAnimationController.forward();
    await sizeAnimationController.forward();
  }
}
