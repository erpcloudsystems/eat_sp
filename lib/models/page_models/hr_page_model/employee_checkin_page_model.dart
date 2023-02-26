import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmployeeCheckinPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  EmployeeCheckinPageModel(this.context, this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Date"): data['time'].split(" ")[0],
        tr("Time"): data['time'].split(" ")[1],
      },
      {
        tr("Log Type"): data['log_type'] ?? tr('none'),
        tr("Location / Device ID"): data['device_id'] ?? tr('none'),
      },
      {
        tr("Skip Auto Attendance"): data['skip_auto_attendance'].toString(),
      },
      {
        tr("Longitude"): data['longitude'].toString(),
        tr("Latitude"): data['latitude'].toString(),
      },
    ];
  }
}
