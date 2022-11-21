import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';

class LeaveApplicationPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  LeaveApplicationPageModel(this.context, this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Posting Date"): reverse(data['posting_date']),
        tr("Status"): data['status'] ?? tr('none'),
      },

      {
        tr("Department"): formatDescription(data['department'] ?? tr('none')),
      },
      {
        tr("Leave Approver"): data['leave_approver'] ?? tr('none'),
        tr("Leave Approver Name"): data['leave_approver_name'] ?? tr('none')
      },

    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("From Date"): data['from_date'] ?? tr('none'),
        tr("To Date"): data['to_date'] ?? tr('none')
      },
      {
        tr("Leave Type"): data['leave_type'] ?? tr('none'),
        tr("Leave Balance Before Application"): data['leave_balance'].toString(),
      },
      {
        tr("Half Day"): data['half_day'].toString() ,
        tr("Total Leave Days"): data['total_leave_days'].toString(),
      },
      {
        tr("Reason"): data['description'] ?? tr('none'),
      },

    ];
  }




}
