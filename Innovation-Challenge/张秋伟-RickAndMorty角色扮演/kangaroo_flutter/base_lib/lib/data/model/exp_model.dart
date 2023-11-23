
import 'package:base_lib/tools/date_util.dart';

///过期模型
class ExpModel{
  final int expireMills;
  int createTime;


  ExpModel(this.expireMills):createTime = DateUtil.getNowDateMs();

  bool isExpire(){
    return !(createTime + expireMills > DateUtil.getNowDateMs() || expireMills < 0);
  }

  factory ExpModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExpModel(
      json['expireMills'] as int,
    )..createTime = json['createTime'] as int;
  }

  Map<String, dynamic> toJson() =><String, dynamic>{
    'expireMills': expireMills,
    'createTime': createTime,
  };

}
