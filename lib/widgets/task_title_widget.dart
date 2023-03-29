import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/cloud_system_widgets.dart';

class TaskTitleWidget extends StatelessWidget {
  const TaskTitleWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    this.status,
  }) : super(key: key);
  final String title;
  final String subTitle;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: SizedBox(
        width: 100.w,
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (status != null)
                  Icon(
                    Icons.circle,
                    color: statusColor(
                      status ?? 'none',
                    ),
                    size: 12,
                  ),
                SizedBox(width: 8),
                Text(
                  subTitle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
