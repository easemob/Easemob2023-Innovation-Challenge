import 'package:flutter/material.dart';
import 'package:em_chat_uikit/generated/uikit_localizations.dart';

import '../../tools/chat_image_loader.dart';
import '../chat_uikit.dart';
import 'chat_emoji_data.dart';
import 'chat_emoji_widget.dart';

/// The widget of the message input bar.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.textEditingController,
    required this.focusNode,
    this.recordTouchDown,
    this.recordTouchUpInside,
    this.recordTouchUpOutside,
    this.recordDragInside,
    this.recordDragOutside,
    this.moreAction,
    this.enableEmoji = true,
    this.enableVoice = true,
    this.enableMore = true,
    this.hiddenStr = "Aa",
    this.onTextFieldChanged,
    this.onSendBtnTap,
    this.inputWidgetOnTap,
    this.emojiWidgetOnTap,
  });

  final VoidCallback? inputWidgetOnTap;
  final VoidCallback? emojiWidgetOnTap;
  final VoidCallback? recordTouchDown;
  final VoidCallback? recordTouchUpInside;
  final VoidCallback? recordTouchUpOutside;
  final VoidCallback? recordDragInside;
  final VoidCallback? recordDragOutside;
  final VoidCallback? moreAction;
  final void Function(String text)? onSendBtnTap;
  final void Function(String text)? onTextFieldChanged;

  final bool enableEmoji;
  final bool enableVoice;
  final bool enableMore;
  final String hiddenStr;
  final TextEditingController textEditingController;

  final FocusNode focusNode;
  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  _ChatInputType _currentInputType = _ChatInputType.dismiss;
  _ChatInputType? _lastInputType;

  final GlobalKey _gestureKey = GlobalKey();
  bool _showSendBtn = false;
  _ChatVoiceOffsetType _voiceTouchType = _ChatVoiceOffsetType.noTouch;
  @override
  void initState() {
    super.initState();

    widget.textEditingController.addListener(_adjustSendBtn);

    widget.focusNode.addListener(() {
      if (widget.focusNode.hasFocus) {
        _updateCurrentInputType(_ChatInputType.text);
      } else {
        if (_currentInputType == _ChatInputType.text) {
          _updateCurrentInputType(_ChatInputType.dismiss);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _adjustSendBtn() {
    if (widget.textEditingController.text.isEmpty) {
      if (_showSendBtn) {
        setState(() => _showSendBtn = false);
      }
    } else {
      if (!_showSendBtn) {
        setState(() => _showSendBtn = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 3, 6, 4),
                child: Offstage(
                  offstage: !widget.enableVoice,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          child: _currentInputType == _ChatInputType.voice
                              ? ChatImageLoader.loadImage(
                                  "input_bar_btn_selected.png",
                                  width: 36,
                                  height: 36)
                              : ChatImageLoader.loadImage(
                                  "input_bar_speaker.png",
                                  width: 36,
                                  height: 36),
                          onTap: () {
                            _updateCurrentInputType(_ChatInputType.voice);
                          }),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: _currentInputType != _ChatInputType.voice
                    ? _inputWidget()
                    : _voiceWidget(),
              ),
              () {
                String? name = AppLocalizations.of(context)?.localeName;
                final vPadding = name == "zh" ? 8.0 : 10.0;
                return _currentInputType != _ChatInputType.voice
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(10, 3, 4, 2.5),
                        child: Offstage(
                          offstage: !widget.enableMore,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _showSendBtn
                                  ? InkWell(
                                      key: const ValueKey("1"),
                                      onTap: () {
                                        widget.onSendBtnTap?.call(widget
                                            .textEditingController.text
                                            .trim());
                                        widget.textEditingController.text = "";
                                      },
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(
                                            8, vPadding, 8, vPadding),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: ChatUIKit.of(context)
                                                  ?.theme
                                                  .inputWidgetSendBtnColor ??
                                              Colors.blue,
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)
                                                    ?.uikitSend ??
                                                "Send",
                                            style: ChatUIKit.of(context)
                                                    ?.theme
                                                    .inputWidgetSendBtnStyle ??
                                                const TextStyle(
                                                    color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        widget.focusNode.unfocus();
                                        widget.moreAction?.call();
                                        _updateCurrentInputType(
                                            _ChatInputType.dismiss);
                                      },
                                      child: _currentInputType !=
                                              _ChatInputType.more
                                          ? ChatImageLoader.loadImage(
                                              "input_bar_more.png",
                                              width: 36,
                                              height: 36,
                                            )
                                          : ChatImageLoader.loadImage(
                                              "input_bar_btn_selected.png",
                                              width: 35,
                                              height: 35,
                                            ),
                                    ),
                            ],
                          ),
                        ),
                      )
                    : Container();
              }(),
            ],
          ),
        ),
        _faceWidget(),
      ],
    );
  }

  void _updateCurrentInputType(_ChatInputType type) {
    if (type == _currentInputType && _lastInputType != null) {
      if (_currentInputType == _lastInputType!) {
        _currentInputType = _ChatInputType.text;
      } else {
        _currentInputType = _ChatInputType.text;
      }
      _lastInputType = null;
    } else {
      _lastInputType = _currentInputType;
      _currentInputType = type;
    }
    setState(() {});
  }

  Widget _inputWidget() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 150, minHeight: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                widget.onTextFieldChanged?.call(value);
              },
              onTap: () {
                widget.inputWidgetOnTap?.call();
              },
              focusNode: widget.focusNode,
              controller: widget.textEditingController,
              maxLines: null,
              decoration: InputDecoration(
                prefixText: " ",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                isCollapsed: true,
                labelStyle: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontWeight: FontWeight.w400),
                hintText: widget.hiddenStr,
                hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(191, 191, 191, 1),
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 3, 4, 4),
            child: Offstage(
              offstage: !widget.enableEmoji,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      widget.emojiWidgetOnTap?.call();
                      _updateCurrentInputType(_ChatInputType.emoji);
                    },
                    child: _currentInputType == _ChatInputType.emoji
                        ? ChatImageLoader.loadImage(
                            "input_bar_btn_selected.png",
                            width: 34,
                            height: 34,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(2),
                            child: ChatImageLoader.loadImage(
                              "input_bar_emoji.png",
                              width: 29,
                              height: 29,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _voiceWidget() {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: _voiceTouchType == _ChatVoiceOffsetType.noTouch
              ? const Color.fromARGB(255, 230, 230, 230)
              : Colors.red,
        ),
        height: 42,
        key: _gestureKey,
        child: Center(
          child: Text(
            () {
              switch (_voiceTouchType) {
                case _ChatVoiceOffsetType.noTouch:
                  return AppLocalizations.of(context)?.holdToTalk ??
                      "Hold to Talk";
                case _ChatVoiceOffsetType.dragInside:
                  return AppLocalizations.of(context)?.releaseToSend ??
                      "Release to Send";
                case _ChatVoiceOffsetType.dragOutside:
                  return AppLocalizations.of(context)?.releaseToCancel ??
                      "Release to Cancel";
              }
            }(),
            style: TextStyle(
                color: _voiceTouchType == _ChatVoiceOffsetType.noTouch
                    ? const Color.fromRGBO(165, 167, 166, 1)
                    : Colors.white,
                fontWeight: _voiceTouchType == _ChatVoiceOffsetType.noTouch
                    ? FontWeight.w400
                    : FontWeight.w500,
                fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _faceWidget() {
    return AnimatedContainer(
      onEnd: () {},
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 250),
      height: _currentInputType == _ChatInputType.emoji ? 200 : 0,
      child: Stack(
        children: [
          Positioned(
            child: ChatEmojiWidget(
              emojiClicked: (emoji) {
                TextEditingValue value = widget.textEditingController.value;
                int current = value.selection.baseOffset;
                if (current < 0) current = 0;
                if (current > value.text.length) current = value.text.length;
                String text = value.text;
                text = text.substring(0, current) +
                    emoji +
                    text.substring(current);
                widget.textEditingController.value = value.copyWith(
                  text: text,
                  selection: TextSelection.fromPosition(
                    TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: current + 2,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: InkWell(
              onTap: () {
                TextEditingValue value = widget.textEditingController.value;
                int current = value.selection.baseOffset;
                String mStr = "";
                int offset = 0;
                do {
                  if (current == 0) {
                    return;
                  }
                  if (current == 1) {
                    mStr = value.text.substring(1);
                    break;
                  }

                  if (current >= 2) {
                    String subText = value.text.substring(current - 2, current);
                    if (ChatEmojiData.emojiList.contains(subText)) {
                      mStr = value.text.substring(0, current - 2) +
                          value.text.substring(current);
                      offset = current - 2;
                      break;
                    } else {
                      mStr = value.text.substring(0, current - 1) +
                          value.text.substring(current);
                      offset = current - 1;
                      break;
                    }
                  }
                } while (false);
                widget.textEditingController.value = value.copyWith(
                  text: mStr,
                  selection: TextSelection.fromPosition(
                    TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: offset,
                    ),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(17, 78, 255, 1),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  weight: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onPointerDown(PointerDownEvent event) {
    setState(() => _voiceTouchType = _ChatVoiceOffsetType.dragInside);
    widget.recordTouchDown?.call();
  }

  _onPointerMove(PointerMoveEvent event) {
    RenderBox renderBox =
        _gestureKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = event.localPosition;
    bool outside = false;
    if (offset.dx < 0 || offset.dy < 0) {
      outside = true;
    } else if (renderBox.size.width - offset.dx < 0 ||
        renderBox.size.height - offset.dy < 0) {
      outside = true;
    }
    _ChatVoiceOffsetType type = _ChatVoiceOffsetType.noTouch;
    if (!outside) {
      type = _ChatVoiceOffsetType.dragInside;
      widget.recordDragInside?.call();
    } else {
      type = _ChatVoiceOffsetType.dragOutside;
      widget.recordDragOutside?.call();
    }
    if (_voiceTouchType != type) {
      setState(() => _voiceTouchType = type);
    }
  }

  _onPointerUp(PointerUpEvent event) {
    RenderBox renderBox =
        _gestureKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = event.localPosition;
    bool outside = false;
    if (offset.dx < 0 || offset.dy < 0) {
      outside = true;
    } else if (renderBox.size.width - offset.dx < 0 ||
        renderBox.size.height - offset.dy < 0) {
      outside = true;
    }

    setState(() => _voiceTouchType = _ChatVoiceOffsetType.noTouch);

    if (!outside) {
      widget.recordTouchUpInside?.call();
    } else {
      widget.recordTouchUpOutside?.call();
    }
  }
}

enum _ChatInputType { dismiss, text, voice, emoji, more }

enum _ChatVoiceOffsetType { noTouch, dragInside, dragOutside }
