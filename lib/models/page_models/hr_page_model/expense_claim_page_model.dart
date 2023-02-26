import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';

class ExpenseClaimPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  ExpenseClaimPageModel(this.context, this.data)
      : _expenses = List<Map<String, dynamic>>.from(data['expenses'] ?? [])
          ..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  final List<Map<String, dynamic>> _expenses;

  List<Map<String, dynamic>> get expenses => _expenses;

  final List<Tab> tabs = const [
    Tab(text: 'Expenses'),
    Tab(text: 'Connections'),
  ];

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Department"): data['department'] ?? tr('none'),
      },
      {
        tr("Expense Approver"): data['expense_approver'] ?? tr('none'),
        tr("Approval Status"): data['approval_status'].toString(),
      },
      {
        tr("Is Paid"): data['is_paid'].toString(),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Total Sanctioned Amount"):
            data['total_sanctioned_amount'].toString(),
        tr("Total Taxes and Charges"):
            data['total_taxes_and_charges'].toString(),
      },
      {
        tr("Total Advance Amount"): data['total_advance_amount'].toString(),
        tr("Grand Total"): data['grand_total'].toString(),
      },
      {
        tr("Total Claimed Amount"): data['total_claimed_amount'].toString(),
        tr("Total Amount Reimbursed"):
            data['total_amount_reimbursed'].toString(),
      },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr("Posting Date"): reverse(data['posting_date']),
        tr("Payable Account"): data['payable_account'] ?? tr('none'),
      },
      {
        tr("Cost Center"): data['cost_center'] ?? tr('none'),
        tr("Project"): data['project'] ?? tr('none'),
      },
      {
        tr("Status"): data['status'] ?? tr('none'),
      },
    ];
  }

  List<MapEntry<String, String>> expenseCardValues(int index) {
    return [
      MapEntry(tr('Expense Date'), expenses[index]['expense_date'] ?? 'none'),
      MapEntry(
          tr('Expense Claim Type'), expenses[index]['expense_type'] ?? 'none'),
      MapEntry(
          tr('Default Account'), expenses[index]['default_account'] ?? 'none'),
      MapEntry(tr('Amount'), currency(expenses[index]['amount'])),
      MapEntry(tr('Sanctioned Amount'),
          currency(expenses[index]['sanctioned_amount'])),
      MapEntry(tr('Cost Center'), expenses[index]['cost_center'] ?? 'none'),
      MapEntry(tr('Description'), expenses[index]['description'] ?? 'none'),
    ];
  }

  List<String> get expenseListNames => [
        tr('Expense Date'),
        tr('Expense Claim Type'),
        tr('Default Account'),
        tr('Amount'),
        tr('Sanctioned Amount'),
        tr('Cost Center'),
        tr('Description'),
      ];

  List<String> expenseListValues(int index) {
    return [
      _expenses[index]['expense_date'] ?? tr('none'),
      _expenses[index]['expense_type'] ?? tr('none'),
      _expenses[index]['default_account'] ?? tr('none'),
      currency(_expenses[index]['amount']),
      currency(_expenses[index]['sanctioned_amount']),
      _expenses[index]['cost_center'] ?? tr('none'),
      _expenses[index]['description'] ?? tr('none'),
    ];
  }
}
