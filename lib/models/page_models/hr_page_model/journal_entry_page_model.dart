import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';

class JournalEntryPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  JournalEntryPageModel(this.context, this.data):
        _accounts = List<Map<String, dynamic>>.from(data['accounts'] ?? [])..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  final List<Map<String, dynamic>> _accounts;
  List<Map<String, dynamic>> get accounts => _accounts;

  final List<Tab> tabs = const [
    Tab(text: 'Accounts'),
  ];


  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Entry Type"): data['voucher_type'] ?? tr('none'),
        tr("Posting Date"): reverse(data['posting_date']),
      },

    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Total Debit"): data['total_debit'].toString(),
        tr("Total Credit"): data['total_credit'].toString(),
      },
      {
        tr("Account Balance"): data['balance'].toString(),
        tr("Total Amount"): data['total_amount'].toString(),
      },
      {
        tr("Total Amount in Words"): data['total_amount_in_words']?? tr('none') ,
      },
{
  tr("Remark"): data['remark'].toString(),

},
      {
        tr("Reference Number"): data['cheque_no']?? tr('none'),
        tr("Reference Date"): data['cheque_date']?? tr('none'),
      },


      {
        tr("User Remark"): data['user_remark'] ?? tr('none'),
        tr("Mode of Payment"): data['mode_of_payment']?? tr('none'),
      },

    ];
  }



  List<MapEntry<String, String>> accountCardValues(int index) {
    return [
      MapEntry(tr('Account Type'), accounts[index]['account_type'] ?? 'none'),
      MapEntry(tr('Debit'), currency(accounts[index]['debit_in_account_currency'])),
      MapEntry(tr('Credit'),  currency(accounts[index]['credit_in_account_currency'])),
    ];
  }

  List<String> get accountListNames =>
      [
        tr('Balance'),
        tr('Parent Type'),
        tr('Account'),
        tr('Account Type'),
        tr('Party Type'),
        tr('Party'),
        tr('Party Balance'),
        tr('Cost Center'),
        tr('Account Currency'),
        tr('Exchange Rate'),
        tr('Debit In Account Currency'),
        tr('Debit'),
        tr('Credit In Account Currency'),
        tr('Credit '),
        tr('Is Advance'),
      ];

  List<String> accountListValues(int index) {
    return [
      _accounts[index]['balance'] ?? tr('none'),
      _accounts[index]['parenttype'] ?? tr('none'),
      _accounts[index]['account'] ?? tr('none'),
      _accounts[index]['account_type'] ?? tr('none'),
      _accounts[index]['party_type'] ?? tr('none'),
      _accounts[index]['party'] ?? tr('none'),
      currency(_accounts[index]['party_balance']),
      _accounts[index]['cost_center'] ?? tr('none'),
      _accounts[index]['account_currency'] ?? tr('none'),
      currency(_accounts[index]['exchange_rate']),
      currency(_accounts[index]['debit_in_account_currency']),
      currency(_accounts[index]['debit']),
      currency(_accounts[index]['credit_in_account_currency']),
      currency(_accounts[index]['credit']),
      _accounts[index]['is_advance'] ?? tr('none'),

    ];
  }


}
