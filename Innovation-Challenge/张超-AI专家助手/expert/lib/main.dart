import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';

import 'package:em_chat_uikit_example/conversations_page.dart';
import 'package:em_chat_uikit_example/custom_video_message/custom_message_page.dart';
import 'package:em_chat_uikit_example/messages_page.dart';

class ChatConfig {
  static const String appKey = '1145230613161200#demo';
  static const String userId = '1_tom';
  static const String password = '1';
}

void main() async {
  assert(ChatConfig.appKey.isNotEmpty,
      "You need to configure AppKey information first.");
  WidgetsFlutterBinding.ensureInitialized();
  final options = EMOptions(
    appKey: ChatConfig.appKey,
    autoLogin: false,
  );
  await EMClient.getInstance.init(options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easemob Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => ChatUIKit(
        theme: ChatUIKitTheme(),
        child: child!,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyHomePage(title: 'Easemob Assistant'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();
  EMConversation? conversation;
  String _chatId = "";
  final List<String> _logText = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            const Text("login userId: ${ChatConfig.userId}"),
            const Text("password: ${ChatConfig.password}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      _signIn();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                    child: const Text("SIGN IN"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _signOut();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                    child: const Text("SIGN OUT"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Enter recipient's userId",
                  ),
                  onChanged: (chatId) => _chatId = chatId,
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        pushToChatPage(_chatId);
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlue),
                      ),
                      child: const Text("START CHAT"),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        pushToCustomChatPage(_chatId);
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.lightBlue),
                      ),
                      child: const Text("CUSTOM CHAT"),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                pushToConversationPage();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
              ),
              child: const Text("CONVERSATION"),
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return Text(_logText[index]);
                },
                itemCount: _logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pushToConversationPage() async {
    if (EMClient.getInstance.currentUserId == null) {
      _addLogToConsole('user not login');
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const ConversationsPage();
    }));
  }

  void pushToChatPage(String userId) async {
    if (userId.isEmpty) {
      _addLogToConsole('UserId is null');
      return;
    }
    if (EMClient.getInstance.currentUserId == null) {
      _addLogToConsole('user not login');
      return;
    }
    EMConversation? conv =
        await EMClient.getInstance.chatManager.getConversation(userId);
    Future(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return MessagesPage(conv!);
      }));
    });
  }

  void pushToCustomChatPage(String userId) async {
    if (userId.isEmpty) {
      _addLogToConsole('UserId is null');
      return;
    }
    if (EMClient.getInstance.currentUserId == null) {
      _addLogToConsole('user not login');
      return;
    }
    EMConversation? conv =
        await EMClient.getInstance.chatManager.getConversation(userId);
    Future(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return CustomMessagesPage(conv!);
      }));
    });
  }

  void _signIn() async {
    _addLogToConsole('begin sign in...');
    try {
      bool judgmentPwdOrToken = false;
      do {
        if (ChatConfig.password.isNotEmpty) {
          await EMClient.getInstance.login(
            ChatConfig.userId,
            ChatConfig.password,
          );
          judgmentPwdOrToken = true;
          break;
        }
      } while (false);
      if (judgmentPwdOrToken) {
        _addLogToConsole('sign in success');
      } else {
        _addLogToConsole(
            'sign in fail: The password and agoraToken cannot both be null.');
      }
    } on EMError catch (e) {
      _addLogToConsole('sign in fail: ${e.description}');
    }
  }

  void _signOut() async {
    _addLogToConsole('begin sign out...');
    try {
      await EMClient.getInstance.logout();
      _addLogToConsole('sign out success');
    } on EMError catch (e) {
      _addLogToConsole('sign out fail: ${e.description}');
    }
  }

  void _addLogToConsole(String log) {
    _logText.add("$_timeString: $log");
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }
}
