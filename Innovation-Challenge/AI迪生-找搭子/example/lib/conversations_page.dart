import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';
import 'package:em_chat_uikit_example/messages_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConversationPage'),
      ),
      body: ChatConversationsView(
        onItemTap: (conversation) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MessagesPage(conversation)));
        },
      ),
    );
  }
}
