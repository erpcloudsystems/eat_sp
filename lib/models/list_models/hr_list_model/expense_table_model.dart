import '../list_model.dart';
import 'package:uuid/uuid.dart';

class ExpenseTableModel extends ListModel<ExpenseModel> {
  ExpenseTableModel(List<ExpenseModel>? list) : super(list);

  factory ExpenseTableModel.fromJson(Map<String, dynamic> json) {
    var _list = <ExpenseModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new ExpenseModel.fromJson(v));
      });
    }
    return ExpenseTableModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson).toList();
    return data;
  }
}

class ExpenseModel {
   String id;
   String expenseName;
   String expenseDate;
   String expenseClaimType;
   double amount;
   double sanctionedAmount;
   String description;
   String costCenter;


   ExpenseModel(
      {
        required this.id,
        required this.expenseName,
        required this.expenseDate,
        required this.expenseClaimType,
        required this.amount,
        required this.sanctionedAmount,
        required this.description,
        required this.costCenter,
      });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? Uuid().v1().toString(),
      expenseName: json['name'] ?? '',
      expenseDate: DateTime.parse(json['expense_date'] ?? 'none').toString(),
      expenseClaimType: json['expense_type'] ?? 'none',
      amount: json['amount'] ?? 0.0,
      sanctionedAmount: json['sanctioned_amount'] ?? 0.0,
        description: json['description'] ?? 'none',
      costCenter: json['cost_center'] ?? 'none',
    );
  }

  Map<String, dynamic> get toJson {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['name'] = this.expenseName;
    data['expense_date'] = this.expenseDate;
    data['expense_type'] = this.expenseClaimType;
    data['amount'] = this.amount;
    data['sanctioned_amount'] = this.sanctionedAmount;
    data['description'] = this.description;
    data['cost_center'] = this.costCenter;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is ExpenseModel && this.expenseName == other.expenseName;

  @override
  int get hashCode => expenseName.hashCode;

}



//class ExpenseSelectModel extends ExpenseModel {
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
//   factory ExpenseSelectModel.fromJson(Map<String, dynamic> json) {
//     final item = ExpenseSelectModel(
//       ExpenseModel.fromJson(json),
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
//   ExpenseSelectModel(ExpenseModel itemModel,
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
//           group: ExpenseModel.group);
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

// class ExpenseQuantity extends ExpenseModel {
//   int qty;
//
//   ExpenseQuantity(ExpenseModel itemModel, {required this.qty})
//       : super(
//       itemName: ExpenseModel.itemName,
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
