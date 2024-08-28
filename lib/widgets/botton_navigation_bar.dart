import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

Widget getBottomNavigationBar({
  required GlobalKey key,
  void Function(int)? onTap,
  int index = 0,
}) {
  return CurvedNavigationBar(
    key: key,
    index: index,
    height: 55.0,
    items: const [
      Icon(
        Icons.home_outlined,
        size: 25,
        color: APPBAR_COLOR,
      ),
      Icon(
        Icons.receipt_long_outlined,
        size: 25,
        color: APPBAR_COLOR,
      ),
      // Icon(
      //   Icons.category_outlined,
      //   size: 25,
      //   color: APPBAR_COLOR,
      // ),

      Icon(
        Icons.notifications_active_outlined,
        size: 25,
        color: APPBAR_COLOR,
      ),
      Icon(
        Icons.more_vert,
        size: 25,
        color: APPBAR_COLOR,
      ),
    ],
    color: Colors.white,
    //buttonBackgroundColor: Colors.blue[200],
    backgroundColor: Colors.transparent,
    animationCurve: Curves.easeInOut,
    animationDuration: const Duration(milliseconds: 500),
    onTap: onTap,
  );
}
