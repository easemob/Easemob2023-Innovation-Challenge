import 'dart:math';

class ChatBaseController {
  ChatBaseController({String? key}) : key = key ?? ChatRandomKey.randomKey;
  late final String key;
}

class ChatRandomKey {
  static String get randomKey => Random().nextInt(999999999).toString();
}
