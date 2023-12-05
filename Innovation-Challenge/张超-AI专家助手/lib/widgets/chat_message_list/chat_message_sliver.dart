import 'package:flutter/widgets.dart';

import 'chat_message_sliver_list.dart';

class ChatMessageSliver extends SliverMultiBoxAdaptorWidget {
  /// Creates a sliver that places box children in a linear array.
  const ChatMessageSliver({
    super.key,
    required super.delegate,
  });

  @override
  ChatMessageRenderSliverList createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element =
        context as SliverMultiBoxAdaptorElement;
    return ChatMessageRenderSliverList(childManager: element);
  }
}
