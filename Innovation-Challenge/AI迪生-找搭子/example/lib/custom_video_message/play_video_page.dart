import 'dart:io';

import 'package:flutter/material.dart';
import 'package:em_chat_uikit/em_chat_uikit.dart';
import 'package:video_player/video_player.dart';

class PlayVideoPage extends StatefulWidget {
  const PlayVideoPage(this.message, {super.key});
  final EMMessage message;
  @override
  State<PlayVideoPage> createState() => _PlayVideoPageState();
}

enum CustomDownloadStatus {
  downloading,
  success,
  failed,
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  final ValueNotifier<int> _progress = ValueNotifier(0);

  final String _msgEventKey = "VideoDownLoadEventKey";
  EMVideoMessageBody? body;
  EMMessage? message;
  final ValueNotifier<CustomDownloadStatus> _downloadStatus =
      ValueNotifier(CustomDownloadStatus.downloading);

  VideoPlayerController? _controller;

  bool isPlaying = false;
  bool hasLocalFile = false;

  @override
  void initState() {
    super.initState();
    message = widget.message;

    checkFile();
  }

  void checkFile() {
    body = message!.body as EMVideoMessageBody;
    File file = File(body!.localPath);
    if (!file.existsSync()) {
      EMClient.getInstance.chatManager.addMessageEvent(
        _msgEventKey,
        ChatMessageEvent(
          onProgress: (msgId, progress) {
            if (msgId == message!.msgId) {
              _progress.value = progress;
              _downloadStatus.value = CustomDownloadStatus.downloading;
            }
          },
          onSuccess: (msgId, msg) async {
            if (msgId == message!.msgId) {
              message = msg;
              body = message!.body as EMVideoMessageBody;
              if (body!.fileStatus == DownloadStatus.SUCCESS) {
                final file = File(body!.localPath);
                _controller = VideoPlayerController.file(file);

                checkFile();
              }
            }
          },
          onError: (msgId, msg, error) {
            if (msgId == message!.msgId) {
              message = msg;
              _downloadStatus.value = CustomDownloadStatus.failed;
              setState(() {});
            }
          },
        ),
      );
      _downloadVideo(message!);
    } else {
      _downloadStatus.value = CustomDownloadStatus.success;
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          _controller?.play();

          setState(() {
            isPlaying = true;
          });
        });
      _controller?.addListener(() {
        if (_controller?.value.isCompleted == true) {
          setState(() {
            isPlaying = false;
          });
        } else {
          setState(() {
            isPlaying = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ValueListenableBuilder(
      valueListenable: _downloadStatus,
      builder: (context, value, child) {
        if (value == CustomDownloadStatus.success) {
          return _playWidget();
        } else if (value == CustomDownloadStatus.failed) {
          return _errorWidget();
        } else {
          return _loadingWidget();
        }
      },
      child: _loadingWidget(),
    );

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

    content = Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: content),
    );

    return content;
  }

  Widget _loadingWidget() {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: ValueListenableBuilder(
          valueListenable: _progress,
          builder: (context, value, child) {
            return CircularProgressIndicator(
              value: value / 100,
            );
          },
        ),
      ),
    );
  }

  Widget _errorWidget() {
    return Container();
  }

  Widget _playWidget() {
    return Center(
      child: Stack(
        children: [
          () {
            if (_controller?.value.isInitialized == true) {
              return AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!));
            } else {
              return Container();
            }
          }(),
          Positioned.fill(
            child: InkWell(
              onTap: () {
                setState(() {
                  if (_controller!.value.isPlaying) {
                    _controller?.pause();
                    isPlaying = false;
                  } else {
                    _controller?.play();
                    isPlaying = true;
                  }
                });
              },
              child: isPlaying
                  ? Container()
                  : const Icon(
                      Icons.play_circle_outline,
                      size: 70,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadVideo(EMMessage message) {
    _downloadStatus.value = CustomDownloadStatus.downloading;
    EMClient.getInstance.chatManager.downloadAttachment(message);
  }

  @override
  void dispose() {
    _controller?.dispose();
    EMClient.getInstance.chatManager.removeMessageEvent(_msgEventKey);
    super.dispose();
  }
}
