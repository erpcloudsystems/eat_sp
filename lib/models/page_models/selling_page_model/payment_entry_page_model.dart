import 'package:easy_localization/easy_localization.dart';

import '../model_functions.dart';

class PaymentEntryPageModel {
  final Map<String, dynamic> data;

  const PaymentEntryPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      if (data['payment_type'] != 'Internal Transfer')
        {
          tr("Party Type"): data['party_type'] ?? tr('none'),
          tr("Party"): data['party'] ?? tr('none')
        },
      if (data['payment_type'] != 'Internal Transfer')
        {tr("Party Name"): data['party_name'] ?? tr('none')},
      {
        tr("Date"): data['posting_date'] != null
            ? reverse(data['posting_date'])
            : tr('none'),
        tr("Status"): data['status'] ?? tr('none')
      },
      {
        tr("Reference Date"): data['reference_date'] != null
            ? reverse(data['reference_date'])
            : tr('none'),
        tr("Payment Type"): data['payment_type'] ?? tr('none')
      },
      {
        tr("Mode Of Payment"): data['mode_of_payment'] ?? tr('none'),
        tr("Account Paid From"): data['paid_from'] ?? tr('none')
      },
      {
        if (data['payment_type'] == 'Internal Transfer')
          tr('Mode Of Payment 2'): data['mode_of_payment_2'] ?? tr('none'),
        if (data['payment_type'] == 'Receive')
          tr('Paid To Account Balance'):
              currency(data['paid_to_account_balance'])
        else
          tr('Paid From Account Balance'):
              currency(data['paid_from_account_balance'])
      },
      {
        tr("Account Paid To"): data['paid_to'] ?? tr('none'),
        tr("Paid Amount"): currency(data['paid_amount'])
      },
    ];
  }
}
