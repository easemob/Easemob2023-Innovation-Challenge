import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:g_json/g_json.dart';
import 'package:intl/intl.dart';
import 'package:kid_chat/utils/constants.dart';

class LLM {
  static const _urlString = "wss://spark-api.xf-yun.com/v3.1/chat";
  static const _domain = "generalv3";

  static final _hmacSha256 = Hmac(sha256, utf8.encode(Constants.iApiSecret));

  factory LLM() => _instance;

  static final LLM _instance = LLM._internal();

  final _df = DateFormat('EEE, dd MMM yyyy HH:mm:ss');

  WebSocket? _webSocket;

  final _memory = <Map<String, dynamic>>[];

  StreamController<List<String>>? _readController;

  LLM._internal();

  Uri _assembleAuthorizationUri() {
    final uri = Uri.parse(_urlString);
    //
    final buffer = StringBuffer();
    //
    buffer.writeln("host: ${uri.host}");
    // 当前时间戳，采用RFC1123格式，例如：Tue, 03 Jul 2018 08:08:08 GMT

    final date = "${_df.format(DateTime.now().toUtc())} GMT";
    buffer.writeln("date: $date");

    buffer.write("GET ${uri.path} HTTP/1.1");

    // 利用hmac-sha256算法结合APISecret对上一步的tmp签名，获得签名后的摘要tmp_sha。
    var digest = _hmacSha256.convert(utf8.encode(buffer.toString()));

    final signature = base64Encode(digest.bytes);

    final authorizationOrigin =
        "api_key=\"${Constants.iApiKey}\", algorithm=\"hmac-sha256\", headers=\"host date request-line\", signature=\"$signature\"";

    final authorization = base64Encode(utf8.encode(authorizationOrigin));

    return Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: uri.path,
      queryParameters: {
        "authorization": authorization,
        "date": date,
        "host": uri.host,
      },
    );
  }

  Future _setup() {
    final uri = _assembleAuthorizationUri();
    return WebSocket.connect(uri.toString()).then((value) {
      _webSocket = value;
      _webSocket?.listen(_handle, onError: (err) {
        throw err;
      }, onDone: () {
        _webSocket = null;
      });
    }).onError((error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace, label: error.toString());
      throw 'connect spark server failed';
    });
  }

  void _handle(dynamic event) {
    final data = event is String ? JSON.parse(event) : JSON(event);
    debugPrint(data.toString());
    _readController?.add(data["payload"]["choices"]["text"]
        .listValue
        .map<String>((e) => e["content"].stringValue)
        .toList(growable: false));
    final status = data["header"]["status"].integerValue;
    if (status == 2) {
      _readController?.close();
      _webSocket?.close();
    }
  }

  FutureOr<Stream<List<String>>> run(String content,
      {bool clearMemory = false, String? userId}) async {
    if (_webSocket != null) {
      throw "LLM is busying";
    }

    await _setup();

    if (_webSocket == null || _webSocket!.readyState != WebSocket.open) {
      throw "LLM setup failed. Please try again later.";
    }

    if (clearMemory) {
      _memory.clear();
    }

    var message = content;
    if (_memory.isEmpty) {
      message = "你是一位富有创造力的故事家, 请根据我给出的内容撰写童话故事。我给出的内容是：$content";
    }

    final item = {"role": "user", "content": message};

    _memory.add(item);

    // 这里需要把历史消息都拉出来
    final data = {
      "header": {
        "app_id": Constants.ifAppId,
        if (userId != null) "uid": userId,
      },
      "parameter": {
        "chat": {
          "domain": _domain,
          "temperature": 0.7,
          "max_tokens": 1024,
        }
      },
      "payload": {
        "message": {
          "text": _memory.toList(growable: false),
        }
      }
    };

    var answer = "";
    _readController = StreamController.broadcast(sync: true);

    _readController?.stream.listen((event) {
      answer += event.join();
    });

    _readController?.done.then(
      (value) => _memory.add({"type": "assistant", "content": answer}),
    );

    debugPrint("send: ${jsonEncode(data)}");
    _webSocket?.add(jsonEncode(data));

    // 等待结果
    return _readController!.stream;
  }

  void stop() {
    _webSocket?.close();
    _webSocket = null;
  }
}
