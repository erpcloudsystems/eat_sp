import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

Widget getBottomNavigationBar({
  required GlobalKey key,
  void Function(int)? onTap,
  int index = 2,
}) {
  return CurvedNavigationBar(
    key: key,
    index: index,
    height: 55.0,
    items: const <Widget>[
      Icon(Icons.receipt_long_outlined, size: 25, color: Colors.white),
      Icon(Icons.person, size: 25, color: Colors.white),
      Icon(Icons.home, size: 25, color: Colors.white),
      Icon(Icons.notifications_active, size: 25, color: Colors.white),
      Icon(Icons.more_vert, size: 25, color: Colors.white),
    ],
    color: APPBAR_COLOR,
    buttonBackgroundColor: APPBAR_COLOR,
    backgroundColor: Colors.transparent,
    animationCurve: Curves.easeInOut,
    animationDuration: const Duration(milliseconds: 500),
    onTap: onTap,
  );
}
