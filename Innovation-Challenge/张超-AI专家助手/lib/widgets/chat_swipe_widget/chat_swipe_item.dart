import 'package:flutter/material.dart';

import '../../em_chat_define.dart';

class ChatSwipeItem {
  const ChatSwipeItem({
    required this.text,
    this.dismissed,
    this.itemWidth = 80,
    this.backgroundColor = Colors.white,
    this.confirmAction,
    this.style = const TextStyle(color: Colors.white),
  });

  final void Function(bool dismissed)? dismissed;
  final TextStyle style;
  final String text;
  final Color backgroundColor;
  final double itemWidth;
  final ChatConfirmDismissCallback? confirmAction;
}
