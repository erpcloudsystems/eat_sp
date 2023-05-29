import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../resources/app_values.dart';

class NewCustomButton extends StatelessWidget {
  final Function function;
  final String title;
  const NewCustomButton({
    super.key,
    required this.function,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => function(),
      style: ElevatedButton.styleFrom(
          fixedSize: Size(DoublesManager.d_300.w, DoublesManager.d_50.h),
          shape: const StadiumBorder()),
      child: Text(
        title,
        style: TextStyle(fontSize: DoublesManager.d_20.sp),
      ),
    );
  }
}
