# Get Started with Chat UIKit for Flutter

## Overview

Instant messaging connects people wherever they are and allows them to communicate with others in real time. With built-in user interfaces (UI) for the message list, the [Chat UI Samples](https://github.com/easemob/em_chat_uikit) enables you to quickly embed real-time messaging into your app without requiring extra effort on the UI.
 
This page shows a sample code to add one-to-one chat and group chat messaging into your app by using the Flutter Chat UI Samples.
'em_chat_uikit' currently has two modular widgets:

`ChatConversationsView` ChatConversationsView lists the existing conversations. The avatar and nickname displayed on the conversation view can be returned through callbacks.

`ChatMessagesView` ChatMessagesView lists messages in the current conversation, including text, image, voice, and file messages. The avatar and nickname displayed on the message view can be returned through callbacks.

easemob offers an open-source em_chat_uikit project on GitHub. You can clone and run the project or refer to the logic in it to create projects integrating em_chat_uikit.

Source code URL of em_chat_uikit for Flutter:

https://github.com/easemob/em_chat_uikit

## Function

The `em_chat_uikit` library provides the following functions:

- Sends and receives messages, displays messages, shows the unread message count, and clears messages. The text, image, emoji, file, and audio messages are supported.
- Deletes conversations and messages. 
- Customizes the UI. 

<table>
  <tr>
    <td>Widget</td>
    <td>Function</td>
    <td>Description</td>
  </tr>
  <tr>
    <td> ChatUIKit </td>
    <td></td>
    <td> The root of all widgets in ChatUIKit. </td>
  </tr>
    <td rowspan="2"> ChatConversationsView </td>
    <td> Conversation list </td>
    <td> Presents the conversation information, including the user's avatar and nickname, content of the last message, unread message count, and the time when the last message is sent or received.</td>
  <tr>
    <td>Delete conversation</td>
    <td>Deletes the conversation from the conversation list.</td>
  </tr>
  <tr>
    <td rowspan="4">ChatMessagesView</td>
    <td>Message sender</td>
    <td>Sends text, emoji, image, file, and voice messages.</td>
  </tr>
  <tr>
    <td>Delete messages</td>
    <td>Deletes messages.</td>
  </tr>
  <tr>
    <td>Recall message</td>
    <td>Recalls message that are sent within 120 seconds.</td>
  </tr>
  <tr>
    <td>Display message</td>
    <td>Displays one-to-one messages and group messages, including the user's avatar and nickname and the message's content, sending time or reception time, sending status, and read status. The text, image, emoji, file, voice, and video messages can be displayed.</td> 
  </tr>
</table>


## Dependencies

The following third-party UI libraries are used in em_chat_uikit:

```dart
dependencies:
  im_flutter_sdk: 4.0.2
  image_picker: 0.8.6+4
  file_picker: 4.6.1
  record: 4.4.4
  audioplayers: 3.0.1
  common_utils: 2.1.0
```

## Permissions

### Android

```dart
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```

### iOS

In `Info.plist`， add the following permissions:

| Key | Type | Value |
| :------------ | :----- | :------- | 
| `Privacy - Microphone Usage Description` | String | For microphone access |
| `Privacy - Camera Usage Description` | String | For camera access |
| `Privacy - Photo Library Usage Description` | String | For photo library access |

## Prevent code obfuscation

In the `example/android/app/proguard-rules.pro` file, add the following lines to prevent code obfuscation:

```
-keep class com.hyphenate.** {*;}
-dontwarn  com.hyphenate.**
```

## Integrate the UIKit

### pub.dev integration

```dart
flutter pub add em_chat_uikit
flutter pub get
```

### Local integration

You can download the project to your computer and execute it.

```dart
dependencies:
    em_chat_uikit:
        path: `<#uikit path#>`
```

## Usage

Before calling ChatUIKit, you need to make sure that the flutter chat SDK is initialized and the ChatUIKit widget is at the top of you widget tree. You can add it in the `MaterialApp` builder. 

### ChatUIKit

You must have a ChatUIKit widget at the top of you widget tree.

| Prop | Description |
| :-------------- | :----- |
| theme | Chat UIKit theme for setting component styles. If this prop is not set, the default style will be used.|

```dart
import 'package:em_chat_uikit/em_chat_uikit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child){
        return ChatUIKit(child: child!);
      },
      home: const MyHomePage(title: 'Flutter Demo'),
    );
  }
}
```

### ChatConversationsView

The 'ChatConversationsView' allows you to quickly display and manage the current conversations.

| Prop| Description |
| :-------------- | :----- |
| controller | The ScrollController for the conversation list. |
| itemBuilder | Conversation list item builder. Return a widget if you need to customize it. | 
| avatarBuilder | Avatar builder. If this prop is not implemented or you return `null`, the default avatar will be used.|
| nicknameBuilder | Nickname builder. If you don't set this prop or return `null`, the conversation ID is displayed. |  
| onItemTap | The callback of the click event of the conversation list item. | 

```dart
class _ConversationsPageState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conversations")),
      body: ChatConversationsView(
        onItemTap: (conversation) {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (ctx) => ChatPage(conversation),
                ),
              )
              .then((value) => ChatUIKit.of(context)
                  .conversationsController
                  .loadAllConversations());
        },
      ),
    );
  }
}
```

For more information, see `ChatConversationsView`.

```dart
  const ChatConversationsView({
    super.key,
    this.onItemTap,
    this.controller,
    this.reverse = false,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.down,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.itemBuilder,
    this.avatarBuilder,
    this.nicknameBuilder,
  });
