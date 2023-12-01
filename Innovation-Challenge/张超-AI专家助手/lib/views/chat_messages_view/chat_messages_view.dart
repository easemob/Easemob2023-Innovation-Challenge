import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../em_chat_uikit.dart';
import '../../widgets/chat_image_show_widget/chat_image_show_widget.dart';

/// Message details page
class ChatMessagesView extends StatefulWidget {
  /// Message details page.
  ///
  /// [inputBarTextEditingController] Text input widget text editing controller.
  ///
  /// [background] Background widget.
  ///
  /// [inputBar] Text input component, if not passed by default will use [ChatInputBar].
  ///
  /// [conversation] The conversation corresponding to the message details.
  ///
  /// [onTap] Message Bubble click event callback.
  ///
  /// [onBubbleLongPress] Message bubbles long press the event callback.
  ///
  /// [onBubbleDoubleTap] Message Bubble Double-click the event callback.
  ///
  /// [avatarBuilder] Avatar component builder.
  ///
  /// [nicknameBuilder] Nickname component builder.
  ///
  /// [itemBuilder] Message bubble, if not set, will take the default bubble.
  ///
  /// [moreItems] The more the input component clicks on the list displayed, the default items will be used if not passed in, including copy, delete, and recall.
  ///
  /// [messageListViewController] Message list controller: You are advised not to pass messages. Use the default value. For details, see [ChatMessageListController].
  ///
  /// [willSendMessage] A pre-text message event that needs to return a ChatMessage object. that can be used for pre-text message processing.
  ///
  /// [onError] Error callbacks, such as no current permissions, etc.
  ///
  /// [enableScrollBar] Enable scroll bar. default is true.
  ///
  /// [needDismissInputWidget] Dismiss the input widget callback. If you use a customized inputBar,
  /// dismiss the inputBar when you receive the callback,
  /// for example, by calling [FocusNode.unfocus], see [ChatInputBar].
  ///
  /// [inputBarMoreActionsOnTap] More button click after callback, need to return to the ChatBottomSheetItems list.
  ///
  ChatMessagesView({
    required this.conversation,
    this.inputBarTextEditingController,
    this.background,
    this.inputBar,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.avatarBuilder,
    this.nicknameBuilder,
    this.itemBuilder,
    this.moreItems,
    ChatMessageListController? messageListViewController,
    this.willSendMessage,
    this.onError,
    this.enableScrollBar = true,
    this.needDismissInputWidget,
    this.inputBarMoreActionsOnTap,
    super.key,
  }) : messageListViewController = messageListViewController ??
            ChatMessageListController(conversation);

  final Widget? background;

  /// Text input widget text editing controller.
  final TextEditingController? inputBarTextEditingController;

  /// Text input widget, if not passed by default will use [ChatInputBar].
  final Widget? inputBar;

  /// The session corresponding to the message details.
  final EMConversation conversation;

  /// Message Bubble click event callback.
  final ChatMessageTapAction? onTap;

  /// Message bubbles long press the event callback.
  final ChatMessageTapAction? onBubbleLongPress;

  /// Message Bubble Double-click the event callback.
  final ChatMessageTapAction? onBubbleDoubleTap;

  /// Avatar component builder
  final ChatWidgetBuilder? avatarBuilder;

  /// Nickname component builder
  final ChatWidgetBuilder? nicknameBuilder;

  /// The more the input component clicks on the list displayed,
  /// the default items will be used if not passed in, including copy, delete, and recall.
  final List<ChatBottomSheetItem>? moreItems;

  /// Message bubble, if not set, will take the default bubble.
  final ChatMessageListItemBuilder? itemBuilder;

  /// Message list controller: You are advised not to pass messages. Use the default value.
  /// For details, see [ChatMessageListController].
  final ChatMessageListController messageListViewController;

  /// A pre-text message event that needs to return a ChatMessage object.
  /// that can be used for pre-text message processing.
  final ChatReplaceMessage? willSendMessage;

  /// Error callbacks, such as no current permissions, etc.
  final void Function(EMError error)? onError;

  /// Enable scroll bar.
  final bool enableScrollBar;

  /// Dismiss the input widget callback. If you use a customized inputBar,
  /// dismiss the inputBar when you receive the callback,
  /// for example, by calling [FocusNode.unfocus], see [ChatInputBar].
  final VoidCallback? needDismissInputWidget;

