import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';

class UserProfileAppBar extends StatelessWidget {
  final String title;
  final Widget? actionIcon;
  const UserProfileAppBar({
    super.key,
    required this.title,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: DoublesManager.d_90.h,
        elevation: DoublesManager.d_0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        actions: actionIcon != null ? [actionIcon!] : null);
  }
}
