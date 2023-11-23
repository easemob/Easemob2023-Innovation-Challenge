
import 'package:base_lib/tools/store/i_store.dart';
import 'package:base_lib/tools/store/lib_store.dart';

class StoreManager{
  static late IStore store;

  static void init(IStore iStore){
    store = LibStore(iStore);
  }
}