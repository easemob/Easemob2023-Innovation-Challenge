import '../em_chat_uikit.dart';

class ChatUIKitError {
  static int noPermission = -10;
  static int recordTimeTooShort = -11;
  static int recordError = -12;

  static EMError toChatError(int code, String desc) {
    return EMError.fromJson({"code": code, "description": desc});
  }
}
