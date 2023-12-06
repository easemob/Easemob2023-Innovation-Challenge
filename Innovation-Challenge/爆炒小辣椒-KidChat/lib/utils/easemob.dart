import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:kid_chat/utils/memory.dart';

const publicGroupId = "233235270402055";

mixin EaseMob<T extends StatefulWidget> on State<T> {
  // 初始化登陆环信服务器
  void setupEaseMob() async {
    // 判断是否已经登陆，如果没有登陆则注册新帐号
    try {
      final isLoggedIn = await EMClient.getInstance.isLoginBefore();
      if (!isLoggedIn) {
        // 随机生成一个用户信息
        final client = HttpClient();
        final uri = Uri.parse("https://randomuser.me/api/?nat=us");
        final request = await client.getUrl(uri);
        final response = await request.close();
        final json = await response.transform(utf8.decoder).join();
        final user = JSON.parse(json)["results"][0];

        final username = user["login"]["username"].stringValue;
        final password = user["login"]["password"].stringValue;

        // 注册
        await EMClient.getInstance.createAccount(username, password);

        // 登陆
        await EMClient.getInstance.login(username, password);

        //
        await EMClient.getInstance.userInfoManager.updateUserInfo(
          nickname: user["name"]["first"].stringValue,
          avatarUrl: user["picture"]["large"].stringValue,
          mail: user["email"].string,
          phone: user["phone"].string,
          gender: user["gender"].stringValue == "female" ? 2 : 1,
          sign: user["name"]["title"].string,
          birth: user["dob"]["date"].string,
          ext: user.rawString(),
        );

        // 加入默认群组
        await EMClient.getInstance.groupManager.joinPublicGroup(publicGroupId);

        // 加载历史消息
        var startMsgId = '';
        while (true) {
          final result =
              await EMClient.getInstance.chatManager.fetchHistoryMessages(
            conversationId: publicGroupId,
            type: EMConversationType.GroupChat,
            startMsgId: startMsgId,
            pageSize: 20,
            direction: EMSearchDirection.Up,
          );
          if (result.data.isEmpty) {
            break;
          }
          startMsgId = result.data.first.msgId;
        }
      }

      // 新建一个群组，用来承载后面的信息
      // final group = await EMClient.getInstance.groupManager.createGroup(
      //   groupName: "绘本故事",
      //   desc: "绘本故事",
      //   options: EMGroupOptions(
      //     style: EMGroupStyle.PublicOpenJoin,
      //   ),
      // );
      // debugPrint(JSON(group.toJson()).rawString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("登陆IM服务器成功"),
          ),
        );
      }
    } catch (e) {
      // show snackbar error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("登陆IM服务器失败: $e"),
          ),
        );
      }
    }
  }

  // 将生成的一组绘本故事发送到默认群组
  void sendGeneratedContentToGroup(
      MemoryItem user, MemoryItem assistant) async {
    assert(user.role == Role.user);
    assert(user.content.isNotEmpty);
    assert(assistant.role == Role.assistant);
    assert(assistant.content.isNotEmpty);

    final message = EMMessage.createCustomSendMessage(
      targetId: publicGroupId,
      chatType: ChatType.GroupChat,
      event: "story",
      params: {
        "prompt": user.content,
        "content": assistant.content,
      },
    );
    EMClient.getInstance.chatManager.sendMessage(message).then((m) {
      assistant.remoteId = m.msgId;
    });
  }
}
