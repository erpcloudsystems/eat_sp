import 'package:next_app/models/list_models/list_model.dart';

class LoanApplicationListModel extends ListModel<LoanApplicationItemModel> {
  LoanApplicationListModel(List<LoanApplicationItemModel>? list) : super(list);

  factory LoanApplicationListModel.fromJson(Map<String, dynamic> json) {
    var _list = <LoanApplicationItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new LoanApplicationItemModel.fromJson(v));
      });
    }
    return LoanApplicationListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class LoanApplicationItemModel {
  final String id;
  final String applicantName;
  final String applicantType;
  final String applicant;
  final DateTime postingDate;
  final String loanType;
  final double loanAmount;
  final String status;

  LoanApplicationItemModel(
      {required this.id,
        required this.applicantName,
        required this.applicantType,
        required this.applicant,
        required this.postingDate,
        required this.loanType,
        required this.loanAmount,
        required this.status,
      });

  factory LoanApplicationItemModel.fromJson(Map<String, dynamic> json) {
    return LoanApplicationItemModel(
      id: json['name']??'none',
      applicantName: json['applicant_name']??'none',
      applicantType: json['applicant_type']??'none',
      applicant: json['applicant']??'none',
      postingDate: DateTime.parse(json['posting_date'] ?? 'none'),
      loanType: json['loan_type']??'none',
      loanAmount: json['loan_amount']?? 0.0,
      status: json['status']??'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['applicant_name'] = this.applicantName;
    data['applicant_type'] = this.applicantType;
    data['applicant'] = this.applicant;
    data['posting_date'] = this.postingDate;
    data['loan_type'] = this.loanType;
    data['loan_amount'] = this.loanAmount;
    data['status'] = this.status;
    return data;
  }
}
