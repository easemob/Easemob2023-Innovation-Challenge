import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';
import 'package:em_chat_uikit_example/custom_video_message/play_video_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'chat_message_list_video_item.dart';

class CustomMessagesPage extends StatefulWidget {
  const CustomMessagesPage(this.conversation, {super.key});

  final EMConversation conversation;

  @override
  State<CustomMessagesPage> createState() => _CustomMessagesPageState();
}

class _CustomMessagesPageState extends State<CustomMessagesPage> {
  late final ChatMessageListController controller;

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
          )
        ],
      ),
      body: SafeArea(
        child: ChatMessagesView(
          messageListViewController: controller,
          conversation: widget.conversation,
          onError: (error) {
            showSnackBar('error: ${error.description}');
          },
          itemBuilder: (context, model) {
            if (model.message.body.type == MessageType.VIDEO) {
              return ChatMessageListVideoItem(
                model: model,
                onPlayTap: playVideo,
              );
            }
            return null;
          },
          onTap: (context, message) {
            bool hold = false;
            switch (message.body.type) {
              case MessageType.COMBINE:
                showSnackBar('combine msg clicked');
                hold = true;
                break;
              case MessageType.FILE:
                showSnackBar('file msg clicked');
                hold = true;
                break;
              case MessageType.LOCATION:
                showSnackBar('location msg clicked');
                hold = true;
                break;
              case MessageType.VIDEO:
                showSnackBar('video msg clicked');
                hold = true;
                break;

              default:
                break;
            }

            return hold;
          },
          inputBarMoreActionsOnTap: (items) {
            return items +
                [
                  ChatBottomSheetItem.normal('Video', onTap: () async {
                    Navigator.of(context).pop();
                    sendVideoMessage();
                  }),
                ];
          },
        ),
      ),
    );
  }

  void sendVideoMessage() async {
    final XFile? video =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final imageData = await VideoThumbnail.thumbnailData(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            200, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 80,
      );
      if (imageData != null) {
        final directory = await getApplicationCacheDirectory();
        String thumbnailPath =
            '${directory.path}/thumbnail_${Random().nextInt(999999999)}.jpeg';
        final file = File(thumbnailPath);
        file.writeAsBytesSync(imageData);

        final videoFile = File(video.path);

        Image.file(file)
            .image
            .resolve(const ImageConfiguration())
            .addListener(ImageStreamListener((info, synchronousCall) {
          final msg = EMMessage.createVideoSendMessage(
            targetId: controller.conversation.id,
            filePath: video.path,
            thumbnailLocalPath: file.path,
            chatType: ChatType.values[controller.conversation.type.index],
            width: info.image.width.toDouble(),
            height: info.image.height.toDouble(),
            fileSize: videoFile.sizeInBytes,
          );
          controller.sendMessage(msg);
        }));
      }
    }
  }

  void showSnackBar(String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void playVideo(EMMessage message) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return PlayVideoPage(message);
    }));
  }
}
