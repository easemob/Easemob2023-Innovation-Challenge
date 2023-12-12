import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';

import 'mappings.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage(this.conversation, {super.key});

  final EMConversation conversation;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late final ChatMessageListController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatMessageListController(widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
        actions: [
          UnconstrainedBox(
            child: InkWell(
              onTap: () {
                controller.deleteAllMessages();
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Delete',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ChatMessagesView(
          messageListViewController: controller,
          conversation: widget.conversation,
          avatarBuilder: (context, userId) => CircleAvatar(
            backgroundImage: UserAvatarMappings.getAvatar(userId),
          ),
          onError: (error) {
            final snackBar = SnackBar(
              content: Text('Error: ${error.description}'),
              duration: const Duration(milliseconds: 1000),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
          inputBarMoreActionsOnTap: (items) {
            ChatBottomSheetItem item =
                ChatBottomSheetItem.normal('more', onTap: () async {});

            return items + [item];
          },
        ),
      ),
    );
  }
}