```

### ChatMessagesView

`ChatMessagesView` is used to manage text, image, emoji, file, and voice messages:
- Sends and receives messages.
- Deletes messages.
- Recalls messages.

| Prop | Prop Description |
| :-------------- | :----- |
| inputBar | Text input component. If you don't pass in this prop, `ChatInputBar` will be used by default.|
| conversation | The conversation to which the messages belong. |
| onTap | Message bubble click callback.|
| onBubbleLongPress | Callback for holding a message bubble.|
| onBubbleDoubleTap| Callback for double-clicking a message bubble.|
| avatarBuilder | Avatar component builder.|
| nicknameBuilder | Nickname component builder.|
| itemBuilder| Message bubble. If you don't set this prop, the default bubble will be used. |
| moreItems | Action items displayed after a message bubble is held down. If you return `null` in `onBubbleLongPress`, `moreItems` will be used. This prop involves three default actions: copy, delete, and recall. | 
| messageListViewController | Message list controller. You are advised to use the default value. For details, see `ChatMessageListController`.  |
| willSendMessage | Text message pre-sending callback. This callback needs to return a `ChatMessage` object.  |
| onError| Error callbacks, such as no permissions.  |
| enableScrollBar | Whether to enable the scroll bar. The scroll bar is enabled by default.  |
| needDismissInputWidget | Callback for dismissing the input widget. If you use a custom input widget, dismiss the input widget when you receive this callback, for example, by calling `FocusNode.unfocus`. See `ChatInputBar`. |
| inputBarMoreActionsOnTap | The callback for clicking the plus symbol next to the input box. You need to return the `ChatBottomSheetItems` list.     |  


```dart
class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        child: ChatMessagesView(conversation: widget.conversation),
      ),
    );
  }
}

```

For more information, see `ChatMessagesView`.

```dart
  const ChatMessagesView({
    super.key,
    this.inputBar,
    required this.conversation,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.avatarBuilder,
    this.nicknameBuilder,
    this.titleAvatarBuilder,
    this.moreItems,
    this.messageListViewController,
    this.willSendMessage,
  });
```

#### Customize colors

You can set the color when adding `ChatUIKit`. See `ChatUIKitTheme`.

```dart
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```

#### Add an avatar

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        child: ChatMessagesView(
          conversation: widget.conversation,
          avatarBuilder: (context, userId) {
            // Returns the avatar widget that you want to display.
            return Container(
              width: 30,
              height: 30,
              color: Colors.red,
            );
          },
        ),
      ),
    );
  }
}
```

