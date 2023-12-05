import 'package:flutter/material.dart';
import 'package:em_chat_uikit/internal/chat_method.dart';

import '../../em_chat_uikit.dart';

/// The message list widget controller.
///
/// You can use this controller to send messages, delete messages, and more.
/// You can send messages by calling the [sendMessage] method.
/// delete messages by calling the [removeMessage] method.
/// recall messages by calling the [recallMessage] method.
/// load more messages by calling the [loadMoreMessage] method.
/// [markAllMessagesAsRead] method to mark all messages as read.
/// [deleteAllMessages] method to delete all messages.
/// [sendReadAck] method to send read ack.
/// [refreshUI] method to refresh UI.
class ChatMessageListController extends ChatBaseController {
  /// Param [conversation] The conversation to display.
  ///
  /// Param [enableReadAck] Enable the read receipt. The read receipt supports only single-chat messages.
  ///
  /// Param [didRecallMessage] The message recall callback, executed when the message is recalled,
  ///
  ChatMessageListController(
    this.conversation, {
    this.enableReadAck = true,
    this.didRecallMessage,
    super.key,
  });

  /// The message recall callback, executed when the message is recalled,
  /// You can return a message that the sdk inserts into the local database.
  final ChatReplaceMessage? didRecallMessage;

  /// Enable the read receipt. The read receipt supports only single-chat messages.
  /// After text messages are displayed, the system automatically sends the read receipt to the message sender.
  /// Other types of messages require a separate call to the [ChatMessageListController.sendReadAck] method, which is invalidated if turned off.
  final bool enableReadAck;
  final List<ChatMessageListItemModel> msgList = [];

  void updateMsgList(List<ChatMessageListItemModel> list) {
    msgList.addAll(list);
  }

  Future<void> Function(bool moveToEnd)? _reloadData;
  void Function(EMError error)? _onError;

  EMMessage? _playingMessage;
  int _latestShowTsTime = -1;
  final EMConversation conversation;
  bool _hasMore = true;
  bool _loading = false;
  bool hasFirstLoad = false;

  /// Send a message.
  ///
  /// Param [message] The message to send.
  void sendMessage(EMMessage message) async {
    _removeMessageFromList(message);
    try {
      EMMessage msg = await chatClient.chatManager.sendMessage(message);
      msgList.insert(0, _modelCreator(msg));
      await refreshUI(moveToEnd: true);
    } on EMError catch (e) {
      _onError?.call(e);
    }
  }

  /// Remove a message.
  ///
  /// Param [message] The message to remove.
  Future<void> removeMessage(EMMessage message) async {
    try {
      await conversation.deleteMessage(message.msgId);
      if (_removeMessageFromList(message)) {
        refreshUI();
      }
    } on EMError catch (e) {
      _onError?.call(e);
    }
  }

  /// Recall a message.
  ///
  /// Param [message] The message to recall.
  Future<void> recallMessage(
    EMMessage message,
  ) async {
    try {
      await chatClient.chatManager.recallMessage(message.msgId);
      _recallMessagesCallback([message]);
    } on EMError catch (e) {
      _onError?.call(e);
    }
  }

  /// load messages and refresh list.
  ///
  /// Param [count] load count.
  Future<void> loadMoreMessage([int count = 10]) async {
    if (_loading) return;
    _loading = true;
    if (!_hasMore) {
      _loading = false;
      return;
    }

    List<EMMessage> list = await conversation.loadMessages(
      startMsgId: msgList.isEmpty ? "" : msgList.last.msgId,
      loadCount: count,
    );
    if (list.length < count) {
      _hasMore = false;
    }

    List<ChatMessageListItemModel> models = _modelsCreator(list, _hasMore);

    msgList.addAll(models);
    _loading = false;
    refreshUI();
  }

  /// mark all messages in the current conversation to read. current conversation see [ChatMessagesList].
  Future<void> markAllMessagesAsRead() async {
    try {
      await chatClient.chatManager.sendConversationReadAck(conversation.id);
      // ignore: empty_catches
    } catch (e) {}
    return conversation.markAllMessagesAsRead();
  }

  /// mark a message in the current conversation to read.
  /// affects only unread messages count in the conversation.
  ///
  /// Param [message] The message needs to be set to read. current conversation see [ChatMessagesList].
  Future<void> markMessageAsRead(EMMessage message) async {
    if (message.direction == MessageDirection.RECEIVE) {
      await conversation.markMessageAsRead(message.msgId);
    }
  }

  /// Send a message read receipt, the other party will receive a read receipt.
  /// only single-chat messages. Does not take effect when the [ChatMessageListController.enableReadAck] is false.
  ///
  /// Param [message] Param [message] The message to send read ack.
  Future<void> sendReadAck(EMMessage message) async {
    if (enableReadAck &&
        !message.hasReadAck &&
        message.direction == MessageDirection.RECEIVE &&
        conversation.type == EMConversationType.Chat) {
      try {
        await chatClient.chatManager.sendMessageReadAck(message);
      } on EMError catch (e) {
        _onError?.call(e);
      }
    }
  }

