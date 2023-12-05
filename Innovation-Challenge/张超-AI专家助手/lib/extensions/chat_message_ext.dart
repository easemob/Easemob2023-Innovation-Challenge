import 'package:flutter/widgets.dart';

import 'package:em_chat_uikit/em_chat_uikit.dart';

extension ChatMessageExt on EMMessage {
  String summary(BuildContext context) {
    String ret = "";
    switch (body.type) {
      case MessageType.TXT:
        {
          String str = (body as EMTextMessageBody).content;
          ret = str;
        }
        break;
      case MessageType.IMAGE:
        ret = "[${AppLocalizations.of(context)?.uikitImage ?? "Image"}]";
        break;
      case MessageType.VIDEO:
        ret = "[${AppLocalizations.of(context)?.uikitVideo ?? "Video"}]";
        break;
      case MessageType.LOCATION:
        ret = "[${AppLocalizations.of(context)?.uikitLocation ?? "Location"}]";
        break;
      case MessageType.VOICE:
        ret = "[${AppLocalizations.of(context)?.uikitAudio ?? "Audio"}]";
        break;
      case MessageType.FILE:
        ret = "[${AppLocalizations.of(context)?.uikitFile ?? "File"}]";
        break;
      case MessageType.CUSTOM:
        ret = "[${AppLocalizations.of(context)?.uikitCustom ?? "Custom"}]";
        break;
      case MessageType.CMD:
        ret = "";
        break;
      default:
        break;
    }
    return ret;
  }

  String get createTs {
    return TimeTool.timeStrByMs(serverTime);
  }
}
