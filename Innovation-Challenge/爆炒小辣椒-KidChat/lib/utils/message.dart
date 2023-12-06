import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:im_flutter_sdk/im_flutter_sdk.dart' as em;

extension EMMessageX on em.EMMessage {
  types.Status get _status => direction == em.MessageDirection.SEND
      ? (status == em.MessageStatus.PROGRESS
          ? types.Status.sending
          : status == em.MessageStatus.SUCCESS
              ? types.Status.sent
              : status == em.MessageStatus.FAIL
                  ? types.Status.error
                  : types.Status.delivered)
      : hasRead
          ? types.Status.seen
          : types.Status.delivered;

  types.Message forUI(types.User? author) {
    author ??= types.User(id: from!);
    if (body is em.EMTextMessageBody) {
      return types.TextMessage(
        author: author,
        createdAt: serverTime,
        id: msgId,
        text: (body as em.EMTextMessageBody).content,
        status: _status,
      );
    }
    if (body is em.EMCustomMessageBody) {
      final cb = body as em.EMCustomMessageBody;
      return types.CustomMessage(
        author: author,
        createdAt: serverTime,
        id: msgId,
        metadata: {
          "event": cb.event,
          "params": cb.params,
        },
        status: _status,
      );
    }
    return types.TextMessage(
      author: author,
      createdAt: serverTime,
      id: msgId,
      text: "UNSUPPORTED",
    );
  }

  Future<em.EMUserInfo?> fromUserInfo() async {
    return await em.EMClient.getInstance.userInfoManager
        .fetchUserInfoById([from!]).then((value) => value[from!]);
  }

  Future<types.User> fromUser() {
    return fromUserInfo().then((value) => value!.forUI());
  }
}

extension EMUserInfoX on em.EMUserInfo {
  types.User forUI() {
    return types.User(
      id: userId,
      firstName: nickName,
      imageUrl: avatarUrl,
    );
  }
}
// Widget customMessageBuilder(types.CustomMessage message,
//     {required int messageWidth}) {
//   if (message.metadata!["event"] == "story") {
//     return StoryMessage(
//       message.metadata!["params"]["prompt"],
//       message.metadata!["params"]["content"],
//       messageWidth,
//     );
//   }
//   return Text("custom $messageWidth");
// }
