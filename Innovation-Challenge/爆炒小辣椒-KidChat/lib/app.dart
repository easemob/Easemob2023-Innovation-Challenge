import 'package:flutter/material.dart';
import 'package:kid_chat/pages/home.dart';

import 'color_schemes.g.dart';

class KidChatApp extends StatefulWidget {
  const KidChatApp({super.key});

  @override
  State<KidChatApp> createState() => _KidChatAppState();
}

class _KidChatAppState extends State<KidChatApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kid Chat',
      theme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const HomePage(),
    );
  }
}
