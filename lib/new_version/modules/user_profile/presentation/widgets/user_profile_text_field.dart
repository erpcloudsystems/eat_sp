import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';
import '../../../../core/resources/strings_manager.dart';

class UserProfileTextField extends StatelessWidget {
  const UserProfileTextField({
    super.key,
    required this.controller,
    required this.fieldName,
  });

  final TextEditingController controller;
  final String fieldName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: TextStyle(
              fontSize: DoublesManager.d_15.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: DoublesManager.d_70.h,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: DoublesManager.d_10.sp),
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.name,
              cursorHeight: DoublesManager.d_15.sp,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return StringsManager.textFieldValidation;
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: DoublesManager.d_15.w,
                    vertical: DoublesManager.d_0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(DoublesManager.d_30)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
