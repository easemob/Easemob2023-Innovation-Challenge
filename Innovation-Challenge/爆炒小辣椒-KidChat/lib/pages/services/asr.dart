import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:g_json/g_json.dart';
import 'package:kid_chat/utils/constants.dart';

typedef ResultUpdated = void Function(String value);

// 此次暂不启用
class ASR {
  factory ASR() => _instance;

  static final ASR _instance = ASR._internal();
  late final _hmacSha1 = Hmac(sha1, utf8.encode(Constants.iASRSecret));

  WebSocket? _webSocket;
  ResultUpdated? _appendNewText;

  ASR._internal();

  Uri _assembleAuthorizationUri() {
    final ts = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    final baseString = "${Constants.ifAppId}$ts";

    // 对baseString进行MD5运算，得到32位小写的字符串
    final digest = md5.convert(utf8.encode(baseString)).toString();

    //  .以apiKey为key对MD5之后的baseString进行HmacSHA1加密，然后再对加密后的字符串进行base64编码。
    final signature =
        base64Encode(_hmacSha1.convert(utf8.encode(digest)).bytes);

    return Uri(
      scheme: "wss",
      host: "rtasr.xfyun.cn",
      path: "/v1/ws",
      queryParameters: {
        "appid": Constants.ifAppId,
        "ts": ts,
        "signa": signature,
        "vadMdn": "2", //远近场切换，不传此参数或传1代表远场，传2代表近场
        "engLangType": "2",
      },
    );
  }

  Future _setup() {
    final uri = _assembleAuthorizationUri();
    return WebSocket.connect(uri.toString()).then(
      (value) {
        _webSocket = value;
        _webSocket?.listen(
          _handle,
          onDone: () {
            _webSocket = null;
          },
        );
      },
      onError: (error, stackTrace) {
        // debugPrintStack(stackTrace: stackTrace, label: error.toString());
        throw Exception("ASR setup failed: $error");
      },
    );
  }

  void _handle(dynamic event) {
    final data = event is String ? JSON.parse(event) : JSON(event);
    // debugPrint("ASR receive: $data");
    final action = data["action"].stringValue;
    if (action == "error") {
      _webSocket?.close();
      _webSocket = null;
      return;
    }
    if (action == "started") {
      return;
    }
    if (action == "result") {
      final content = JSON.parse(data["data"].stringValue);
      // 将所有的w拼接起来
      final text = content["cn"]["st"]["rt"]
          .listValue
          .map((e) => e["cw"].listValue.map((e) => e["w"].stringValue).join())
          .join();
      _appendNewText?.call(text);
      return;
    }
  }

  Future<ASRStreamSink> run(ResultUpdated callback) async {
    if (_webSocket != null) {
      throw Exception("ASR is already running");
    }

    await _setup();

    _appendNewText = callback;

    if (_webSocket != null) {
      return ASRStreamSink(_webSocket!);
    }

    throw Exception("ASR setup failed");
  }
}

class ASRStreamSink {
  final StreamSink<dynamic> _sink;

  StreamSubscription? _streamSubscription;

  ASRStreamSink(this._sink);

  final _data = <int>[];
  var _pos = 0;
  var _finished = false;

  void connect(Stream<Uint8List> stream) {
    if (_streamSubscription != null) {
      throw Exception("ASRStreamSink is running");
    }
    _streamSubscription =
        Stream.periodic(const Duration(milliseconds: 40), (_) {})
            .listen((event) {
      final range = min(1280, _data.length - _pos);
      if (range > 0) {
        _sink.add(_data.sublist(_pos, _pos + range));
        _pos += range;
      }
      if (_finished && _pos >= _data.length) {
        _sink.add('{"end": true}');
        _streamSubscription?.cancel();
        _streamSubscription = null;
      }
    });

    stream.listen(
      _data.addAll,
      onDone: () {
        _finished = true;
      },
    );
  }
}
