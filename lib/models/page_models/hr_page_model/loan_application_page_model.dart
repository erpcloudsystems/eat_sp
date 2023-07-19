import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';

class LoanApplicationPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  LoanApplicationPageModel(this.context, this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Applicant Type"): data['applicant_type'] ?? tr('none'),
        tr("Applicant"): data['applicant'] ?? tr('none'),
      },
      {
        tr("Applicant Name"): data['applicant_name'] ?? tr('none'),
      },
      {
        tr("Posting Date"): reverse(data['posting_date']),
        tr('Status'): data['status'] ?? tr('none'),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Loan Type"): data['loan_type'] ?? tr('none'),
        tr("Is Term Loan"): data['is_term_loan'].toString(),
      },
      {
        tr("Loan Amount"): data['loan_amount'].toString(),
        tr("Is Secured Loan"): data['is_secured_loan'].toString(),
      },
      {
        tr("Rate of Interest"): "${data['rate_of_interest']} %",
        tr("Maximum Loan Amount"): data['maximum_loan_amount'].toString(),
      },
      {
        tr("Repayment Method"): data['repayment_method'] ?? tr('none'),
        tr("Total Payable Amount"): data['total_payable_amount'].toString(),
      },
      {
        tr("Return Amount"): data['return_amount'].toString(),
        tr("Total Payable Interest"): data['total_payable_interest'].toString(),
      },
      {
        tr("Description"): data['description'].toString(),
      },
    ];
  }
}
