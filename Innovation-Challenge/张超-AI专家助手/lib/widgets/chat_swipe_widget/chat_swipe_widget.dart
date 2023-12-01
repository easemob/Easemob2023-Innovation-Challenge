import 'package:flutter/material.dart';

export 'chat_swipe_gesture_controller.dart';
export 'chat_swipe_gesture_detector.dart';
export 'chat_swipe_item.dart';
export 'chat_swipe_scrolling_close_behavior.dart';
export 'chat_swipe_auto_close_behavior.dart';

import 'chat_swipe_gesture_controller.dart';
import 'chat_swipe_gesture_detector.dart';
import 'chat_swipe_item.dart';
import 'chat_swipe_scrolling_close_behavior.dart';

class ChatSwipeWidget extends StatefulWidget {
  const ChatSwipeWidget({
    super.key,
    this.leftSwipeItems,
    this.rightSwipeItems,
    this.enable = true,
    this.animationDuration = const Duration(milliseconds: 500),
    required this.child,
  });

  final List<ChatSwipeItem>? leftSwipeItems;
  final List<ChatSwipeItem>? rightSwipeItems;
  final Widget child;
  final bool enable;
  final Duration animationDuration;

  @override
  State<ChatSwipeWidget> createState() => _ChatSwipeWidgetState();
}

class _ChatSwipeWidgetState extends State<ChatSwipeWidget>
    with TickerProviderStateMixin {
  ChatSwipeGestureController? controller;

  double maxLeftDragDistance = 0;
  double maxRightDragDistance = 0;
  bool dismissed = false;
  @override
  void initState() {
    super.initState();
    updateItem();
  }

  updateItem() {
    maxLeftDragDistance = 0;
    maxRightDragDistance = 0;

    widget.leftSwipeItems?.forEach((element) {
      maxLeftDragDistance += element.itemWidth;
    });

    widget.rightSwipeItems?.forEach((element) {
      maxRightDragDistance += element.itemWidth;
    });

    if (controller != null) {
      controller?.dispose();
    }

    controller = ChatSwipeGestureController(
      this,
      duration: widget.animationDuration,
      rightDragDistance: maxRightDragDistance,
      leftDragDistance: maxLeftDragDistance,
    );
  }

  @override
  void didUpdateWidget(covariant ChatSwipeWidget oldWidget) {
    updateItem();
    // controller?.dxNotifier = ValueNotifier(0);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> leftWidgets = [];
    widget.leftSwipeItems?.forEach((element) {
      leftWidgets.add(InkWell(
        onTap: () => onTapAction(element),
        child: Container(
          alignment: Alignment.center,
          width: element.itemWidth,
          color: element.backgroundColor,
          child: Text(
            element.text,
            style: element.style,
          ),
        ),
      ));
    });

    Widget leftWidget =
        leftWidgets.isNotEmpty ? Row(children: leftWidgets) : const Offstage();

    final List<Widget> rightWidgets = [];
    widget.rightSwipeItems?.forEach((element) {
      rightWidgets.add(InkWell(
        onTap: () => onTapAction(element),
        child: Container(
          width: element.itemWidth,
          alignment: Alignment.center,
          color: element.backgroundColor,
          child: Text(
            element.text,
            style: element.style,
          ),
        ),
      ));
    });

    controller!.dismissAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        dismissed = true;
        setState(() {});
      }
    });
    Widget rightWidget = rightWidgets.isNotEmpty
        ? Row(children: rightWidgets)
        : const Offstage();
    final slideAnimation = controller!.dismissAnimationController.view
        .drive(CurveTween(curve: Curves.easeOutCirc))
        .drive(Tween<Offset>(begin: Offset.zero, end: const Offset(1.0, 0.0)));

    Widget content = SlideTransition(
      textDirection: TextDirection.rtl,
      position: slideAnimation,
      child: WillPopScope(
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [leftWidget, rightWidget],
              ),
            ),
            ChatSwipeGestureDetector(
              enable: widget.enable,
              controller: controller!,
              child: ChatSwipeScrollingCloseBehavior(
                controller: controller,
                child: widget.child,
              ),
            ),
          ],
        ),
        onWillPop: () async {
          if (controller!.dxNotifier.value != 0) {
            controller!.scrollEnd(context);
            return false;
          }
          return true;
        },
      ),
    );

    if (dismissed) {
      final sizeAnimation = controller!.sizeAnimationController.view
          .drive(CurveTween(curve: Curves.easeOutCirc))
          .drive(Tween(begin: 1.0, end: 0.0));
      content = SizeTransition(
        axis: Axis.vertical,
        sizeFactor: sizeAnimation,
        child: content,
      );
    }

    return content;
  }

  void onTapAction(ChatSwipeItem item) async {
    bool confirmAction = false;

    if (item.confirmAction != null) {
      confirmAction = await item.confirmAction?.call(context) ?? confirmAction;
    }
    if (!confirmAction) {
      await controller?.close();
    } else {
      await controller?.dismiss();
    }
    item.dismissed?.call(confirmAction);
  }
}
