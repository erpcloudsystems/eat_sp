import 'package:flutter/cupertino.dart';

class AppRadius {
  static BorderRadius radius12 = BorderRadius.circular(12);
  static BorderRadius radius10 = BorderRadius.circular(10);
  static BorderRadius radius18 = BorderRadius.circular(18);
  static BorderRadius radiusOnlyBR = const BorderRadius.only(
    bottomRight: Radius.circular(70),
  );
  static BorderRadius radiusOnlyTop = const BorderRadius.only(
    topLeft: Radius.circular(18),
    topRight: Radius.circular(18),
  );
}
