import '../list_model.dart';

import '../../../service/service.dart';

class PaymentEntryModel extends ListModel<PaymentEntryItem> {
  PaymentEntryModel(List<PaymentEntryItem>? list) : super(list);

  factory PaymentEntryModel.fromJson(Map<String, dynamic> json) {
    var _list = <PaymentEntryItem>[];
    if (json['message'] != null) {
      print('⁉️ 000 ${json['message']}');
      json['message'].forEach((v) {
        _list.add(new PaymentEntryItem.fromJson(v));
      });
    }

    return PaymentEntryModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class PaymentEntryItem {
  final String id;
  final String partyName;
  final String paymentType;
  final String modeOfPayment;
  final String currency;
  final DateTime postingDate;
  final double paidAmount;
  final String status;

  PaymentEntryItem(
      {required this.id,
      required this.partyName,
      required this.postingDate,
      required this.modeOfPayment,
      required this.currency,
      required this.paymentType,
      required this.paidAmount,
      required this.status});


  factory PaymentEntryItem.fromJson(Map<String, dynamic> json) {
    return PaymentEntryItem(
      id: json['name'] ?? 'none',
      partyName: json['party_name'] ?? 'none',
      paymentType: json['payment_type'] ?? 'none',
      modeOfPayment: json['mode_of_payment'] ?? 'none',
      currency: json['currency'] ?? 'none',
      paidAmount: json['base_paid_amount'] ?? 'none',
      postingDate: DateTime.parse(json['posting_date'] ?? 'none'),
      status: json['status'] ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['party_name'] = this.partyName;
    data['posting_date'] = this.postingDate;
    data['mode_of_payment'] = this.modeOfPayment;
    data['currency'] = this.currency;
    data['payment_type'] = this.paymentType;
    data['base_paid_amount'] = this.paidAmount;
    data['status'] = this.status;
    return data;
  }
}
