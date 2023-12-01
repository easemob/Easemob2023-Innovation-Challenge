import 'package:flutter/material.dart';

import '../../em_chat_uikit.dart';

class ChatConversationListTile extends StatelessWidget {
  const ChatConversationListTile({
    super.key,
    this.avatar,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.conversation,
  });

  final Widget? avatar;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function(EMConversation conversation)? onTap;
  final EMConversation conversation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: conversation.latestMessage(),
      builder: (context, snapshot) {
        EMMessage? msg;
        if (snapshot.hasData) {
          msg = snapshot.data!;
        }

        return ListTile(
          leading: avatar,
          title: title ??
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: title ??
                          Text(
                            conversation.id,
                            style: ChatUIKit.of(context)
                                    ?.theme
                                    .conversationListItemTitleStyle ??
                                const TextStyle(fontSize: 17),
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                    Text(
                      msg?.createTs ?? "",
                      style: ChatUIKit.of(context)
                              ?.theme
                              .conversationListItemTsStyle ??
                          const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ]),
          subtitle: subtitle ??
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Builder(
                  builder: (context) {
                    return Text(
                      msg?.summary(context) ?? "",
                      style: ChatUIKit.of(context)
                              ?.theme
                              .conversationListItemTitleStyle ??
                          const TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                )),
                FutureBuilder<int>(
                  future: conversation.unreadCount(),
                  builder: (context, snapshot) {
                    return ChatBadgeWidget(snapshot.data ?? 0);
                  },
                )
              ]),
          trailing: trailing,
          onTap: () => onTap?.call(conversation),
        );
      },
    );
  }
}
