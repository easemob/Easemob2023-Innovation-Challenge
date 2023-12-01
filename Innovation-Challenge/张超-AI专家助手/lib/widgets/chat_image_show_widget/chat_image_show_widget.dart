import 'dart:io';

import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';
import 'package:em_chat_uikit/internal/chat_method.dart';

class ChatImageShowWidget extends StatefulWidget {
  const ChatImageShowWidget(this.message, {super.key});

  final EMMessage message;

  @override
  State<ChatImageShowWidget> createState() => _ChatImageShowWidgetState();
}

class _ChatImageShowWidgetState extends State<ChatImageShowWidget> {
  final ValueNotifier<int> _progress = ValueNotifier(0);
  final ValueNotifier<bool> showLargeImage = ValueNotifier(false);
  final String _msgEventKey = "ImageDownLoadEventKey";
  EMImageMessageBody? body;
  EMMessage? message;
  @override
  void initState() {
    super.initState();
    message = widget.message;
    checkFile();
  }

  void checkFile() {
    body = message!.body as EMImageMessageBody;
    final file = File(body!.localPath);
    if (file.existsSync()) {
      showLargeImage.value = true;
    } else {
      showLargeImage.value = false;
      _downloadImage(message!);
      chatClient.chatManager.addMessageEvent(
        _msgEventKey,
        ChatMessageEvent(
          onProgress: (msgId, progress) {
            if (msgId == message!.msgId) {
              _progress.value = progress;
            }
          },
          onSuccess: (msgId, msg) {
            if (msgId == message!.msgId) {
              message = msg;
              checkFile();
            }
          },
          onError: (msgId, msg, error) {
            if (msgId == message!.msgId) {
              message = msg;
              setState(() {});
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ValueListenableBuilder(
      valueListenable: showLargeImage,
      builder: (context, value, child) {
        return value ? largeImageWidget() : thumbnailImageWidget();
      },
      child: thumbnailImageWidget(),
    );

    content = InteractiveViewer(
      child: content,
    );

    content = Center(child: content);

    content = Stack(
      children: [
        content,
        Positioned(
          left: 5,
          top: 5,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );

    content = SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: content,
    );
    content = Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: content),
    );
    return content;
  }

  void _downloadImage(EMMessage message) {
    chatClient.chatManager.downloadAttachment(message);
  }

  Widget thumbnailImageWidget() {
    Widget? content;
    var file = File(body!.thumbnailLocalPath ?? '');
    if (file.existsSync()) {
      content = Image.file(File(body!.thumbnailLocalPath!));
    } else {
      file = File(body!.localPath);
      if (file.existsSync()) {
        content = Image.file(File(body!.localPath));
      } else {
        if (body?.thumbnailRemotePath != null) {
          content = content = Image.network(body!.thumbnailRemotePath!);
        } else {
          content =
              const Icon(Icons.broken_image, size: 58, color: Colors.white);
        }
      }
    }

    return content;
  }

  Widget largeImageWidget() {
    return Image.file(File(body!.localPath));
  }

  @override
  void dispose() {
    chatClient.chatManager.removeMessageEvent(_msgEventKey);
    super.dispose();
  }
}
