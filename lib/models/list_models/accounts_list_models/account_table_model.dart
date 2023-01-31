import 'package:uuid/uuid.dart';

import '../list_model.dart';

class AccountTableModel extends ListModel<AccountModel> {
  AccountTableModel(List<AccountModel>? list) : super(list);

  factory AccountTableModel.fromJson(Map<String, dynamic> json) {
    var _list = <AccountModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new AccountModel.fromJson(v));
      });
    }
    return AccountTableModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson).toList();
    return data;
  }
}

class AccountModel {
  String id;
  String account;
  String accountType;
  String balance;
  String bankAccount;
  String partyType;
  String party;
  double debitInAccountCurrency;
  double creditInAccountCurrency;


  AccountModel(
      {
        required this.id,
        required this.account,
        required this.accountType,
        required this.balance,
        required this.bankAccount,
        required this.partyType,
        required this.party,
        required this.debitInAccountCurrency,
        required this.creditInAccountCurrency,
      });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] ?? Uuid().v1().toString(),
      account: json['account'] ?? '',
      accountType: json['account_type'] ?? '',
      balance: json['balance'] ?? 0.0,
      bankAccount: json['bank_account'] ?? '',
      partyType: json['party_type']?? '',
      party: json['party'] ?? '',
      debitInAccountCurrency: json['debit_in_account_currency'] ?? 0.0,
      creditInAccountCurrency: json['credit_in_account_currency'] ?? 0.0,
    );
  }

  Map<String, dynamic> get toJson {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['account_type'] = this.accountType;
    data['balance'] = this.balance;
    data['bank_account'] = this.bankAccount;
    data['party_type'] = this.partyType;
    data['party'] = this.party;
    data['debit_in_account_currency'] = this.debitInAccountCurrency;
    data['credit_in_account_currency'] = this.creditInAccountCurrency;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is AccountModel && this.account == other.account;

  @override
  int get hashCode => account.hashCode;

}



//class AccountSelectModel extends AccountModel {
// num rate;
// double netRate;
// double vat;
// final double taxPercent;
// int _qty = 0;
//
// final bool _enableEdit;
//
// bool get enableEdit => _enableEdit;
//
// double get total => _qty * rate.toDouble();
//
// int get qty => _qty;
//
// set qty(int value) => _qty = value;
//
//   factory AccountSelectModel.fromJson(Map<String, dynamic> json) {
//     final item = AccountSelectModel(
//       AccountModel.fromJson(json),
//       vat: json['vat_value'] ?? 0,
//       netRate: json['net_rate'] ?? 0,
//       rate: json['price_list_rate'] ?? 0,
//       // item_tax_template
//       taxPercent: json['tax_percent'] ?? 0,
//       enableEdit: true, // (json['price_list_rate'] ?? 0) <= 0,
//     );
//     if (json['qty'] != null) item.qty = (json['qty'] as double).toInt();
//     return item;
//   }
//
//   AccountSelectModel(AccountModel itemModel,
//       {required this.rate,
//         required this.vat,
//         required this.netRate,
//         required this.taxPercent,
//         required bool enableEdit})
//       : _enableEdit = enableEdit,
//         super(
//           itemName: itemModel.itemName,
//           itemCode: itemModel.itemCode,
//           imageUrl: itemModel.imageUrl,
//           stockUom: itemModel.stockUom,
//           group: AccountModel.group);
//
//   @override
//   Map<String, dynamic> get toJson => {
//     "item_code": itemCode,
//     "item_name": itemName,
//     "qty": _qty,
//     "uom": stockUom,
//     "rate": rate
//   };
//
//   @override
//   bool operator ==(covariant ItemModel other) {
//     return other.itemName == itemName;
//   }
//
//   @override
//   int get hashCode => itemName.hashCode;
// }

// class AccountQuantity extends AccountModel {
//   int qty;
//
//   AccountQuantity(AccountModel itemModel, {required this.qty})
//       : super(
//       itemName: AccountModel.itemName,
//       itemCode: itemModel.itemCode,
//       imageUrl: itemModel.imageUrl,
//       stockUom: itemModel.stockUom,
//       group: itemModel.group);
//
//   @override
//   Map<String, dynamic> get toJson => {
//     "item_code": itemCode,
//     "item_name": itemName,
//     "qty": qty,
//     "uom": stockUom
//   };
// }
