
import 'package:base_lib/base_lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'dart:io';
import 'package:rxdart/subjects.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> _didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> _selectNotificationSubject =
BehaviorSubject<String?>();

const String CHANNEL_SYS = "channel_sys";
const String CHANNEL_SYS_NAME = 'System message notification';
const String CHANNEL_APP = "channel_app";
const String CHANNEL_APP_NAME = 'App message notification';
const String Ticker = "You have a new notification";


class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class HNotification{

  static void initNotification(String androidIcon,{String linuxDefaultActionName = "Open notification",String linuxDefaultIcon = 'icons/app_icon.png',}){
    HNotification.init(androidIcon,linuxDefaultActionName:linuxDefaultActionName,linuxDefaultIcon:linuxDefaultIcon);
    HNotification.createNotificationChannel();
  }

  static int notifyId = 0;
  static String? _selectedNotificationPayload;

  ///  [platform] 系统platform [androidIcon] Android图标
  static Future<void> init(String androidIcon,
  {String linuxDefaultActionName = "Open notification",String linuxDefaultIcon = 'icons/app_icon.png'}) async {



    // await _configureLocalTimeZone();
    /**
     * 如果不是web环境编译，并且是linux则为空
     */
    final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
        Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      _selectedNotificationPayload = notificationAppLaunchDetails!.payload;
    }else{
      _selectedNotificationPayload = null;
    }
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(androidIcon);

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String? title,
            String? body,
            String? payload,
            ) async {
          _didReceiveLocalNotificationSubject.add(
            ReceivedNotification(
              id: id,
              title: title,
              body: body,
              payload: payload,
            ),
          );
        });
    const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(
      defaultActionName: linuxDefaultActionName,
      defaultIcon: AssetsLinuxIcon(linuxDefaultIcon),
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
      linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            LogManager.log.d('notification payload: $payload',tag: SysConfig.libUiTag);
          }
          _selectedNotificationPayload = payload;
          _selectNotificationSubject.add(payload);
        });
  }

  // static Future<void> _configureLocalTimeZone( ) async {
  //   if (kIsWeb || Platform.isLinux) {
  //     return;
  //   }
  //   tz.initializeTimeZones();
  //   final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  //   tz.setLocalLocation(tz.getLocation(timeZoneName!));
  // }

  static void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static void initConfigure(BuildContext? context,SelectNotificationCallback? onSelectNotification){
    _requestPermissions();
    _configureSelectNotificationSubject(onSelectNotification);
    _configureDidReceiveLocalNotificationSubject(context,onSelectNotification);
  }

  static void close(){
    _closeSelectNotificationSubject();
    _closeDidReceiveLocalNotificationSubject();
  }

  /// initConfig
  static void _configureSelectNotificationSubject(SelectNotificationCallback? onSelectNotification){
    _selectNotificationSubject.stream.listen((String? payload) {
      if(onSelectNotification!=null){
        onSelectNotification(payload);
      }
    });
  }

  static void _closeSelectNotificationSubject(){
    _selectNotificationSubject.close();
  }

  /// ios 启动弹框配置
  static void _configureDidReceiveLocalNotificationSubject(BuildContext? context,SelectNotificationCallback? onSelectNotification) {
    _didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context??LibRouteNavigatorObserver.instance.navigator!.context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                if(onSelectNotification!=null){
                  onSelectNotification(receivedNotification.payload);
                }
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  static void _closeDidReceiveLocalNotificationSubject(){
    _didReceiveLocalNotificationSubject.close();
  }

  static void createNotificationChannel() async{
    const AndroidNotificationChannel androidNotificationAppChannel =
    AndroidNotificationChannel(
      CHANNEL_SYS,
      'System message notification',
      description: 'System message notification',
      importance: Importance.high,
      enableLights: true
    );
    const AndroidNotificationChannel androidNotificationSysChannel =
    AndroidNotificationChannel(
      CHANNEL_APP,
      'App message notification',
      description: 'App message notification',
      importance: Importance.high,

    );
    var notification =  flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await notification?.createNotificationChannel(androidNotificationAppChannel);
    await notification?.createNotificationChannel(androidNotificationSysChannel);
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> showMuchNotification({
    AndroidBitmap<Object>? largeIcon,
    String channelId = CHANNEL_SYS,
    String channelName = CHANNEL_SYS_NAME,
    String? smallIcon,
    Importance importance = Importance.high,
    String? contentTitle ,
    String? contentText ,
    String? payload ,
    Priority priority = Priority.defaultPriority,
    String ticker = Ticker,
    String? subText ,
    bool ongoing = false,
    int progressMax = 0,
    int progressRate = 0,
    bool alertOnce = false,
    bool showProgress = false
  }) async {
    showNotification(notifyId: notifyId++,
      largeIcon: largeIcon,
      channelId: channelId,
      channelName: channelName,
      smallIcon: smallIcon,
      importance: importance,
      contentTitle: contentTitle,
      contentText: contentText,
      payload: payload,
      priority: priority,
      ticker: ticker,
      subText: subText,
      ongoing: ongoing,
      progressMax: progressMax,
      progressRate: progressRate,
      alertOnce: alertOnce,
      showProgress: showProgress,
    );
  }

  static Future<void> showNotification({
    AndroidBitmap<Object>? largeIcon,
    int notifyId: 0,
    String channelId = CHANNEL_SYS,
    String channelName = CHANNEL_SYS_NAME,
    String? smallIcon,
    Importance importance = Importance.high,
    String? contentTitle ,
    String? contentText ,
    String? payload ,
    Priority priority = Priority.defaultPriority,
    String ticker = Ticker,
    String? subText ,
    bool ongoing = false,
    int progressMax = 0,
    int progressRate = 0,
    bool alertOnce = false,
    bool showProgress = false
}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(channelId, CHANNEL_SYS_NAME,
        largeIcon : largeIcon,
        icon: smallIcon,
        importance: importance,
        priority: priority,
        subText: subText,
        ongoing: ongoing,
        maxProgress: progressMax,
        progress: progressRate,
        onlyAlertOnce:  alertOnce,
        showProgress:  showProgress,
        ticker: ticker);

    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        notifyId, contentTitle, contentText, platformChannelSpecifics,
        payload: payload);
  }

}