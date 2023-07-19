import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';

class EmployeeAdvancePageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  EmployeeAdvancePageModel(this.context, this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Department"): data['department'] ?? tr('none'),
        tr("Posting Date"): reverse(data['posting_date']),
      },
      {
        tr("Currency"): data['currency'] ?? tr('none'),
        tr("Exchange Rate"): data['exchange_rate'].toString(),
      },
      {
        tr("Repay Unclaimed Amount from Salary"):
            data['repay_unclaimed_amount_from_salary'].toString(),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Purpose"): data['purpose'] ?? tr('none'),
        tr("Explanation"): data['explanation'] ?? tr('none')
      },
      {
        tr("Advance Amount"): data['advance_amount'].toString(),
        tr("Paid Amount"): data['paid_amount'].toString(),
      },
      {
        tr("Pending Amount"): data['pending_amount'].toString(),
        tr("Claimed Amount"): data['claimed_amount'].toString(),
      },
      {
        tr("Returned Amount"):
            data['repay_unclaimed_amount_from_salary'].toString(),
      },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr("status"): data['status'] ?? tr('none'),
        tr("Advance Account"): data['advance_account'] ?? tr('none')
      },
      {
        tr("Company"): data['company'] ?? tr('none'),
        tr("Mode of Payment"): data['mode_of_payment'] ?? tr('none'),
      },
    ];
  }
}
