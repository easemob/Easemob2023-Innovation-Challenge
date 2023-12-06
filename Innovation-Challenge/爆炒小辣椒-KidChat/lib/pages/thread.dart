import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart'
    hide MessageType, MessageStatus;
import 'package:kid_chat/utils/easemob.dart';
import 'package:kid_chat/utils/message.dart';

class ThreadChatPage extends StatefulWidget {
  final EMMessage message;

  const ThreadChatPage(this.message, {super.key});

  @override
  State<ThreadChatPage> createState() => _ThreadChatPageState();
}

class _ThreadChatPageState extends State<ThreadChatPage> {
  late final EMConversation _conversation;
  late final scrollController = ScrollController();
  late final fromUserInfo = widget.message.fromUserInfo();

  late final String prompt;
  late final String content;

  late final List<types.Message> _messages = [];
  late var _self = types.User(id: EMClient.getInstance.currentUserId!);

  @override
  void initState() {
    final userId = EMClient.getInstance.currentUserId;
    assert(userId != null);

    assert(widget.message.body is EMCustomMessageBody);
    final body = widget.message.body as EMCustomMessageBody;

    prompt = body.params!["prompt"] as String;
    content = body.params!["content"] as String;

    _setup();

    super.initState();
  }

  void _onSendTapped(types.PartialText pt) {
    final message = EMMessage.createTxtSendMessage(
      targetId: _conversation.id,
      content: pt.text,
      chatType: ChatType.GroupChat,
    );
    message.isChatThreadMessage = true;

    EMClient.getInstance.chatManager.sendMessage(message);
    setState(() {
      _messages.add(message.forUI(_self));
    });
  }

  @override
  void dispose() {
    EMClient.getInstance.chatManager.removeMessageEvent("groupPage");
    EMClient.getInstance.chatManager.removeEventHandler("groupPage");
    super.dispose();
  }

  void _setup() async {
    // 自己的信息
    final userInfo = await EMClient.getInstance.userInfoManager
        .fetchOwnInfo(expireTime: 120);

    if (userInfo != null) {
      setState(() {
        _self = types.User(
            id: userInfo.userId,
            firstName: userInfo.nickName ?? "",
            imageUrl: userInfo.avatarUrl);
      });
    }

    // 查找对应的Thread
    EMChatThread? thread = await widget.message.chatThread();

    // 还没有人创建国子区， 在这里创建
    try {
      thread ??= await EMClient.getInstance.chatThreadManager.createChatThread(
        name: "PROMPT: $prompt",
        messageId: widget.message.msgId,
        parentId: publicGroupId,
      );
    } catch (e) {
      debugPrint("create thread failed $e");
    }
    assert(thread != null);

    try {
      // 尝试加入子区
      await EMClient.getInstance.chatThreadManager
          .joinChatThread(chatThreadId: thread!.threadId);
    } catch (e) {
      debugPrint("join thread failed $e");
    }

    EMClient.getInstance.chatManager.addEventHandler(
      "groupPage",
      EMChatEventHandler(
        onMessagesReceived: (messages) {
          _update(messages, append: true);
        },
      ),
    );

    EMClient.getInstance.chatManager.addMessageEvent(
      "groupPage",
      ChatMessageEvent(
        onSuccess: (id, m) async {
          final index = _messages.indexWhere((element) => element.id == id);
          if (index != -1) {
            setState(() {
              _messages[index] = m.forUI(_self);
            });
          }
        },
        onProgress: (id, progress) {},
        onError: (id, code, desc) {
          debugPrint(id.toString());
        },
      ),
    );

    final c = await EMClient.getInstance.chatManager.getConversation(
        thread!.threadId,
        type: EMConversationType.GroupChat,
        createIfNeed: true);

    assert(c != null);
    _conversation = c!;

    // 开始获取填充本地消息
    final messages =
        await _conversation.loadMessages(direction: EMSearchDirection.Up);

    // 从服务器拉一下历史消息
    if (messages.isEmpty) {
      final r = await EMClient.getInstance.chatManager.fetchHistoryMessages(
        conversationId: _conversation.id,
        pageSize: 20,
        type: EMConversationType.GroupChat,
      );
      messages.addAll(r.data);
    }

    _update(messages, append: false);
  }

  void _update(List<EMMessage> messages, {bool append = false}) async {
    final initialMessages = <types.Message>[];
    final userInfos = await EMClient.getInstance.userInfoManager
        .fetchUserInfoById(messages.map((e) => e.from!).toList());
    for (final m in messages) {
      initialMessages.add(m.forUI(userInfos.values
          .firstWhere((element) => element.userId == m.from,
              orElse: () => EMUserInfo.fromJson({"userId": m.from}))
          .forUI()));
    }

    setState(() {
      if (!append) {
        _messages.clear();
      }
      _messages.addAll(initialMessages);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(prompt),
        actions: [
          FutureBuilder(
            future: fromUserInfo,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final userInfo = snapshot.data as EMUserInfo;
                if (userInfo.avatarUrl != null) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(userInfo.avatarUrl!),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Chat(
        messages: _messages.reversed.toList(growable: false),
        onSendPressed: _onSendTapped,
        user: _self,
        l10n: const ChatL10nZhCN(),
        theme: DarkChatTheme(
          backgroundColor: theme.colorScheme.background,
          primaryColor: theme.colorScheme.primaryContainer,
          secondaryColor: theme.colorScheme.secondaryContainer,
          inputBackgroundColor: theme.colorScheme.primaryContainer,
        ),
        showUserAvatars: true,
        showUserNames: true,
        avatarBuilder: (user) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
            foregroundImage: user.imageUrl != null
                ? CachedNetworkImageProvider(user.imageUrl!)
                : null,
          ),
        ),
      ),
    );
  }
}
