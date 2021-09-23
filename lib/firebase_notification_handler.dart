import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_handler.dart';

class FirebaseNotifications {
  FirebaseMessaging _messaging;
  BuildContext myContext;

  void setupFirebase(BuildContext context) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async {
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    print('Setting ${settings.authorizationStatus}');

    // Get token, use token to send and receive notifications
    _messaging.getToken().then((value) => print('My Token: $value'));

    // Subscribe to topic and use subscription for group notification
    _messaging
        .subscribeToTopic('Vendescrow')
        .whenComplete(() => print("Completed"));

    // Handle Message
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print('received message $remoteMessage');
      if (Platform.isAndroid)
        showNotification(
            remoteMessage.data['title'], remoteMessage.data['body']);
      else if (Platform.isIOS) {
        showNotification(
            remoteMessage.notification.title, remoteMessage.notification.body);
      }
    });

    // Handle When user opens message
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('Received Opened App Message: $remoteMessage');
      if (Platform.isIOS)
        showDialog(
            context: myContext,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(remoteMessage.notification.title),
                  content: Text(remoteMessage.notification.body),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text('OK'),
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                    )
                  ],
                ));
    });
  }

  static void showNotification(title, body) async {
    var androidChannel = AndroidNotificationDetails(
        'com.vendescrow.vendescrow', 'Vendescrow ', 'World Safest P2P Trading App',
        autoCancel: false,
        ongoing: true,
        importance: Importance.max,
        priority: Priority.high);

    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: androidChannel, iOS: ios);
    await NotificationHandler.flutterLocalNotificationPlugin.show(
        Random().nextInt(1000), title, body, platform,
        payload: 'Vendescrow');
  }
}
