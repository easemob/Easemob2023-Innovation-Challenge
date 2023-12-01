import '../em_chat_uikit.dart';

class ChatMessageListCallback {
  void onMessagesReceived(List<EMMessage> messages) {}

  void onMessagesRead(List<EMMessage> messages) {}

  void onMessagesDelivered(List<EMMessage> messages) {}

  void onMessagesRecalled(List<EMMessage> messages) {}

  void onGroupMessageRead(List<EMGroupMessageAck> acks) {}

  void onReadAckForGroupMessageUpdated() {}

  void onCmdMessagesReceived(List<EMMessage> messages) {}

  void onConversationsUpdate() {}

  void onConversationRead(String from, String to) {}

  void onMessageReactionDidChange(List<EMMessageReactionEvent> events) {}

  void onSendMessageSuccess(String preSendId, EMMessage message) {}

  void onSendProgress(String preSendId, int progress) {}

  void onSendMessageError(String preSendId, EMMessage message, EMError err) {}
}
