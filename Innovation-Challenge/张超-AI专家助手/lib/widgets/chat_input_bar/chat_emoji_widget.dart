import 'package:flutter/material.dart';

import 'chat_emoji_data.dart';

typedef EmojiClick = void Function(String emoji);

class ChatEmojiWidget extends StatelessWidget {
  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final double bigSizeRatio;

  final EmojiClick? emojiClicked;

  const ChatEmojiWidget({
    super.key,
    this.crossAxisCount = 8,
    this.mainAxisSpacing = 2.0,
    this.crossAxisSpacing = 2.0,
    this.childAspectRatio = 1.0,
    this.bigSizeRatio = 0.0,
    this.emojiClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 60),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      childrenDelegate: SliverChildBuilderDelegate((context, position) {
        return _getEmojiItemContainer(position);
      }, childCount: ChatEmojiData.listSize),
    );
  }

  _getEmojiItemContainer(int index) {
    var emoji = ChatEmojiData.emojiList[index];
    return ChatExpression(emoji, bigSizeRatio, emojiClicked);
  }
}

class ChatExpression extends StatelessWidget {
  final String emoji;

  final double bigSizeRatio;

  final EmojiClick? emojiClicked;

  const ChatExpression(
    this.emoji,
    this.bigSizeRatio,
    this.emojiClicked, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = Text(
      emoji,
      style: const TextStyle(fontSize: 30),
    );
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.all(bigSizeRatio),
        ),
      ),
      onPressed: () {
        emojiClicked?.call(emoji);
      },
      child: icon,
    );
  }
}
