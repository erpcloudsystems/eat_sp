import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../screen/sub_category_screen.dart';

void notificationConfig(BuildContext context) async{

///****** 3- For Push Notifications ******///

LocalNotificationService.initialize(context);

// This Triggers When user taps on the notification
// While the app is NOT in background and NOT Running (TERMINATED)
// TERMINATED: When the device is locked or the application is not running
FirebaseMessaging.instance.getInitialMessage().then((message) {
if(message != null){
final routeFromMessage = message.data["route"];

Navigator.of(context).push(PageRouteBuilder(
pageBuilder: (context, animation1, animation2) =>
SubCategoryScreen(routeFromMessage, 1),
));

}
});


// This Triggers when app in Foreground work
// FOREGROUND: When the application is open, in view and in use.
FirebaseMessaging.onMessage.listen((message) {
if(message.notification != null){
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
final routeFromMessage = message.data["route"];
print('Navigate to :$routeFromMessage');

Navigator.of(context).push(PageRouteBuilder(
pageBuilder: (context, animation1, animation2) =>
SubCategoryScreen(routeFromMessage, 1),
));

});


///****** 3- End Push Notifications ******///



}


///****** 4- For Push Notifications ******///

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? route) async {
        if (route != null) {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                SubCategoryScreen(route, 1),
          ));
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
      );

      /// this create the channel
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}


