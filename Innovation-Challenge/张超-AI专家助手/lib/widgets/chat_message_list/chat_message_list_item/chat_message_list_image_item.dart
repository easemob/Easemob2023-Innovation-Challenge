import 'dart:io';

import 'package:flutter/material.dart';
import 'package:em_chat_uikit/tools/icon_image_provider.dart';

import '../../../em_chat_uikit.dart';

class ChatMessageListImageItem extends ChatMessageListItem {
  const ChatMessageListImageItem({
    super.key,
    required super.model,
    super.onTap,
    super.onBubbleLongPress,
    super.onBubbleDoubleTap,
    super.onResendTap,
    super.avatarBuilder,
    super.nicknameBuilder,
    super.bubbleColor,
    super.bubblePadding,
    super.unreadFlagBuilder,
  });

  @override
  Widget build(BuildContext context) {
    EMMessage message = model.message;
    EMImageMessageBody body = message.body as EMImageMessageBody;

    double max = getMaxWidth(context);
    double width = body.width ?? max;
    double height = body.height ?? max;

    double ratio = width / height;
    if (ratio <= 0.5 || ratio >= 2) {
      max = max / 3 * 4;
    }
    if (width > height) {
      height = max / width * height;
      width = max;
    } else {
      width = max / height * width;
      height = max;
    }

    Widget content;

    do {
      File file = File(body.localPath);
      if (file.existsSync()) {
        content = Image(
          gaplessPlayback: true,
          image: ResizeImage(
            FileImage(file),
            width: width.toInt(),
            height: height.toInt(),
          ),
          fit: BoxFit.fill,
        );
        break;
      }
      if (body.thumbnailLocalPath != null) {
        File thumbnailFile = File(body.thumbnailLocalPath!);
        if (thumbnailFile.existsSync()) {
          content = Image(
            gaplessPlayback: true,
            image: ResizeImage(
              FileImage(thumbnailFile),
              width: width.toInt(),
              height: height.toInt(),
            ),
            fit: BoxFit.fill,
          );
          break;
        }
      }
      if (body.thumbnailRemotePath != null) {
        content = Container(
          color: const Color.fromRGBO(242, 242, 242, 1),
          child: FadeInImage(
            placeholderFit: BoxFit.contain,
            placeholder: IconImageProvider(Icons.image),
            image: NetworkImage(body.thumbnailRemotePath!),
            imageErrorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 48);
            },
            fit: BoxFit.fill,
          ),
        );
        break;
      }
      content = const Icon(Icons.broken_image, size: 58, color: Colors.white);
    } while (false);

    content = SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: content,
      ),
    );

    return getBubbleWidget(content);
  }
}
