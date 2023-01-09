import 'dart:io';

import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/screen/home_screen.dart';
import 'package:next_app/screen/other/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:next_app/service/local_notification_service.dart';
import 'package:next_app/service/service.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'provider/user/user_provider.dart';
import 'screen/other/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'service/server_exception.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

///****** 1- For Push Notifications ******///

String deviceTokenToSendPushNotification = '';
bool isTokenRefreshed= false;

// receive msg when app is Terminated (Background Handler)
// This work only when app is in the Background solution for OnMessage issue
// It must be annotated with @pragma('vm:entry-point') right above the function declaration
// (otherwise it may be removed during tree shaking for release mode).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A bg message just showed up :  ${message.messageId}');
  print('message data: ${message.data.toString()}');
  print('title: ${message.notification!.title}');
}

//Get the device token
Future<void> getDeviceTokenToSendNotification() async {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  try {
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
  } catch (e) {
    print('❌❌ Can\'t get a Notification Token ERROR IS:$e');
  }
  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    deviceTokenToSendPushNotification = fcmToken.toString();
    isTokenRefreshed=true;
  }).onError((err) {
    print('❌❌ Can\'t get a Notification Token ERROR IS:$err');
  });

  // NotificationSettings settings = await _fcm.requestPermission(
  //   alert: true,
  //   announcement: false,
  //   badge: true,
  //   carPlay: false,
  //   criticalAlert: false,
  //   provisional: false,
  //   sound: true,
  // );
  //
}

///****** 1- End Push Notifications ******///

void main() async {
  HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  // for Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  ///****** 2- For Push Notifications ******///

  // Handle background message When messages are received
  // And your application is not running.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //Getting Notification Token and send it to DB
  getDeviceTokenToSendNotification();

  ///****** 2- End Push Notifications ******///

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      EasyLocalization(
          supportedLocales: [
            Locale('en'),
            //Locale('ar'),
          ],
          path: 'assets/locale', // <-- change the path of the translation files
          fallbackLocale: Locale('en'),
          child: MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProvider>(
                  create: (_) => UserProvider()),
              ChangeNotifierProvider<ModuleProvider>(
                  create: (_) => ModuleProvider()),
            ],
            child: MyApp(),
          )),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Next App',
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        primaryColor: Color(0xffF9F9F9),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.blue),
        scaffoldBackgroundColor: Colors.grey.shade200,
        appBarTheme: AppBarTheme(
            titleSpacing: 0.0,
            color: APPBAR_COLOR,
            elevation: 1,
            foregroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            toolbarTextStyle: TextTheme(
              // center text style
              headline6: GoogleFonts.cairo(
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 18),
            ).bodyText2,
            // Side text style
            titleTextStyle: TextTheme(
              // appBar text style
              headline6: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              // Side text style
            ).headline6),
        tabBarTheme: TabBarTheme(
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: APPBAR_COLOR)),
        ),
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: Consumer<UserProvider>(
        builder: (BuildContext context, userProvider, Widget? child) {
          return userProvider.user == null
              ? Center(
                  child: FutureBuilder(
                      future: userProvider.getUserData(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return SplashScreen();

                        return LoginScreen();
                      }),
                )
              : HomeScreen();
        },
      ),
    );
  }
}
