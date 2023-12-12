import 'dart:io';

import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';
import 'package:em_chat_uikit/tools/icon_image_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatMessageListVideoItem extends ChatMessageListItem {
  const ChatMessageListVideoItem({
    required super.model,
    this.onPlayTap,
    super.key,
    super.bubbleColor = Colors.transparent,
    super.bubblePadding = EdgeInsets.zero,
  });

  final void Function(EMMessage msg)? onPlayTap;

  @override
  Widget build(BuildContext context) {
    EMMessage message = model.message;
    EMVideoMessageBody body = message.body as EMVideoMessageBody;

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
      File localFile = File(body.localPath);
      if (localFile.existsSync()) {
        content = FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Image.memory(
                snapshot.data!,
                gaplessPlayback: true,
                width: width.isNaN ? max.toDouble() : width.toDouble(),
                height: height.isNaN ? max.toDouble() : height.toDouble(),
                fit: BoxFit.fill,
              );
            } else {
              return const Icon(Icons.image, size: 58, color: Colors.white);
            }
          },
          future: VideoThumbnail.thumbnailData(
            video: body.localPath,
            imageFormat: ImageFormat.JPEG,
            maxWidth: 128,
            quality: 25,
          ),
        );
        break;
      } else if (body.thumbnailRemotePath != null) {
        content = Container(
          color: const Color.fromRGBO(242, 242, 242, 1),
          child: FadeInImage(
            width: width.isNaN ? max : width,
            height: height.isNaN ? max : height,
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
      width: width.isNaN ? max : width,
      height: height.isNaN ? max : height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: content,
      ),
    );

    content = Stack(
      children: [
        content,
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Center(
            child: InkWell(
              onTap: () {
                onPlayTap?.call(message);
              },
              child: const Icon(
                Icons.play_circle_outline,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );

    return getBubbleWidget(content);
  }
}
