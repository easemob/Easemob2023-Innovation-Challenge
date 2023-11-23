
import 'package:base_lib/app/sys_config.dart';
import 'package:base_lib/data/model/exp_model.dart';
import 'package:base_lib/tools/log/log_manager.dart';
import 'package:base_lib/tools/secret_util.dart';
import 'package:base_lib/tools/store/i_store.dart';
import 'dart:convert' as convert;


class LibStore implements IStore{

  final IStore _realStore;

  const LibStore(this._realStore);

  IStore getRealStore() => _realStore;

  @override
  Future<bool> clear() => _realStore.clear();

  @override
  Object? get(String key) => _realStore.get(key);

  @override
  bool? getBool(String key) => _realStore.getBool(key);

  @override
  double? getDouble(String key) => _realStore.getDouble(key);

  @override
  int? getInt(String key) => _realStore.getInt(key);

  @override
  Set<String> getKeys() => _realStore.getKeys();


  @override
  bool hasKey(String key) => _realStore.hasKey(key);

  @override
  Future<void> reload() => _realStore.reload();

  @override
  Future<bool> remove(String key) => _realStore.remove(key);

  @override
  Future<bool> setBool(String key, bool value) => _realStore.setBool(key, value);

  @override
  Future<bool> setDouble(String key, double value) => _realStore.setDouble(key, value);

  @override
  Future<bool> setInt(String key, int value) => _realStore.setInt(key, value);

  @override
  Future<bool> setString(String key, String value,{bool safe = false}){
    var v = value;
    if(safe){
      v = SecretUtil.encryptAES(value);
    }
    return _realStore.setString(key, v);
  }

  @override
  String? getString(String key,{bool safe = false}) {
    var value = _realStore.getString(key);
    if(value!=null){
      if(safe){
        return SecretUtil.decryptAES(value);
      }
    }
    return value;
  }



  @override
  List<String>? getStringList(String key, {bool safe = false}) {
    var value = _realStore.getStringList(key);
    if(value!=null){
      if(safe){
        return value.map((e) {
          return SecretUtil.decryptAES(e);
        }).toList();
      }
    }
    return value;
  }

  @override
  Future<bool> setStringList(String key, List<String> value, {bool safe = false}) {
    var v = value;
    if(safe){
      v = value.map((e) {
        return SecretUtil.encryptAES(e);
      }).toList();
    }
    return _realStore.setStringList(key, v);
  }

  T? getKeyExp<T>(String key, ExpDataGet expData) {
    var expValue = getString(key+SysConfig.exp);
    if(expValue!=null){
      var exp = ExpModel.fromJson(convert.jsonDecode(expValue));
      if(exp.isExpire()){
        LogManager.log.d("超过过期时间",tag: SysConfig.libApplicationTag);
        remove(key+SysConfig.exp);
        remove(key);
        return null;
      }else{
        return expData.call(key);
      }
    }else{
      LogManager.log.d("不存在数据",tag: SysConfig.libApplicationTag);
      return null;
    }
  }

  Future<bool> setKeyExp(int expireMills, String key, ExpSave expData) async {
    var encodeRes = await expData.call(key);
    if(encodeRes){
      LogManager.log.d(convert.jsonEncode(ExpModel(expireMills)),tag: SysConfig.libApplicationTag);
      return setString(key+SysConfig.exp, convert.jsonEncode(ExpModel(expireMills)));
    }else{
      return false;
    }
  }

  Map<String, String>? getStringMap(String key, {bool safe = false}) {
    var value = getString(key,safe: safe);
    if(value!=null){
      return Map<String, String>.from(convert.jsonDecode(value));
    }
    return null;
  }

  Future<bool> setStringMap(String key, Map<String, String> value, {bool safe = false}) {
    String valueJson = convert.jsonEncode(value);
    return setString(key, valueJson,safe: safe);
  }



}