import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';

import 'package:em_chat_uikit_example/conversations_page.dart';
import 'package:em_chat_uikit_example/custom_video_message/custom_message_page.dart';
import 'package:em_chat_uikit_example/messages_page.dart';

class ChatConfig {
  static const String appKey = '1178231110210627#demo';
  static const String userId = 'clientB';
  static const String password = '123456';
}

void main() async {
  assert(ChatConfig.appKey.isNotEmpty,
      "You need to configure AppKey information first.");
  WidgetsFlutterBinding.ensureInitialized();
  final options = EMOptions(
    appKey: ChatConfig.appKey,
    autoLogin: false,
    debugModel: true,
  );
  await EMClient.getInstance.init(options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => ChatUIKit(
        theme: ChatUIKitTheme(),
        child: child!,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _chatId = "agent";
  final List<String> _logText = [];
  String userId = ChatConfig.userId;
  String password = ChatConfig.password;
  final TextEditingController _userIdController = TextEditingController(text: ChatConfig.userId);
  final TextEditingController _passwordController = TextEditingController(text: ChatConfig.password);
  final TextEditingController _textController = TextEditingController(text: "agent");

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
            TextField(
              decoration: InputDecoration(
                labelText: 'User ID',
              ),
              controller: _userIdController,
              onChanged: (value) {
                setState(() {
                  userId = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              controller: _passwordController,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      _signIn(userId, password);
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: "Enter recipient's userId",
                    ),
                    onChanged: (chatId) => _chatId = chatId,
                  ),
                ),
                const SizedBox(height: 10),
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

  void _signIn(String userId, String password) async {
    _addLogToConsole('begin sign in...');
    try {
      bool judgmentPwdOrToken = false;
      do {
        if (password.isNotEmpty) {
          await EMClient.getInstance.login(userId, password);
          judgmentPwdOrToken = true;
          break;
        }
      } while (false);

      if (judgmentPwdOrToken) {
        _addLogToConsole('sign in success');
      } else {
        _addLogToConsole('sign in fail: The password and agoraToken cannot both be null.');
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