  /// More button click after callback, need to return to the ChatBottomSheetItems list.
  final ChatReplaceMoreActions? inputBarMoreActionsOnTap;

  @override
  State<ChatMessagesView> createState() => _ChatMessagesViewState();
}

class _ChatMessagesViewState extends State<ChatMessagesView> {
  final ImagePicker _picker = ImagePicker();
  final Record _audioRecorder = Record();
  final AudioPlayer _player = AudioPlayer();
  final FocusNode _focusNode = FocusNode();
  int _recordDuration = 0;
  // bool _recordBtnTouchDown = false;
  // bool _dragOutside = false;
  Timer? _timer;
  late TextEditingController _textController;
  EMMessage? _playingMessage;
  @override
  void initState() {
    super.initState();
    _textController =
        widget.inputBarTextEditingController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.inputBarTextEditingController == null) {
      _textController.dispose();
    }
    _audioRecorder.dispose();
    _player.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatMessagesView oldWidget) {
    if (widget != oldWidget) {
      _stopRecord(false);
      _stopVoice();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ChatMessagesList(
            background: widget.background,
            needDismissInputWidgetAction:
                widget.needDismissInputWidget ?? _focusNode.unfocus,
            enableScrollBar: widget.enableScrollBar,
            onError: widget.onError,
            conversation: widget.conversation,
            messageListViewController: widget.messageListViewController,
            avatarBuilder: widget.avatarBuilder,
            nicknameBuilder: widget.nicknameBuilder,
            itemBuilder: widget.itemBuilder,
            onTap: (ctx, msg) {
              bool ret = widget.onTap?.call(ctx, msg) ?? false;
              if (!ret) {
                if (msg.body.type == MessageType.VOICE) {
                  _voiceBubblePressed(msg);
                } else if (msg.body.type == MessageType.IMAGE) {
                  _imageBubblePressed(msg);
                }
              }
              return ret;
            },
            onBubbleDoubleTap: (ctx, msg) {
              _focusNode.unfocus();
              bool ret = widget.onBubbleDoubleTap?.call(ctx, msg) ?? false;
              return ret;
            },
            onBubbleLongPress: (ctx, msg) {
              _focusNode.unfocus();
              bool ret = widget.onBubbleLongPress?.call(ctx, msg) ?? false;
              if (!ret) {
                longPressAction(msg);
              }
              return ret;
            },
          ),
        ),
        widget.inputBar ??
            ChatInputBar(
              textEditingController: _textController,
              focusNode: _focusNode,
              inputWidgetOnTap: () {
                if (!_focusNode.hasFocus) {
                  _focusNode.requestFocus();
                }
                widget.messageListViewController.refreshUI(moveToEnd: true);
              },
              emojiWidgetOnTap: () {
                if (_focusNode.hasFocus) {
                  _focusNode.unfocus();
                }
                widget.messageListViewController.refreshUI(moveToEnd: true);
              },
              recordTouchDown: () async {
                await _startRecord();
              },
              recordTouchUpInside: () async {
                await _stopRecord();
              },
              recordTouchUpOutside: _cancelRecord,
              recordDragInside: _recordDragInside,
              recordDragOutside: _recordDragOutside,
              moreAction: showMoreItems,
              onTextFieldChanged: (text) {},
              onSendBtnTap: (text) {
                var msg = EMMessage.createTxtSendMessage(
                    targetId: widget.conversation.id, content: text);
                msg.attributes = {
                  'expert': true,
                };
                msg.chatType = ChatType.values[widget.conversation.type.index];
                EMMessage? willSend;
                if (widget.willSendMessage != null) {
                  willSend = widget.willSendMessage!.call(msg);
                  if (willSend == null) {
                    return;
                  }
                } else {
                  willSend = msg;
                }

                widget.messageListViewController.sendMessage(willSend);
              },
            )
      ],
    );

    content = Stack(
      children: [
        Positioned.fill(child: content),
        Positioned.fill(child: Center(child: _maskWidget()))
      ],
    );

    content = WillPopScope(
        child: content,
        onWillPop: () async {
          if (_focusNode.hasFocus) {
            _focusNode.unfocus();
          }
          _playingMessage = null;
          await _player.stop();
          await _stopRecord();
          return true;
        });

    return content;
  }

  void longPressAction(EMMessage message) async {
    List<ChatBottomSheetItem> list = [];
    if (message.body.type == MessageType.TXT) {
      list.add(
        ChatBottomSheetItem.normal(
          AppLocalizations.of(context)?.uikitCopy ?? 'Copy',
          onTap: () async {
            EMTextMessageBody body = message.body as EMTextMessageBody;
            Clipboard.setData(ClipboardData(text: body.content));
            return Navigator.of(context).pop();
          },
        ),
      );
    }
    list.add(
      ChatBottomSheetItem.normal(
        AppLocalizations.of(context)?.uikitDelete ?? 'Delete',
        onTap: () async {
          widget.messageListViewController.removeMessage(message);
          return Navigator.of(context).pop();
        },
      ),
    );

    var time = DateTime.now().millisecondsSinceEpoch - message.serverTime;

    if (time < 120 * 1000 && message.direction != MessageDirection.RECEIVE) {
      list.add(
        ChatBottomSheetItem.destructive(
          AppLocalizations.of(context)?.uikitRecall ?? 'Recall',
          onTap: () async {
            widget.messageListViewController.recallMessage(message);
            Navigator.of(context).pop();
          },
        ),
      );
    }

    showChatBottomSheet(context: context, items: list);
  }

  void showMoreItems() {
    List<ChatBottomSheetItem> currentList = widget.moreItems ?? _moreItems();
    if (widget.inputBarMoreActionsOnTap != null) {
      final list = widget.inputBarMoreActionsOnTap!.call(currentList);
      if (list.isNotEmpty) {
        showChatBottomSheet(context: context, items: list);
      }
    } else {
      showChatBottomSheet(
          context: context, items: widget.moreItems ?? _moreItems());
    }
  }

  List<ChatBottomSheetItem> _moreItems() {
    return [
      ChatBottomSheetItem.normal(
          AppLocalizations.of(context)?.uikitCamera ?? 'Camera',
          onTap: () async {
        Navigator.of(context).pop();
        _takePhoto();
      }),
      ChatBottomSheetItem.normal(
          AppLocalizations.of(context)?.uikitAlbum ?? 'Album', onTap: () async {
        Navigator.of(context).pop();
        _openImagePicker();
      }),
      ChatBottomSheetItem.normal(
          AppLocalizations.of(context)?.uikitFiles ?? 'Files', onTap: () async {
        Navigator.of(context).pop();
        _openFilePicker();
      }),
    ];
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile? file = result.files.first;
      _sendFile(file);
    }
  }

  void _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        _sendImage(photo.path);
      }
    } catch (e) {
      widget.onError?.call(ChatUIKitError.toChatError(
          ChatUIKitError.noPermission, "no take photo permission"));
    }
  }

  void _openImagePicker() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _sendImage(image.path);
      }
    } catch (e) {
      widget.onError?.call(ChatUIKitError.toChatError(
          ChatUIKitError.noPermission, "no image library permission"));
    }
  }

  void _sendFile(PlatformFile? file) async {
    if (file != null) {
      EMMessage fileMsg = EMMessage.createFileSendMessage(
        targetId: widget.conversation.id,
        filePath: file.path!,
        fileSize: file.size,
        displayName: file.name,
      );
      fileMsg.chatType = ChatType.values[widget.conversation.type.index];
      widget.messageListViewController
          .sendMessage(widget.willSendMessage?.call(fileMsg) ?? fileMsg);
    }
  }

  void _sendImage(String path) async {
    if (path.isEmpty) {
      return;
    }

    bool hasSize = false;
    File file = File(path);
    Image.file(file)
        .image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, synchronousCall) {
      if (!hasSize) {
        hasSize = true;
        EMMessage msg = EMMessage.createImageSendMessage(
          targetId: widget.conversation.id,
          filePath: path,
          width: info.image.width.toDouble(),
          height: info.image.height.toDouble(),
          fileSize: file.sizeInBytes,
        );
        widget.messageListViewController
            .sendMessage(widget.willSendMessage?.call(msg) ?? msg);
      }
    }));
  }

  Future<void> _sendVoice(String path) async {
    String displayName = path.split("/").last;

    EMMessage msg = EMMessage.createVoiceSendMessage(
      targetId: widget.conversation.id,
      filePath: path,
      duration: _recordDuration,
      displayName: displayName,
    );
    widget.messageListViewController
        .sendMessage(widget.willSendMessage?.call(msg) ?? msg);
  }

  Future<void> _voiceBubblePressed(EMMessage message) async {
    await widget.conversation.markMessageAsRead(message.msgId);
    message.hasRead = true;
    if (_playingMessage?.msgId == message.msgId) {
      await _stopVoice();
    } else {
      await _playVoice(message);
    }
  }

  Future<void> _imageBubblePressed(EMMessage message) async {
    await widget.conversation.markMessageAsRead(message.msgId);
    message.hasRead = true;
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return ChatImageShowWidget(message);
    }));
    return Future.value();
  }

  Future<void> _playVoice(EMMessage message) async {
    _playingMessage = message;
    widget.messageListViewController.play(message);
    widget.messageListViewController.refreshUI();
    EMVoiceMessageBody body = message.body as EMVoiceMessageBody;
    await _player.stop();
    await _player
        .play(DeviceFileSource(body.localPath))
        .onError((error, stackTrace) => {});
    _player.onPlayerComplete.first.whenComplete(() {
      if (_playingMessage != null) {
        _stopVoice();
      }
    }).onError((error, stackTrace) {});
  }

  Future<void> _stopVoice() async {
    _playingMessage = null;
    await _player.stop();
    widget.messageListViewController.stopPlay();
    widget.messageListViewController.refreshUI();
  }

  Future<void> _startRecord() async {
    // setState(() {
    //   _recordBtnTouchDown = true;
    // });
    bool isRequest = false;
    Future(() async {
      return await _audioRecorder.hasPermission();
    }).timeout(const Duration(milliseconds: 500), onTimeout: () {
      isRequest = true;
      return false;
    }).then((value) async {
      if (value == true) {
        _startTimer();
        await _audioRecorder.start();
      } else {
        if (!isRequest) {
          widget.onError?.call(ChatUIKitError.toChatError(
              ChatUIKitError.noPermission, 'no record permission'));
        } else {}
      }
    });
  }

  Future<void> _stopRecord([bool send = true]) async {
    if (send == false) {
      _cancelRecord();
      return;
    }
    if (!await _audioRecorder.isRecording()) {
      return;
    }
    _endTimer();
    // setState(() {
    //   _recordBtnTouchDown = false;
    // });
    String? path = await _audioRecorder.stop();

    bool isExists = false;
    if (path != null) {
      if (Platform.isIOS) {
        if (path.startsWith("file:///")) {
          path = path.substring(8);
        }
      }
      final file = File(path);
      isExists = file.existsSync();
      if (isExists) {
        if (_recordDuration < 1) {
          widget.onError?.call(ChatUIKitError.toChatError(
              ChatUIKitError.recordTimeTooShort, "record time too short"));
          await file.delete();
          return;
        }
        await _sendVoice(path);
        return;
      }
    }
    bool permission = await _audioRecorder.hasPermission();
    if (permission) {
      widget.onError?.call(ChatUIKitError.toChatError(
          ChatUIKitError.recordError, 'record error'));
    } else {
      widget.onError?.call(ChatUIKitError.toChatError(
          ChatUIKitError.noPermission, 'no record permission'));
    }
  }

  void _cancelRecord() async {
    String? path = await _audioRecorder.stop();
    if (path != null) {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    }

    // setState(() {
    //   _recordBtnTouchDown = false;
    // });

    _endTimer();
  }

  void _recordDragInside() {
    // setState(() {
    //   _dragOutside = false;
    // });
  }

  void _recordDragOutside() {
    // setState(() {
    //   _dragOutside = true;
    // });
  }

  void _startTimer() {
    _recordDuration = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _recordDuration++;
    });
  }

  void _endTimer() {
    _timer?.cancel();
  }

  Widget? _maskWidget() {
    // if (_recordBtnTouchDown) {
    //   getAmplitude();
    //   return Container(
    //     width: 400,
    //     height: 400,
    //     color: _dragOutside ? Colors.red : Colors.blue,
    //   );
    // } else {
    //   return null;
    // }
    return null;
  }

  // Future<void> getAmplitude() async {
  //   Future.doWhile(() {
  //     return fetchA();
  //   });
  // }

  // Future<bool> fetchA() async {
  //   final amplitude = await _audioRecorder.getAmplitude();
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   debugPrint(
  //       "amplitude:${amplitude.current}, max:${amplitude.max}, dL:${amplitude.current / amplitude.max}");
  //   return _recordBtnTouchDown;
  // }
}
