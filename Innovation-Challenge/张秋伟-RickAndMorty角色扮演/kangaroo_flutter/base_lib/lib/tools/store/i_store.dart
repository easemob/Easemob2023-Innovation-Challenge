
typedef ExpSave = Future<bool> Function(String key);
typedef ExpDataGet<T> = T Function(String key);

abstract class IStore{

  Future<bool> setDouble(String key, double value);
  double? getDouble(String key);

  Future<bool> setInt(String key, int value);
  int? getInt(String key);

  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);

  Future<bool> setString(String key, String value);
  String? getString(String key);

  Object? get(String key);

  Set<String> getKeys();

  Future<bool> remove(String key);

  Future<bool> clear();

  bool hasKey(String key);

  Future<void> reload();
  //
  // ///设置key的过期
  // Future<bool> setKeyExp(int expireMills,String key,ExpSave expData);
  //
  // T? getKeyExp<T>(String key,ExpDataGet expData);
  //
  Future<bool> setStringList(String key, List<String> value );

  List<String>? getStringList(String key);

  // Future<bool> setStringMap(String key, Map<String,String> value );
  //
  // Map<String,String>? getStringMap(String key);

}

