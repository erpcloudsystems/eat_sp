import '../list_model.dart';

class JournalEntryListModel extends ListModel<JournalEntryItemModel> {
  JournalEntryListModel(List<JournalEntryItemModel>? list) : super(list);

  factory JournalEntryListModel.fromJson(Map<String, dynamic> json) {
    var _list = <JournalEntryItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new JournalEntryItemModel.fromJson(v));
      });
    }
    return JournalEntryListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class JournalEntryItemModel {
  final String id;
  final String voucherType;
  final DateTime postingDate;
  final double totalDebit;
  final double totalCredit;
  final String modeOfPayment;
  final String chequeNo;
  final DateTime chequeDate;
  final String remark;
  final int docStatus;

  JournalEntryItemModel({
    required this.id,
    required this.voucherType,
    required this.postingDate,
    required this.totalDebit,
    required this.totalCredit,
    required this.modeOfPayment,
    required this.chequeNo,
    required this.chequeDate,
    required this.remark,
    required this.docStatus,
  });

  factory JournalEntryItemModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryItemModel(
      id: json['name'] ?? 'none',
      voucherType: json['voucher_type'] ?? 'none',
      postingDate: DateTime.parse(json['posting_date'] ?? "2001-01-01"),
      totalDebit: json['total_debit'] ?? 'none',
      totalCredit: json['total_credit'] ?? 'none',
      modeOfPayment: json['mode_of_payment'] ?? 'none',
      chequeNo: json['cheque_no'] ?? 'none',
      chequeDate: DateTime.parse(json['cheque_date'] ?? "2001-01-01"),
      remark: json['remark'] ?? 'none',
      docStatus: json['docstatus'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['voucher_type'] = this.voucherType;
    data['posting_date'] = this.postingDate;
    data['total_debit'] = this.totalDebit;
    data['total_credit'] = this.totalCredit;
    data['mode_of_payment'] = this.modeOfPayment;
    data['cheque_no'] = this.chequeNo;
    data['cheque_date'] = this.chequeDate;
    data['remark'] = this.remark;
    data['docstatus'] = this.docStatus;
    return data;
  }
}
