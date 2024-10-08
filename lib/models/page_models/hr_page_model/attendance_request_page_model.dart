import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AttendanceRequestPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  AttendanceRequestPageModel(this.context, this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Department"): data['department'] ?? tr('none'),
        tr("Company"): data['company'] ?? tr('none'),
      },
      {
        tr("From Date"): data['from_date'] ?? tr('none'),
        tr("To Date"): data['to_date'] ?? tr('none'),
      },
      {
        tr("Half Day"): data['half_day'].toString(),
        tr("Half Day Date"): data['half_day_date'] ?? tr('none'),
      },
      {
        ("From Time"): data['from_time'] ?? tr('none'),
        ("To Time"): data['to_time'] ?? tr('none'),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Reason"): data['reason'] ?? tr('none'),
        tr("Explanation"): data['explanation'] ?? tr('none'),
      },
      {
        tr("Longitude"): (data['longitude'] ?? tr('none')).toString(),
        tr("Latitude"): (data['latitude'] ?? tr('none')).toString(),
      },
    ];
  }
}
