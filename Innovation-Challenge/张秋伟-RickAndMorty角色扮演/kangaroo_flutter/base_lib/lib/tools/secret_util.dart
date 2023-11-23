import 'dart:convert';
import 'package:base_lib/app/application.dart';
import 'dart:io';

abstract class ISecret{
  String toMd5(List<int> data);
  String toSha1(List<int> data);
  String toSha256(List<int> data);
  String encryptAES(String data, String keyStr, {String? ivStr});
  String decryptAES(String data, String keyStr, {String? ivStr});
}

class SecretUtil {
  static late ISecret secret;

  static void init(ISecret iSecret){
    secret = iSecret;
  }

  // md5
  static String hashMD5(String data) => secret.toMd5(Utf8Encoder().convert(data));
  // md5 文件
  static String hashPathMD5(String path) => secret.toMd5(File(path).readAsBytesSync());

  //base64
  static String encodeBase64(String data){
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  //Base64
  static String decodeBase64(String data){
    return String.fromCharCodes(base64Decode(data));
  }

  //aes 加密
  /*简单使用
  * var password = AESUtil.encodeAES(
        '123456', 'your keyStr', 'your ivStr');//your keyStr 如0123456776543210
  * */
  static String encryptAES(String data, {String? keyStr, String? ivStr}) {
    keyStr ??= Application.config.appSafeCode;
    ivStr ??= Application.config.appSafeCodeIv;
    return secret.encryptAES(data, keyStr,ivStr:ivStr);
  }

  //aes 解密
  static String decryptAES(String data, {String? keyStr, String? ivStr}) {
    keyStr ??= Application.config.appSafeCode;
    ivStr ??= Application.config.appSafeCodeIv;
    return secret.decryptAES(data, keyStr, ivStr:ivStr);
  }

  //sha1
  static String encryptSha1(String data) => secret.toSha1(utf8.encode(data));

  //sha256
  static String encryptSha256(String data)=> secret.toSha256(utf8.encode(data));


}