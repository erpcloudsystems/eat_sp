import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/form_widgets.dart';
import '../../../../core/resources/app_values.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/extensions/date_time_extension.dart';

class BirthDateField extends StatelessWidget {
  const BirthDateField({
    super.key,
    required this.userBirthDate,
    required this.newBirthDate,
  });

  final String userBirthDate;
  final Function newBirthDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          StringsManager.birthDate,
          style: TextStyle(
              fontSize: DoublesManager.d_15.sp, fontWeight: FontWeight.bold),
        ),
        Container(
          height: DoublesManager.d_50.h,
          margin: EdgeInsets.symmetric(vertical: DoublesManager.d_10.h),
          padding: EdgeInsets.all(DoublesManager.d_10.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DoublesManager.d_30.sp),
              border:
                  Border.all(color: Colors.grey, width: DoublesManager.d_1.w)),
          child: DatePicker('birth_date', '',
              initialValue: userBirthDate,
              removeUnderLine: true,
              firstDate: DateTime(1800),
              onChanged: (value) =>
                  newBirthDate(value.formateToReadableDate())),
        ),
      ],
    );
  }
}
