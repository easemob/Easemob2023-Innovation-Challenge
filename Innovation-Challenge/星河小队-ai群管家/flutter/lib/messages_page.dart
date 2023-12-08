import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';
import './api.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage(this.conversation, {super.key});

  final EMConversation conversation;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late final ChatMessageListController controller;
  var aiRoles = List<Map>.empty(growable: true);
  var selectedRole = 1;
  // late ChatDialog helpDialog;
  // var showDialog = false;

  ChatDialog buildHelp(BuildContext ctx) {
    return ChatDialog.normal(
      title: "help panel",
      subTitle: "list: 获取当前支持的ai助手角色\nuse: 使用ai助手角色\nask: 向ai助手提问\nhelp: 显示帮助",
      items: [
        ChatDialogItem.confirm(
          label: "confirm",
          onTap: (par) => {Navigator.pop(ctx)},
        )
      ],
    );
  }

  bool handleCallBot(List<String> cmd, EMMessage msg) {
    if (cmd.isEmpty) {
      return true;
    }
    debugPrint("handle callbot");
    var command = cmd[0];
    var params = cmd.sublist(1);
    switch (command) {
      case "list":
        if (aiRoles.isEmpty) {
          aiRoleList().then((value) {
            if (value != null) {
              setState(() {
                aiRoles.addAll(value
                    .map((e) => {'id': e['id'], 'desc': e['description']}));
              });
            }
          });
        }
        break;
      case "use":
        var selectedIdx = int.tryParse(params[0]);
        if (selectedIdx != null) {
          setState(() {
            selectedRole = aiRoles[selectedIdx]['id'];
          });
        }
        return false;
      case "ask":
        askBot(params.join(' '), selectedRole.toString(), msg.from, msg.to);
        break;
      case "help":
        showDialog(context: context, builder: buildHelp);
        return false;
      default:
    }
    return true;
  }

  List<Widget> buildAiRoles() {
    var res = List<Widget>.empty(growable: true);
    res.add(const Align(
      alignment: Alignment.topLeft,
      child: Text("ai roles"),
    ));
    for (var role in aiRoles) {
      res.add(Text.rich(TextSpan(
          text: role['id'].toString(),
          style: const TextStyle(fontStyle: FontStyle.italic))));
      res.add(Text(
        " " + (role['desc'] ?? ""),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ));
    }
    return res;
  }

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
          ),
          UnconstrainedBox(
            child: InkWell(
              onTap: () {
                showDialog(context: context, builder: buildHelp);
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'help',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Stack(
        children: [
          ListView(
            scrollDirection: Axis.horizontal,
            children: buildAiRoles(),
          ),
          ChatMessagesView(
            messageListViewController: controller,
            conversation: widget.conversation,
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
            willSendMessage: (msg) {
              if (msg.body is! EMTextMessageBody) {
                return msg;
              }
              var textMsg = msg.body as EMTextMessageBody;
              if (msg.to == "user_bot") {
                List<String> cmd;
                if (textMsg.content.startsWith('/')) {
                  cmd = textMsg.content.substring(1).split(' ');
                } else {
                  cmd = textMsg.content.split(' ');
                  cmd.insert(0, "ask");
                }
                if (handleCallBot(cmd, msg)) {
                  return msg;
                } else {
                  return null;
                }
              }
              return msg;
            },
          ),
        ],
      )),
    );
  }
}
