import 'package:flutter/material.dart';

import '../chat_uikit.dart';

class ChatBadgeWidget extends StatelessWidget {
  const ChatBadgeWidget(
    this.unreadCount, {
    super.key,
    this.maxCount = 99,
  });
  final int unreadCount;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: () {
        if (unreadCount == 0) {
          return const Offstage();
        } else if (unreadCount < 0) {
          return Container(
            decoration: BoxDecoration(
                color: ChatUIKit.of(context)?.theme.badgeColor ??
                    const Color.fromRGBO(255, 20, 204, 1),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            width: 10,
            height: 10,
          );
        } else {
          String unreadStr = unreadCount.toString();
          if (unreadCount > maxCount) {
            unreadStr = '$maxCount+';
          }
          return Container(
            decoration: BoxDecoration(
                color: ChatUIKit.of(context)?.theme.badgeColor ??
                    const Color.fromRGBO(255, 20, 204, 1),
                border: Border.all(
                  color: ChatUIKit.of(context)?.theme.badgeBorderColor ??
                      Colors.white,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(30))),
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Text(
              style: ChatUIKit.of(context)?.theme.badgeTextStyle ??
                  const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
              unreadStr,
            ),
          );
        }
      }(),
    );
  }
}