  /// Insert a message to the current conversation. If the message does not belong to the current conversation, it cannot be inserted.
  /// If the timestamp of the inserted Message is within the range of the message timestamp already displayed,
  /// it will be displayed in current [ChatMessagesList].
  Future<void> insertMessage(EMMessage message) async {
    if (message.conversationId == conversation.id) {
      try {
        await conversation.insertMessage(message);
        List models = msgList
            .getRange(
              msgList.indexWhere(
                  (element) => element.message.serverTime > message.serverTime),
              msgList.indexWhere(
                  (element) => element.message.serverTime < message.serverTime),
            )
            .toList();
        if (models.isNotEmpty) {
          int index = msgList.indexWhere(
              (element) => element.message.serverTime > message.serverTime);
          ChatMessageListItemModel model = _modelCreator(message);
          msgList.insert(index + 1, model);
          _hasMore = false;
          refreshUI();
        }

        // ignore: empty_catches
      } catch (e) {}
    }
  }

  /// Deletes all messages in the current conversation. Only the local database is deleted.
  /// If the message roaming interface is called, the deleted message can still be retrieved.
  /// current conversation see [ChatMessagesList]. message roaming see [ChatManager.fetchHistoryMessages].
  Future<void> deleteAllMessages() async {
    await chatClient.chatManager.deleteConversation(conversation.id);
    _latestShowTsTime = -1;
    msgList.clear();
    refreshUI();
  }

  /// Refresh ChatMessagesList Widget. see [ChatMessagesList].
  Future<void>? refreshUI({
    bool moveToEnd = false,
  }) {
    return _reloadData?.call(moveToEnd);
  }

  void play(EMMessage message) {
    _playingMessage = message;
  }

  void stopPlay() {
    _playingMessage = null;
  }

  void _replaceMessage(EMMessage fromMessage, EMMessage toMessage) {
    int index = -1;
    do {
      index =
          msgList.indexWhere((element) => fromMessage.msgId == element.msgId);
      if (index >= 0) {
        ChatMessageListItemModel model = msgList[index].copyWithMsg(toMessage);
        msgList[index] = model;
        break;
      }
    } while (false);
  }

  bool _removeMessageFromList(EMMessage message) {
    int index = -1;
    do {
      index = msgList.indexWhere((element) => message.msgId == element.msgId);
      if (index >= 0) {
        _removeListWithIndex(msgList, index);
        break;
      }
    } while (false);
    return index >= 0;
  }

  void _removeListWithIndex(List<ChatMessageListItemModel> list, int index) {
    ChatMessageListItemModel model = list.removeAt(index);
    if (index == 0) {
      if (list.isNotEmpty) {
        _latestShowTsTime = list.first.message.serverTime;
      } else {
        _latestShowTsTime = -1;
      }
    } else {
      if (model.needTime && list.isNotEmpty) {
        list[index - 1] = list[index - 1].copyWithNeedTime(true);
      }
    }
  }

  void _handleMessage(String msgId, EMMessage message) {
    int index = -1;
    do {
      index = msgList.indexWhere((element) => msgId == element.msgId);
      if (index > -1) {
        ChatMessageListItemModel model = msgList[index].copyWithMsg(message);
        msgList[index] = model;
        break;
      }
    } while (false);
    if (index > -1) {
      refreshUI();
    }
  }

  void addChatListener() {
    chatClient.chatManager.addMessageEvent(
        key,
        ChatMessageEvent(
          onProgress: (msgId, progress) {},
          onSuccess: _handleMessage,
          onError: (msgId, msg, error) {
            _handleMessage.call(msgId, msg);
            _onError?.call(error);
          },
        ));
    chatClient.chatManager.addEventHandler(
      key,
      EMChatEventHandler(
        onConversationRead: (from, to) {
          List<ChatMessageListItemModel> tmpList = msgList.map((e) {
            e.message.hasReadAck = true;
            return e;
          }).toList();
          msgList.clear();
          msgList.addAll(tmpList);
          refreshUI();
        },
        onMessagesRead: _updateMessageItems,
        onMessagesReceived: (messages) {
          List<EMMessage> tmp = messages
              .where((element) => element.conversationId == conversation.id)
              .toList();

          msgList.insertAll(0, tmp.map((e) => _modelCreator(e)).toList());
          refreshUI();
        },
        onMessagesRecalled: (messages) {
          _recallMessagesCallback(messages);
        },
      ),
    );
  }

