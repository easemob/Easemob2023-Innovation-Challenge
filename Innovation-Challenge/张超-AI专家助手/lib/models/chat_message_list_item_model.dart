import '../em_chat_uikit.dart';

class ChatMessageListItemModel {
  const ChatMessageListItemModel(this.message, [this.needTime = false]);
  final EMMessage message;
  final bool needTime;

  String get msgId => message.msgId;

  ChatMessageListItemModel copyWithMsg(EMMessage message) {
    return ChatMessageListItemModel(message, needTime);
  }

  ChatMessageListItemModel copyWithNeedTime(bool needTime) {
    return ChatMessageListItemModel(message, needTime);
  }

  bool isSend() {
    return message.direction == MessageDirection.SEND;
  }
}
