
import 'package:base_lib/base_lib.dart';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

class SecertImpl implements ISecret{

  @override
  String decryptAES(String data, String keyStr, {String? ivStr}) {
    final plainText = data;
    final key = Key.fromUtf8(keyStr);
    IV? iv;
    if(ivStr!=null){
      iv = IV.fromUtf8(ivStr);
    }
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.decrypt(Encrypted.fromBase64(plainText),iv: iv);
    return encrypted;
  }

  @override
  String encryptAES(String data, String keyStr, {String? ivStr}) {
    final plainText = data;
    final key = Key.fromUtf8(keyStr);
    IV? iv;
    if(ivStr!=null){
      iv = IV.fromUtf8(ivStr);
    }
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  @override
  String toMd5(List<int> data) {
    var digest = md5.convert(data);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  @override
  String toSha1(List<int> data) {
    var digest = sha1.convert(data).bytes;
    return hex.encode(digest);
  }

  @override
  String toSha256(List<int> data) {
    var digest = sha256.convert(data).bytes;
    return hex.encode(digest);
  }

}
