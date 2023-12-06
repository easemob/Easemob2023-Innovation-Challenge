import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class StoryMessage extends StatelessWidget {
  final EMMessage message;

  EMCustomMessageBody get body => message.body as EMCustomMessageBody;

  const StoryMessage(
    this.message, {
    super.key,
  });

  String get _prompt => body.params!["prompt"] as String;
  String get _content => body.params!["content"] as String;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "PROMPT：",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  TextSpan(text: _prompt),
                ],
              ),
              textAlign: TextAlign.start,
            ),
            const Divider(
              thickness: 0.0,
              color: Colors.white,
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: "LLM：",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(text: _content),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
