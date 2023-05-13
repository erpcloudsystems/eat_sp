import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/page/generic_page.dart';
import '../provider/module/module_provider.dart';

void notificationConfig(BuildContext context) async {
  ///****** 3- For Push Notifications ******///

  LocalNotificationService.initialize(context);

// This Triggers When user taps on the notification
// While the app is NOT in background and NOT Running (TERMINATED)
// TERMINATED: When the device is locked or the application is not running
  FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      navigateFromNotification(
          context: context,
          docType: message.data['doctype'],
          docName: message.data['document_name']);
    }
  });

// This Triggers when app in Foreground work
// FOREGROUND: When the application is open, in view and in use.
    //for IOS Foreground Notification
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

  FirebaseMessaging.onMessage.listen((message) async {
    if (message.notification != null) {
      print(message.notification!.body);
      print(message.notification!.title);
      print(message.data);
    }
    LocalNotificationService.display(message);
  });

// This Triggers When user taps on the notification
// While the app is in background but opened (NOT TERMINATED)
// BACKGROUND: When the application is Running, but (minimized)
// OR application open in a different tab in (web)
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final routeFromMessage = message.data["doctype"];
    print('Navigate to :$routeFromMessage');
    navigateFromNotification(
        context: context,
        docType: message.data['doctype'],
        docName: message.data['document_name']);
  });

  ///****** 3- End Push Notifications ******///
}

///****** 4- For Push Notifications ******///

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final messaging = FirebaseMessaging.instance;

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        if (payload != null) {
          final List payloadDetails = json.decode(payload);

          navigateFromNotification(
            context: context,
            docType: payloadDetails[0],
            docName: payloadDetails[1],
          );

          // /// IOS
          // Future iosPermission() async {
          //   if (Platform.isIOS) {
          //     NotificationSettings settings = await messaging.requestPermission(
          //       alert: true,
          //       announcement: false,
          //       badge: true,
          //       carPlay: false,
          //       criticalAlert: false,
          //       provisional: false,
          //       sound: true,
          //     );
          //   }
          // }
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "nextapp-notification-channel",
            "nextapp-notification-channel channel",
            channelDescription: "this is NextApp Notification channel",
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: IOSNotificationDetails());

      // Here we convert the notification details to String as Payload doesn't accept
      // any other data types in this version.
      final List<String> messagePayLoad = [
        message.data['doctype'],
        message.data['document_name']
      ];
      final String payloadToRetrieve = json.encode(messagePayLoad);

      /// this create the channel
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: payloadToRetrieve,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

///****** Helping functions ******///
void navigateFromNotification({
  required BuildContext context,
  required String docType,
  required String docName,
}) {
  context.read<ModuleProvider>().setModule = docType;
  context.read<ModuleProvider>().pushPage(docName);
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => GenericPage(),
  ));
}
