import 'package:flutter/material.dart';

import '../../../em_chat_uikit.dart';

class ChatMessageStatusWidget extends StatelessWidget {
  const ChatMessageStatusWidget(
    this.message, {
    super.key,
    this.onTap,
  });

  final EMMessage message;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget? content;

    if (message.status == MessageStatus.PROGRESS) {
      content = const SizedBox(
        width: 7,
        height: 7,
        child: CircularProgressIndicator(strokeWidth: 1.0, color: Colors.grey),
      );
    }

    if (message.status == MessageStatus.FAIL) {
      content = InkWell(
        onTap: onTap,
        child: const Icon(Icons.error_outline, size: 11.2, color: Colors.red),
      );
    }

    if (message.status == MessageStatus.SUCCESS) {
      if (message.hasReadAck) {
        content = const Icon(
          Icons.done_all,
          size: 11.2,
          color: Color.fromRGBO(0, 204, 119, 1),
        );
      } else {
        content = const Icon(Icons.done, size: 11.2, color: Colors.grey);
      }

      // if (message.hasDeliverAck && message.hasReadAck) {
      //   content = const Icon(
      //     Icons.done_all,
      //     size: 11.2,
      //     color: Color.fromRGBO(0, 204, 119, 1),
      //   );
      // } else if (message.hasDeliverAck || message.hasReadAck) {
      //   content = const Icon(Icons.done, size: 11.2, color: Colors.grey);
      // }
    }

    return content ?? const Offstage();
  }
}
