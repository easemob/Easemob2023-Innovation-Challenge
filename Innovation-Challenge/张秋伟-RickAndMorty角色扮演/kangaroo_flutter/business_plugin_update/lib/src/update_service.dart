
import 'package:base_lib/base_lib.dart';
import 'package:flutter/widgets.dart';
import 'package:ota_update/ota_update.dart';
import 'package:third_party_base/tools/notification/h_notification.dart';

import 'update.dart';
import 'update_dialog.dart';
import 'update_localizations.dart';
const int _notifyId = 10010;
const String _payload = "UpdateService";

class UpdateService{

  UpdateService._();

  static final UpdateService _instance = UpdateService._();

  static UpdateService get instance {
    return _instance;
  }

  UpdateDialog? dialog;

  void checkNewVersion(BuildContext context,Update update){
    var string = UpdateLocalizations.getUpdateString(context);
    if (dialog != null && dialog!.isShowing()) {
      return;
    }
    if(update.update == UpdateType.yes){
      if(update is UpdateAndroid){
        dialog = UpdateDialog.showUpdate(context,
            title: update.getTitle(string),
            updateContent: update.getContent(string),
            isForce: update.constraint??false,
            updateButtonText: string.update!,
            onUpdate: () async {

              String url = update.apkFileUrl!;
              try {
                HNotification.showNotification(notifyId: _notifyId,contentTitle: string.startDownloading,contentText: string.connectingToServer,ongoing: true,payload: _payload);
                // destinationFilename 是对下载的apk进行重命名,可以自己定义
                OtaUpdate().execute(url, destinationFilename: 'news.apk').listen(
                      (OtaEvent event) {
                    //print('status:${event.status},value:${event.value}');
                    switch(event.status){
                      case OtaStatus.DOWNLOADING: // 下载中
                        if(value != int.parse(event.value!)){
                          HNotification.showNotification(notifyId: _notifyId,showProgress: true,alertOnce: true,progressMax: 100,progressRate: int.parse(event.value!),
                              contentTitle: "${string.downloading}:${BaseInit.appName}",contentText: "${event.value!} %",ongoing: true,payload: _payload);
                          value = int.parse(event.value!);
                        }
                        dialog!.update(double.parse(event.value!)*0.01);
                        break;
                      case OtaStatus.INSTALLING: //安装中
                        HNotification.cancelNotification(_notifyId);
                        dialog!.dismiss();
                        break;
                      case OtaStatus.PERMISSION_NOT_GRANTED_ERROR: // 权限错误
                        HNotification.showNotification(notifyId: _notifyId,contentTitle: string.insufficientPermissions,ongoing: true,payload: _payload);
                        TipToast.showToast(string.insufficientPermissions!,tipType: TipType.error);
                        dialog!.dismiss();
                        break;
                      default: // 其他问题
                        dialog!.dismiss();
                        break;
                    }
                  },
                );
              } catch (e) {
                dialog!.dismiss();
                HNotification.showNotification(notifyId: _notifyId,contentTitle: string.downloadPathWrong,ongoing: true,payload: _payload);
                TipToast.showToast(string.downloadPathWrong!,tipType: TipType.error);
              }
            });
      }else if(update is UpdateIos){
        dialog = UpdateDialog.showUpdate(context,
            title: update.getTitle(UpdateLocalizations.getUpdateString(context)),
            updateContent: update.getContent(UpdateLocalizations.getUpdateString(context)),
            isForce: update.constraint??false,
            updateButtonText: UpdateLocalizations.getUpdateString(context).jumpToAppStore!,
            onUpdate: () async{
              if (await LaunchTools.canLaunchUrl(Uri.parse(update.appStoreUrl!))){
                await LaunchTools.launchUrl(Uri.parse(update.appStoreUrl!));
              }else {
                throw 'Could not launch ${update.appStoreUrl!}';
              }
            });
      }
    }

  }

  int? value;
  //
  // Future<void> tryOtaUpdate(String url,UpdateString string) async {
  //   try {
  //     HNotification.showNotification(notifyId: _notifyId,contentTitle: string.startDownloading,contentText: string.connectingToServer,ongoing: true,payload: _payload);
  //     // destinationFilename 是对下载的apk进行重命名,可以自己定义
  //     OtaUpdate().execute(url, destinationFilename: 'news.apk').listen(
  //           (OtaEvent event) async {
  //         //print('status:${event.status},value:${event.value}');
  //         switch(event.status){
  //           case OtaStatus.DOWNLOADING: // 下载中
  //             print('status:${event.status},value:${event.value}');
  //
  //
  //           // notify()async{
  //           //   // await HNotification.showNotification(notifyId: _notifyId,showProgress: true,alertOnce: true,progressMax: 100,progressRate: int.parse(event.value!),
  //           //   //     contentTitle: "${string.downloading}:${Application.appName}",contentText: "${event.value!} %",ongoing: true,payload: _payload);
  //           //
  //           //   final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //           //   AndroidNotificationDetails('progress channel', 'progress channel',
  //           //       channelDescription: 'progress channel description',
  //           //       channelShowBadge: false,
  //           //       importance: Importance.max,
  //           //       priority: Priority.high,
  //           //       onlyAlertOnce: true,
  //           //       showProgress: true,
  //           //       maxProgress: 100,
  //           //       progress: int.parse(event.value!));
  //           //   final NotificationDetails platformChannelSpecifics =
  //           //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //           //   await flutterLocalNotificationsPlugin.show(
  //           //       0,
  //           //       'progress notification title',
  //           //       'progress notification body',
  //           //       platformChannelSpecifics,
  //           //       payload: 'item x');
  //           //
  //           // }
  //           // notify();
  //             dialog!.update(double.parse(event.value!)*0.01);
  //             break;
  //           case OtaStatus.INSTALLING: //安装中
  //              HNotification.cancelNotification(_notifyId);
  //             dialog!.dismiss();
  //             break;
  //           case OtaStatus.PERMISSION_NOT_GRANTED_ERROR: // 权限错误
  //             HNotification.showNotification(notifyId: _notifyId,contentTitle: string.insufficientPermissions,ongoing: true,payload: _payload);
  //             TipToast.instance.tip(string.insufficientPermissions!,tipType: TipType.error);
  //             dialog!.dismiss();
  //             break;
  //           default: // 其他问题
  //             dialog!.dismiss();
  //             break;
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     dialog!.dismiss();
  //     HNotification.showNotification(notifyId: _notifyId,contentTitle: string.downloadPathWrong,ongoing: true,payload: _payload);
  //     TipToast.instance.tip(string.downloadPathWrong!,tipType: TipType.error);
  //   }
  // }
}