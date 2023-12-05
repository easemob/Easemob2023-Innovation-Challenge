import 'package:em_chat_uikit/em_chat_uikit.dart';
import 'package:flutter/material.dart';

class BotChatPage extends StatefulWidget {
  const BotChatPage({super.key});

  @override
  State<BotChatPage> createState() => _BotChatState();
}

class _BotChatState extends State<BotChatPage> {
  final ChatConversationsController conversationsController =
      ChatConversationsController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('bot chat'), actions: [
        UnconstrainedBox(
            child: InkWell(
          onTap: () {
            EMClient.getInstance.chatManager
                .fetchConversation(cursor: '1')
                .then((list) {
              conversationsController.conversationList.addAll(list.data);
              debugPrint("load ${list.data.length}");
            });
            debugPrint("click");
          },
          child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Refresh',
                style: TextStyle(fontSize: 16),
              )),
        ))
      ]),
      body: ChatConversationsView(
          onItemTap: ((conversation) => {debugPrint(conversation.id)})),
    );
  }
}
