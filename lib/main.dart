import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_local.dart';
import 'screen/other/splash_screen.dart';
import 'new_version/core/resources/routes.dart';
import 'new_version/core/resources/app_theme.dart';
import 'new_version/core/global/bloc_observer.dart';
import 'new_version/core/global/state_managment.dart';
import 'new_version/core/global/dependency_container.dart' as di;

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

// This work only when app is in the Background solution for OnMessage issue
// It must be annotated with @pragma('vm:entry-point') right above the function declaration
// (otherwise it may be removed during tree shaking for release mode).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Background message occurred! ${message.data.toString()}');
// navigateFromNotification(
//       context: context,
//       docType: message.data['doctype'],
//       docName: message.data['document_name']);
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  Bloc.observer = MyBlocObserver();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      EasyLocalization(
          supportedLocales: AppLocal.supportLocals,
          path: AppLocal.path,
          child: MultiProvider(
            providers: StateManagement.stateManagement,
            child: const MyApp(),
          )),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        title: 'NextApp',
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: AppTheme.mainTheme(context),
        home: const SplashScreen(),
        routes: Routes.routes,
      ),
    );
  }
}
