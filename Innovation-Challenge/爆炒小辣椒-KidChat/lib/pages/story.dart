import 'dart:math';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:kid_chat/pages/thread.dart';
import 'package:kid_chat/utils/easemob.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final animatedListKey = GlobalKey<AnimatedListState>();
  late final EMConversation _conversation;
  var _messages = <EMMessage>[];
  var _userInfos = <String, EMUserInfo>{};
  final _reactions = <String, Future<List<EMMessageReaction>>>{};

  final _box = GetStorage('Story');

  @override
  void initState() {
    _setup();
    super.initState();
  }

  void _setup() async {
    final c = await EMClient.getInstance.chatManager.getConversation(
      publicGroupId,
      type: EMConversationType.GroupChat,
      createIfNeed: true,
    );
    assert(c != null);
    _conversation = c!;

    EMClient.getInstance.chatManager.addEventHandler(
      "storyPage",
      EMChatEventHandler(
        onMessagesRead: (messages) {
          setState(() {
            _messages.addAll(messages);
            animatedListKey.currentState?.insertAllItems(
              _messages.length - messages.length,
              messages.length,
            );
          });
        },
        onMessageReactionDidChange: (events) {
          for (final e in events) {
            final index =
                _messages.indexWhere((element) => element.msgId == e.messageId);
            if (index != -1) {
              setState(() {
                final message = _messages[index];
                _reactions[e.messageId] = message.reactionList();
              });
            }
          }
        },
      ),
    );

    String? cursor;
    final memberIds = <String>[];
    while (true) {
      // 这里需要获取到群组内所有人的用户信息
      final result = await EMClient.getInstance.groupManager
          .fetchMemberListFromServer(publicGroupId, cursor: cursor);
      memberIds.addAll(result.data);
      cursor = result.cursor;
      if (result.cursor == "") {
        break;
      }
    }
    // 获取到所有的用户信息
    _userInfos =
        await EMClient.getInstance.userInfoManager.fetchUserInfoById(memberIds);

    final messages =
        await _conversation.loadMessages(direction: EMSearchDirection.Up);
    for (final message in messages) {
      final reactions = message.reactionList();
      _reactions[message.msgId] = reactions;
    }
    setState(() {
      _messages = messages
          .where((element) => element.body.type == MessageType.CUSTOM)
          .toList();
      animatedListKey.currentState?.insertAllItems(0, _messages.length);
    });
  }

  @override
  void dispose() {
    EMClient.getInstance.chatManager.removeEventHandler("storyPage");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Story")),
      body: Column(
        children: [
          Expanded(
            child: AnimatedList(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              key: animatedListKey,
              physics: const AlwaysScrollableScrollPhysics(),
              initialItemCount: _messages.length,
              itemBuilder: (context, index, animation) {
                final message = _messages[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: _buildMessage(message),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(EMMessage message) {
    final body = message.body as EMCustomMessageBody;
    final prompt = body.params!["prompt"] as String;
    final content = body.params!["content"] as String;
    final from = _userInfos[message.from];
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          // go to thread page
          final route = MaterialPageRoute(
            builder: (_) {
              return ThreadChatPage(message);
            },
          );
          Navigator.of(context).push(route);
        },
        onLongPress: () {
          // add reaction
          showModalBottomSheet<String>(
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.center,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ["👍", "👎", "😂", "😱"]
                      .map(
                        (e) => IconButton(
                          onPressed: () {
                            Navigator.of(context).pop(e);
                          },
                          icon: Text(
                            e,
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              );
            },
          ).then((value) {
            if (value != null) {
              try {
                final f = _reactions[message.msgId];
                f?.then((reactions) {
                  final index = reactions
                      .indexWhere((element) => element.reaction == value);
                  if (index == -1) {
                    EMClient.getInstance.chatManager.addReaction(
                      messageId: message.msgId,
                      reaction: value,
                    );
                  } else {
                    EMClient.getInstance.chatManager.removeReaction(
                        messageId: message.msgId, reaction: value);
                  }
                });
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (from != null)
                Row(
                  children: [
                    CircleAvatar(
                      foregroundImage:
                          (from.avatarUrl != null && from.avatarUrl!.isNotEmpty)
                              ? CachedNetworkImageProvider(from.avatarUrl!)
                              : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Wrap(
                        // mainAxisSize: MainAxisSize.min,
                        direction: Axis.vertical,
                        children: [
                          Text(
                            from.nickName ?? from.userId,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  message.serverTime),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.all(0),
                        ),
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white,
                        ),
                      ),
                      onPressed: () {
                        final key = "fav_${message.msgId}";
                        if (_box.hasData(key)) {
                          _box.remove(key);
                        } else {
                          _box.write(key, true);
                        }
                        setState(() {});
                      },
                      icon: Icon(
                        _box.hasData("fav_${message.msgId}")
                            ? Icons.star
                            : Icons.star_outline,
                      ),
                    )
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  prompt,
                  style: Theme.of(context).textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              Text(
                content,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 99,
              ),
              const SizedBox(height: 12),
              FutureBuilder(
                  future: _reactions[message.msgId],
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final reactions =
                          snapshot.data as List<EMMessageReaction>;
                      if (reactions.isEmpty) return const SizedBox();
                      return Wrap(
                        direction: Axis.horizontal,
                        spacing: 8,
                        runSpacing: 8.0,
                        children: reactions.map((e) {
                          final users = _userInfos.values
                              .where((u) => e.userList.contains(u.userId));
                          return InkWell(
                            onTap: () {
                              if (e.isAddedBySelf) {
                                EMClient.getInstance.chatManager.removeReaction(
                                  messageId: message.msgId,
                                  reaction: e.reaction,
                                );
                              } else {
                                EMClient.getInstance.chatManager.addReaction(
                                  messageId: message.msgId,
                                  reaction: e.reaction,
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(e.reaction),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text(
                                      "|",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  AvatarStack(
                                    height: 20,
                                    width: min(3, users.length) * 20.0,
                                    avatars: users
                                        .map(
                                          (e) => CachedNetworkImageProvider(e
                                                  .avatarUrl ??
                                              "https://img2.baidu.com/it/u=4267252899,2577257883&fm=26&fmt=auto&gp=0.jpg"),
                                        )
                                        .toList(),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return const SizedBox();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
