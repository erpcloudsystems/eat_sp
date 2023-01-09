import 'package:next_app/models/list_models/list_model.dart';

class ItemTableModel extends ListModel<ItemModel> {
  ItemTableModel(List<ItemModel>? list) : super(list);

  factory ItemTableModel.fromJson(Map<String, dynamic> json) {
    var _list = <ItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new ItemModel.fromJson(v));
      });
    }
    return ItemTableModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson).toList();
    return data;
  }
}

class ItemModel {
  final String itemCode;
  final String itemName;
   String stockUom;
  final String group;
  final String imageUrl;

   ItemModel(
      {required this.imageUrl,
      required this.itemCode,
      required this.itemName,
      required this.stockUom,
      required this.group});

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return ItemModel(
      itemCode: json['item_code'] ?? 'none',
      itemName: json['item_name'] ?? 'none',
      stockUom: json['uom'] ?? 'none',
      imageUrl: json['image'] ?? 'none',
      group: json['item_group'] ?? 'none',
    );
  }

  Map<String, dynamic> get toJson {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_code'] = this.itemCode;
    data['item_name'] = this.itemName;
    data['uom'] = this.stockUom;
    data['item_group'] = this.group;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is ItemModel && this.itemCode == other.itemCode;

  @override
  int get hashCode => itemCode.hashCode;
}

class ItemSelectModel extends ItemModel {
  num rate;
  double netRate;
  double priceListRate;
  double vat;
  final double taxPercent;
  int _qty = 0;

  final bool _enableEdit;

  bool get enableEdit => _enableEdit;

  //old double get total => _qty * rate.toDouble();
  double get total => _qty * priceListRate.toDouble();
  double get grandTotal => _qty * netRate.toDouble();

  int get qty => _qty;

  set qty(int value) => _qty = value;

  factory ItemSelectModel.fromJson(Map<String, dynamic> json) {
    final item = ItemSelectModel(
      ItemModel.fromJson(json),
      vat: double.tryParse((json['item_tax_template']?? (json['tax_percent']?? 0).toString())) ?? 0 ,
      netRate: json['net_rate'] ?? 9999999999,
      rate: json['price_list_rate'] ?? 88888888,
      priceListRate: json['price_list_rate'] ?? 77777777,
      taxPercent:double.tryParse((json['item_tax_template']?? (json['tax_percent']?? 0).toString())) ?? 0 ,
      enableEdit: true, // (json['price_list_rate'] ?? 0) <= 0,
    );
    if (json['qty'] != null) item.qty = (json['qty'] as double).toInt();
    return item;
  }

  ItemSelectModel(ItemModel itemModel,
      {required this.rate,
      required this.vat,
      required this.netRate,
      required this.priceListRate,
      required this.taxPercent,
      required bool enableEdit})
      : _enableEdit = enableEdit,
        super(
            itemName: itemModel.itemName,
            itemCode: itemModel.itemCode,
            imageUrl: itemModel.imageUrl,
            stockUom: itemModel.stockUom,
            group: itemModel.group);

  @override
  Map<String, dynamic> get toJson => {
        "item_code": itemCode,
        "item_name": itemName,
        "qty": _qty,
        "uom": stockUom,
        "rate": rate
      };

  @override
  bool operator ==(covariant ItemModel other) {
    return other.itemName == itemName;
  }

  @override
  int get hashCode => itemName.hashCode;
}

//For OpportunityForm
class ItemQuantity extends ItemModel {
  int qty;
  double rate;
  double total;
  String actualQty;

  ItemQuantity(ItemModel itemModel, {this.qty=0, this.rate =0.0, this.total=0.0,this.actualQty=''})
      : super(
            itemName: itemModel.itemName,
            itemCode: itemModel.itemCode,
            imageUrl: itemModel.imageUrl,
            stockUom: itemModel.stockUom,
            group: itemModel.group);

  @override
  Map<String, dynamic> get toJson => {
        "item_code": itemCode,
        "item_name": itemName,
        "qty": qty,
        "rate": rate,
        "amount": total,
        "uom": stockUom
      };
}