#### Add a nickname

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        child: ChatMessagesView(
          conversation: widget.conversation,
          // Returns the nickname widget that you want to display.
          nicknameBuilder: (context, userId) {
            return Text(userId);
          },
        ),
      ),
    );
  }
}
```

#### Add the bubble click event

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        child: ChatMessagesView(
          conversation: widget.conversation,
          onTap: (context, message) {
            bubbleClicked(message);
            return true;
          },
        ),
      ),
    );
  }

  void bubbleClicked(ChatMessage message) {
    debugPrint('bubble clicked');
  }
}
```

### Customize the message item widget 

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        child: ChatMessagesView(
          conversation: widget.conversation,
          itemBuilder: (context, model) {
            if (model.message.body.type == MessageType.TXT) {
              return CustomTextItemWidget(
                model: model,
                onTap: (context, message) {
                  bubbleClicked(message);
                  return true;
                },
              );
            }
          },
        ),
      ),
    );
  }

  void bubbleClicked(ChatMessage message) {
    debugPrint('bubble clicked');
  }
}

class CustomTextItemWidget extends ChatMessageListItem {
  const CustomTextItemWidget({super.key, required super.model, super.onTap});

  @override
  Widget build(BuildContext context) {
    ChatTextMessageBody body = model.message.body as ChatTextMessageBody;

    Widget content = Text(
      body.content,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 50,
        fontWeight: FontWeight.w400,
      ),
    );
    return getBubbleWidget(content);
  }
}

```

### Customize the input widget

```dart
class _MessagesPageState extends State<MessagesPage> {
  late ChatMessageListController _msgController;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _msgController = ChatMessageListController(widget.conversation);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.conversation.id)),
      body: SafeArea(
        child: ChatMessagesView(
          conversation: widget.conversation,
          messageListViewController: _msgController,
          inputBar: inputWidget(),
          needDismissInputWidget: () {
            _focusNode.unfocus();
          },
        ),
      ),
    );
  }

  Widget inputWidget() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _textController,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                final msg = ChatMessage.createTxtSendMessage(
                    targetId: widget.conversation.id,
                    content: _textController.text);
                _textController.text = '';
                _msgController.sendMessage(msg);
              },
              child: const Text('Send'))
        ],
      ),
    );
  }
}

```

### Delete all Messages in the current conversation

```dart
class _MessagesPageState extends State<MessagesPage> {
  late ChatMessageListController _msgController;

  @override
  void initState() {
    super.initState();
    _msgController = ChatMessageListController(widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
        actions: [
          TextButton(
              onPressed: () {
                _msgController.deleteAllMessages();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SafeArea(
        child: ChatMessagesView(
          conversation: widget.conversation,
          messageListViewController: _msgController,
        ),
      ),
    );
  }
}
```

### Customize actions displayed upon a click of the plus symbol in the conversation 

```dart
class _MessagesPageState extends State<MessagesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
      ),
      body: SafeArea(
        child: ChatMessagesView(
          conversation: widget.conversation,
          inputBarMoreActionsOnTap: (items) {
            ChatBottomSheetItem item =
                ChatBottomSheetItem('more', onTap: customMoreAction);

            return items + [item];
          },
        ),
      ),
    );
  }

  void customMoreAction() {
    debugPrint('custom action');
    Navigator.of(context).pop();
  }
}
```

## Sample Project

If the demo is required, configure the following information in the `example/lib/main.dart` file:

Replaces <#Your app key#>, <#Your created user#>, and <#User password#> and with your own App Key, user ID, and user token generated in easemob Console.

```dart
class ChatConfig {
  static String appkey = <#Your app key#>;
  static String userId = <#Your created user#>;
  static String password = <#User password#>;
}
```

## License

The sample projects are under the MIT license.