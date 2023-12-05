import 'package:flutter/material.dart';

/// Chat UIKit Theme
class ChatUIKitTheme {
  /// Param [badgeColor] is the color of the badge.
  ///
  /// Param [badgeBorderColor] is the border color of the badge.
  ///
  /// Param [sendVoiceItemIconColor] is the color of the send voice item icon.
  ///
  /// Param [receiveVoiceItemIconColor] is the color of the receive voice item icon.
  ///
  /// Param [sendBubbleColor] is the color of the send bubble.
  ///
  /// Param [receiveBubbleColor] is the color of the receive bubble.
  ///
  /// Param [badgeTextStyle] is the text style of the badge.
  ///
  /// Param [sendTextStyle] is the text style of the send message.
  ///
  /// Param [receiveTextStyle] is the text style of the receive message.
  ///
  /// Param [conversationListItemTitleStyle] is the text style of the conversation list item title.
  ///
  /// Param [conversationListItemSubTitleStyle] is the text style of the conversation list item subtitle.
  ///
  /// Param [conversationListItemTsStyle] is the text style of the conversation list item timestamp.
  ///
  /// Param [messagesListItemTsStyle] is the text style of the messages list item timestamp.
  ///
  /// Param [inputWidgetSendBtnColor] is the color of the input widget send button.
  ///
  /// Param [inputWidgetSendBtnStyle] is the text style of the input widget send button.
  ChatUIKitTheme({
    this.badgeColor = const Color.fromRGBO(255, 20, 204, 1),
    this.badgeBorderColor = Colors.white,
    this.sendVoiceItemIconColor = const Color.fromRGBO(169, 169, 169, 1),
    this.receiveVoiceItemIconColor = Colors.white,
    this.sendBubbleColor = const Color.fromRGBO(0, 65, 255, 1),
    this.receiveBubbleColor = const Color.fromRGBO(242, 242, 242, 1),
    this.badgeTextStyle =
        const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
    this.sendTextStyle = const TextStyle(color: Colors.white),
    this.receiveTextStyle = const TextStyle(color: Colors.black),
    this.conversationListItemTitleStyle = const TextStyle(fontSize: 17),
    this.conversationListItemSubTitleStyle =
        const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
    this.conversationListItemTsStyle =
        const TextStyle(color: Colors.grey, fontSize: 14),
    this.messagesListItemTsStyle =
        const TextStyle(color: Colors.grey, fontSize: 14),
    this.inputWidgetSendBtnColor = Colors.blue,
    this.inputWidgetSendBtnStyle = const TextStyle(color: Colors.white),
  });

  final Color badgeColor;
  final Color badgeBorderColor;
  final Color sendVoiceItemIconColor;
  final Color receiveVoiceItemIconColor;
  final Color sendBubbleColor;
  final Color receiveBubbleColor;
  final Color inputWidgetSendBtnColor;
  final TextStyle badgeTextStyle;
  final TextStyle sendTextStyle;
  final TextStyle receiveTextStyle;
  final TextStyle conversationListItemTitleStyle;
  final TextStyle conversationListItemSubTitleStyle;
  final TextStyle conversationListItemTsStyle;
  final TextStyle messagesListItemTsStyle;
  final TextStyle inputWidgetSendBtnStyle;
}
