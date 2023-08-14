import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../screen/page/generic_page.dart';
import '../provider/module/module_provider.dart';

void notificationConfig(BuildContext context) async {
  ///****** 2- For Push Notifications ******///

  //Getting Notification Token and send it to DB
  FcmToken.getDeviceTokenToSendNotification();

  ///****** 2- End Push Notifications ******///

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
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((message) async {
    if (message.notification != null) {
      log(message.notification!.body!);
      log(message.notification!.title!);
      log(message.data.toString());
    }
    LocalNotificationService.display(message);
  });

// This Triggers When user taps on the notification
// While the app is in background but opened (NOT TERMINATED)
// BACKGROUND: When the application is Running, but (minimized)
// OR application open in a different tab in (web)
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final routeFromMessage = message.data["doctype"];
    log('Navigate to :$routeFromMessage');
    navigateFromNotification(
        context: context,
        docType: message.data['doctype'],
        docName: message.data['document_name']);
  });

  /// receive msg when app is Terminated (Background Handler)
  // Handle background message When messages are received
  // And your application is not running.
  FirebaseMessaging.onBackgroundMessage((firebaseMessagingBackgroundHandler));

  ///****** 3- End Push Notifications ******///
}

///****** 4- For Push Notifications ******///

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
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
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "nextapp-notification-channel",
            "nextapp-notification-channel channel",
            channelDescription: "this is NextApp Notification channel",
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: IOSNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ));

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
    builder: (context) => const GenericPage(),
  ));
}

///****** 1- For Push Notifications ******///

abstract class FcmToken {
  static String deviceTokenToSendPushNotification = '';
  static bool isTokenRefreshed = false;

  // for Firebase Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

//Get the device token
  static Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;

    try {
      final token = await fcm.getToken();

      if (token != null) {
        deviceTokenToSendPushNotification = token;
        isTokenRefreshed = true;
      } else {
        await fcm.requestPermission();
        final newToken = await fcm.getToken();
        deviceTokenToSendPushNotification = newToken!;
        isTokenRefreshed = false;
      }
    } catch (e) {
      print('❌❌ Can\'t get a Notification Token ERROR IS:$e');
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // Note: This callback is fired at each app startup and whenever a new token is generated.
      deviceTokenToSendPushNotification = fcmToken.toString();
      isTokenRefreshed = true;
    }).onError((err) {
      print('❌❌ Can\'t get a Notification Token ERROR IS:$err');
    });
  }
}
///****** 1- End Push Notifications ******///