  void _recallMessagesCallback(List<EMMessage> msgs) async {
    bool needReload = false;
    for (var msg in msgs) {
      EMMessage? needInsertMessage = didRecallMessage?.call(msg);
      if (needInsertMessage != null) {
        await conversation.insertMessage(needInsertMessage);
        _replaceMessage(msg, needInsertMessage);
        needReload = true;
      } else {
        if (_removeMessageFromList(msg)) {
          needReload = true;
        }
      }
    }
    if (needReload) {
      refreshUI();
    }
  }

  void _updateMessageItems(List<EMMessage> list) {
    bool hasChange = false;

    for (var message in list) {
      int index = -1;
      do {
        index = msgList.indexWhere((element) => message.msgId == element.msgId);
        if (index > -1) {
          msgList[index] = msgList[index].copyWithMsg(message);
          hasChange = true;
          break;
        }

        hasChange = true;
      } while (false);
    }
    if (hasChange) {
      refreshUI();
    }
  }

  void removeChatListener() {
    chatClient.chatManager.removeEventHandler(key);
    chatClient.chatManager.removeMessageEvent(key);
  }

  List<ChatMessageListItemModel> _modelsCreator(
      List<EMMessage> msgs, bool hasMore) {
    List<ChatMessageListItemModel> list = [];
    for (var i = 0; i < msgs.length; i++) {
      if (!_hasMore && i == 0) {
        _latestShowTsTime = msgs[i].serverTime;
        list.add(ChatMessageListItemModel(msgs[i], true));
      } else {
        list.add(_modelCreator(msgs[i]));
      }
    }
    return list.reversed.toList();
  }

  ChatMessageListItemModel _modelCreator(EMMessage message) {
    bool needShowTs = false;
    if (_latestShowTsTime < 0) {
      needShowTs = true;
    } else if ((message.serverTime - _latestShowTsTime).abs() > 60 * 1000) {
      needShowTs = true;
    }
    if (needShowTs == true && message.serverTime > _latestShowTsTime) {
      _latestShowTsTime = message.serverTime;
    }
    return ChatMessageListItemModel(message, needShowTs);
  }

  void _bindingActions({
    Future<void> Function(bool moveToEnd)? reloadData,
    void Function(EMError error)? onError,
  }) {
    _reloadData = reloadData;
    _onError = onError;
  }

  void dispose() {
    _reloadData = null;
    _onError = null;
    removeChatListener();
  }
}

/// Messages list widget.
///
/// Param [conversation] is required. is the conversations.
///
/// Param [background] is optional. is the background widget.
///
/// Param [messageListViewController] is optional. is the message list controller.
///
/// Param [itemBuilder] is optional. is the message bubble builder.
///
/// Param [onTap] is optional. is the bubble click callback.
///
/// Param [onBubbleLongPress] is optional. is the bubble long press callback.
///
/// Param [onBubbleDoubleTap] is optional. is the bubble double tap callback.
///
/// Param [avatarBuilder] is optional. is the avatar builder.
///
/// Param [nicknameBuilder] is optional. is the nickname builder.
///
/// Param [onError] is optional. is the error callback.
///
/// Param [enableScrollBar] is optional. is the enable scroll bar, default is enable.
///
/// Param [needDismissInputWidgetAction] is optional. is the need dismiss input widget action.
///
class ChatMessagesList extends StatefulWidget {
  const ChatMessagesList({
    super.key,
    required this.conversation,
    this.background,
    required this.messageListViewController,
    this.itemBuilder,
    this.onTap,
    this.onBubbleLongPress,
    this.onBubbleDoubleTap,
    this.avatarBuilder,
    this.nicknameBuilder,
    this.onError,
    this.enableScrollBar = true,
    this.needDismissInputWidgetAction,
  });

  /// Background widget.
  final Widget? background;

  /// Current conversation.
  final EMConversation conversation;

  /// Error callback.
  final void Function(EMError error)? onError;

  /// Message list controller.
  final ChatMessageListController messageListViewController;

  /// Message bubble builder.
  final ChatMessageListItemBuilder? itemBuilder;

  /// Bubble click callback.
  final ChatMessageTapAction? onTap;

  /// Bubble long press callback.
  final ChatMessageTapAction? onBubbleLongPress;

  /// Bubble double-click the callback.
  final ChatMessageTapAction? onBubbleDoubleTap;

  /// Avatar builder.
  final ChatWidgetBuilder? avatarBuilder;

  /// Nickname builder.
  final ChatWidgetBuilder? nicknameBuilder;

  /// Enable scroll bar.
  final bool enableScrollBar;

