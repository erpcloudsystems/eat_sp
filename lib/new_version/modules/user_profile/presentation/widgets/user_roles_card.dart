import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';

class UserRolesCard extends StatelessWidget {
  final List<String> rolesList;
  const UserRolesCard({
    super.key,
    required this.rolesList,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(DoublesManager.d_15),
      elevation: DoublesManager.d_10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(DoublesManager.d_20))),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: DoublesManager.d_200.h,
          minHeight: DoublesManager.d_50.h,
        ),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: IntManager.i_3,
          childAspectRatio: DoublesManager.d_2,
          crossAxisSpacing: DoublesManager.d_5,
          padding: const EdgeInsets.symmetric(horizontal: DoublesManager.d_10),
          children: List.generate(
              rolesList.length,
              (index) => Chip(
                    label: Text(rolesList[index]),
                    elevation: DoublesManager.d_5,
                  )),
        ),
      ),
    );
  }
}
