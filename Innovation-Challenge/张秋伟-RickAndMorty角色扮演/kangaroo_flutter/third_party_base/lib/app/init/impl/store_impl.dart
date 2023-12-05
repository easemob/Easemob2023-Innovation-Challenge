
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:base_lib/base_lib.dart';
import 'package:base_lib/tools/platform_util.dart';

class StoreImpl implements IStore{
  late SharedPreferences _prefs;

  Future init() async{
    if(PlatformUtil.isWindows){
      SharedPreferences.setPrefix(SecretUtil.hashMD5(Directory.current.path));
    }
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<bool> clear() => _prefs.clear();

  @override
  Object? get(String key) => _prefs.get(key);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  double? getDouble(String key) => _prefs.getDouble(key);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Set<String> getKeys() => _prefs.getKeys();

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  @override
  bool hasKey(String key) => _prefs.containsKey(key);

  @override
  Future<void> reload() => _prefs.reload();

  @override
  Future<bool> remove(String key) => _prefs.remove(key);

  @override
  Future<bool> setBool(String key, bool value) =>_prefs.setBool(key, value);

  @override
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);

  @override
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  @override
  Future<bool> setStringList(String key, List<String> value) => _prefs.setStringList(key, value);

}