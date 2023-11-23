
//是否有新版本

import 'update_localizations.dart';

enum UpdateType{
  yes,no
}

abstract class Update{
  //是否有新版本
  final UpdateType update;
  //新版本号
  final String? newVersion;
  //更新日志
  final String? updateLog;
  //是否强制更新
  final bool? constraint;
  //配置默认更新dialog 的title
  final String? updateDefDialogTitle;
  //新app大小
  final String? targetSize;

  Update(this.update, this.newVersion, this.updateLog, this.constraint, this.updateDefDialogTitle, this.targetSize);

  String getTitle(UpdateString updateString){
    if(updateDefDialogTitle==null){
      if(constraint==true){
        return updateString.forceUpgradeVersion!+newVersion!+updateString.version!;
      }else{
        return updateString.upgradeToVersion!+newVersion!+updateString.version!+'?';
      }
    }else{
      return updateDefDialogTitle!;
    }
  }

  String getContent(UpdateString updateString){
    String msg = "";
    if(targetSize!=null){
      msg = "${updateString.newVersionSize!}：$targetSize\n\n";
    }
    if (updateLog!=null) {
      msg += updateLog!;
    }
    return msg;
  }
}

class UpdateAndroid extends Update{
  //新app下载地址
  final String? apkFileUrl;


  UpdateAndroid({UpdateType update = UpdateType.no,String? newVersion, String? updateLog, bool? constraint, String? updateDefDialogTitle, String? targetSize,this.apkFileUrl})
      :super(update, newVersion, updateLog, constraint, updateDefDialogTitle,targetSize);
}

class UpdateIos extends Update{
  //新app下载地址
  final String? appStoreUrl;

  UpdateIos({UpdateType update = UpdateType.no,String? newVersion, String? updateLog, bool? constraint, String? updateDefDialogTitle, String? targetSize, this.appStoreUrl}) : super(update, newVersion, updateLog, constraint, updateDefDialogTitle,targetSize);



}