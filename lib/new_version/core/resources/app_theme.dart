import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';

abstract class AppTheme {
  static ThemeData mainTheme(BuildContext context) => ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        primaryColor: const Color(0xffF9F9F9),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
        ).copyWith(secondary: Colors.blue),
        scaffoldBackgroundColor: Colors.grey.shade200,
        appBarTheme: AppBarTheme(
            titleSpacing: 0.0,
            color: APPBAR_COLOR,
            elevation: 1,
            foregroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            toolbarTextStyle: TextTheme(
              // center text style
              titleLarge: GoogleFonts.cairo(
                  fontStyle: FontStyle.normal,
                  color: Colors.white,
                  fontSize: 18),
            ).bodyMedium,
            // Side text style
            titleTextStyle: TextTheme(
              // appBar text style
              titleLarge: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              // Side text style
            ).titleLarge),
        tabBarTheme: const TabBarTheme(
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: APPBAR_COLOR,
            ),
          ),
        ),
      );
}
