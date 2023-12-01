import 'package:flutter/widgets.dart';

import 'chat_swipe_gesture_controller.dart';

class ChatSwipeChangeNotification extends Notification {
  ChatSwipeChangeNotification(this.controller);
  final ChatSwipeGestureController? controller;
}

class ChatSwipeControllerClearNotification extends Notification {
  ChatSwipeControllerClearNotification(this.controller);
  final ChatSwipeGestureController? controller;
}
