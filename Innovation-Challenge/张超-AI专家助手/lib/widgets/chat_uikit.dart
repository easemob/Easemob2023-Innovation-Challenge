import 'package:flutter/widgets.dart';

import '../em_chat_uikit.dart';

class ChatUIKit extends StatefulWidget {
  ChatUIKit({
    super.key,
    this.child,
    ChatUIKitTheme? theme,
  }) : theme = theme ?? ChatUIKitTheme();
  final Widget? child;
  final ChatUIKitTheme theme;

  static Widget init({TransitionBuilder? builder}) {
    if (builder != null) {}
    return ChatUIKit();
  }

  @override
  State<ChatUIKit> createState() => ChatUIKitState();

  static ChatUIKitState? of(BuildContext context) {
    ChatUIKitState? state;
    state = context.findAncestorStateOfType<ChatUIKitState>();

    return state;
  }
}

class ChatUIKitState extends State<ChatUIKit> {
  ChatUIKitTheme get theme => widget.theme;

  ChatConversationsController? conversationsController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}