  /// Dismiss the input widget callback. If you use a customized input widget,
  /// need dismiss the widget when you receive the callback,
  /// for example, by calling [FocusNode.unfocus], see [ChatInputBar].
  final VoidCallback? needDismissInputWidgetAction;

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.messageListViewController.addChatListener();
    widget.messageListViewController.markAllMessagesAsRead();
    widget.messageListViewController
        ._bindingActions(reloadData: _reloadData, onError: _onError);
    widget.messageListViewController.loadMoreMessage();
    _scrollController.addListener(scrollListener);
  }

  void _onError(EMError err) {
    widget.onError?.call(err);
  }

  Future<void> _reloadData(bool moveToEnd) async {
    setState(() {});
    if (moveToEnd) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.messageListViewController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatMessagesList oldWidget) {
    if (widget.messageListViewController !=
        oldWidget.messageListViewController) {
      oldWidget.messageListViewController.dispose();
      widget.messageListViewController
          .updateMsgList(oldWidget.messageListViewController.msgList);
      widget.messageListViewController
          ._bindingActions(reloadData: _reloadData, onError: _onError);
      widget.messageListViewController.addChatListener();
    }
    super.didUpdateWidget(oldWidget);
  }

  void scrollListener() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.offset) {
      widget.messageListViewController.loadMoreMessage();
    }
    widget.needDismissInputWidgetAction?.call();
  }

  @override
  Widget build(BuildContext context) {
    List<ChatMessageListItemModel> list =
        widget.messageListViewController.msgList;

    Widget content = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      cacheExtent: 1500,
      reverse: true,
      slivers: [
        ChatMessageSliver(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return messageWidget(list[index]);
            },
            childCount: list.length,
          ),
        ),
      ],
    );

    if (widget.enableScrollBar) {
      content = Scrollbar(
        controller: _scrollController,
        child: content,
      );
    }

    content = ScrollConfiguration(
      behavior: ChatScrollBehavior(),
      child: content,
    );

    content = Stack(
      children: [
        widget.background ?? Container(),
        content,
      ],
    );

    content = WillPopScope(
      onWillPop: () async {
        widget.conversation.markAllMessagesAsRead();
        ChatUIKit.of(context)?.conversationsController?.loadAllConversations();
        return true;
      },
      child: content,
    );

    return content;
  }

  Widget messageWidget(ChatMessageListItemModel model) {
    EMMessage message = model.message;
    widget.messageListViewController.sendReadAck(message);

    ValueKey<String>? valueKey; //ValueKey(message.msgId);

    Widget content = widget.itemBuilder?.call(context, model) ??
        () {
          if (message.body.type == MessageType.TXT) {
            return ChatMessageListTextItem(
              key: valueKey,
              model: model,
              onTap: widget.onTap,
              avatarBuilder: widget.avatarBuilder,
              nicknameBuilder: widget.nicknameBuilder,
              onBubbleDoubleTap: widget.onBubbleDoubleTap,
              onBubbleLongPress: widget.onBubbleLongPress,
              onResendTap: () =>
                  widget.messageListViewController.sendMessage(message),
            );
          } else if (message.body.type == MessageType.IMAGE) {
            return ChatMessageListImageItem(
              bubblePadding: EdgeInsets.zero,
              bubbleColor: Colors.transparent,
              key: valueKey,
              model: model,
              onTap: widget.onTap,
              avatarBuilder: widget.avatarBuilder,
              nicknameBuilder: widget.nicknameBuilder,
              onBubbleDoubleTap: widget.onBubbleDoubleTap,
              onBubbleLongPress: widget.onBubbleLongPress,
              onResendTap: () =>
                  widget.messageListViewController.sendMessage(message),
            );
          } else if (message.body.type == MessageType.FILE) {
            return ChatMessageListFileItem(
              bubbleColor: const Color.fromRGBO(242, 242, 242, 1),
              key: valueKey,
              model: model,
              onTap: widget.onTap,
              avatarBuilder: widget.avatarBuilder,
              nicknameBuilder: widget.nicknameBuilder,
              onBubbleDoubleTap: widget.onBubbleDoubleTap,
              onBubbleLongPress: widget.onBubbleLongPress,
              onResendTap: () =>
                  widget.messageListViewController.sendMessage(message),
            );
          } else if (message.body.type == MessageType.VOICE) {
            return ChatMessageListVoiceItem(
              key: valueKey,
              model: model,
              onTap: widget.onTap,
              avatarBuilder: widget.avatarBuilder,
              nicknameBuilder: widget.nicknameBuilder,
              onBubbleDoubleTap: widget.onBubbleDoubleTap,
              onBubbleLongPress: widget.onBubbleLongPress,
              onResendTap: () =>
                  widget.messageListViewController.sendMessage(message),
              isPlay: widget.messageListViewController._playingMessage?.msgId ==
                  message.msgId,
              unreadFlagBuilder: message.hasRead
                  ? null
                  : (_) => Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink),
                      width: 10,
                      height: 10),
            );
          }
          return Container();
        }();

    return content;
  }
}
