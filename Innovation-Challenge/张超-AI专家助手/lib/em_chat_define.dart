import 'package:flutter/material.dart';

import 'em_chat_uikit.dart';

typedef ChatWidgetBuilder = Widget Function(
    BuildContext context, String userId);

typedef ChatConversationWidgetBuilder = Widget? Function(
  BuildContext context,
  EMConversation conversation,
);

typedef ChatConversationTextBuilder = String? Function(
  EMConversation conversation,
);

typedef ChatMessageListItemBuilder = Widget? Function(
    BuildContext context, ChatMessageListItemModel model);

typedef ChatMessageTapAction = bool Function(
    BuildContext context, EMMessage message);

typedef ChatConfirmDismissCallback = Future<bool> Function(
    BuildContext context);

typedef ChatConversationItemWidgetBuilder = Widget? Function(
    BuildContext context, int index, EMConversation conversation);

typedef ChatConversationSortHandle = Future<List<EMConversation>> Function(
    List<EMConversation> beforeList);

typedef ChatPermissionRequest = Future<bool> Function(
    ChatUIKitPermission permission);

typedef ChatReplaceMessage = EMMessage? Function(EMMessage message);

typedef ChatReplaceMoreActions = List<ChatBottomSheetItem> Function(
    List<ChatBottomSheetItem> items);
