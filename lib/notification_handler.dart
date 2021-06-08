import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  static BuildContext myContext;

  static void initNotification(BuildContext context) {
    myContext = context;
    var initAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSetting =
        InitializationSettings(android: initAndroid, iOS: initIOS);
    flutterLocalNotificationPlugin.initialize(initSetting,
        onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String payload) {
    if (payload != null) print('Get Payload : $payload');
  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    showDialog(
        context: myContext,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('OK'),
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                )
              ],
            ));
  }
}
