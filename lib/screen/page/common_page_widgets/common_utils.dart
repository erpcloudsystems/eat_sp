import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants.dart';
import '../../../new_version/core/resources/app_values.dart';

class CommonPageUtils {
  static const bottomSheetBorderRadius = DoublesManager.d_18;

  static Future<dynamic> commonBottomSheet(
      {required BuildContext context, required Widget builderWidget}) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        useSafeArea: true,
        builder: (_) => builderWidget);
  }
}

class BottomPageAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const BottomPageAddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: DoublesManager.d_20.h,
      right: DoublesManager.d_20.w,
      child: Container(
        width: DoublesManager.d_60.w,
        height: DoublesManager.d_60.h,
        decoration: const BoxDecoration(
          color: APP_MAIN_COLOR,
          shape: BoxShape.circle,
        ),
        child: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: onPressed),
      ),
    );
  }
}