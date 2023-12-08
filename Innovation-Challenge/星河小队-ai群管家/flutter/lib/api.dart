import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var backendServer = "localhost:8001";

void useRemoteApi() {
  backendServer = "43.143.138.8:8001";
}

void useLocalApi() {
  backendServer = "localhost:8001";
}

Future<List<dynamic>?> aiRoleList() async {
  var response = await http.get(
    Uri.http(backendServer, "/ai_prompt/list"),
  );
  if (response.statusCode == 200) {
    var resData =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (resData['code'] == 0) {
      return resData['data'];
    }
    return null;
  } else {
    var uri = response.request?.url.toString();
    uri ??= "";
    debugPrint("request failed " + uri);
    return null;
  }
}

dynamic askBot(content, promptId, userId, chatId) async {
  var response = await http.post(Uri.http(backendServer, "/bot/ask"),
      body: json.encode({
        'msg': content,
        'promptId': promptId,
        'toUserId': userId,
        'chatId': chatId
      }),
      headers: {HttpHeaders.contentTypeHeader: ContentType.json.toString()});
  if (response.statusCode == 200) {
    var resData =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    if (resData['code'] == 0) {
      return resData['data'];
    }
    return null;
  } else {
    var uri = response.request?.url.toString();
    uri ??= "";
    debugPrint("request failed " + uri);
    return null;
  }
}
