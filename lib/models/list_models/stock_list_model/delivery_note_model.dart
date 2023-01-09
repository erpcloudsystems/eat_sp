import 'package:next_app/models/list_models/list_model.dart';

class DeliveryNoteModel extends ListModel<DeliveryNoteItemModel> {
  List<DeliveryNoteItemModel>? deliveryNoteItemModel;

  DeliveryNoteModel(List<DeliveryNoteItemModel>? list) : super(list);

  factory DeliveryNoteModel.fromJson(Map<String, dynamic> json) {
    var _list = <DeliveryNoteItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new DeliveryNoteItemModel.fromJson(v));
      });
    }
    return DeliveryNoteModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class DeliveryNoteItemModel {
  final String id;
  final String customer;
  final String territory;
  final DateTime postingDate;
  final String setWarehouse;
  final String currency;
  final String status;

  DeliveryNoteItemModel(
      {required this.id,
       required this.postingDate,
       required this.customer,
       required this.setWarehouse,
       required this.currency,
       required this.territory,
       required this.status});

  factory DeliveryNoteItemModel.fromJson(Map<String, dynamic> json) {
    return DeliveryNoteItemModel( id : json['name']??'none',
    postingDate : DateTime.parse(json['posting_date']??'none'),
    customer : json['customer']??'none',
    setWarehouse : json['set_warehouse']??'none',
      currency : json['currency']??'none',
    territory : json['territory']??'none',
    status : json['status']??'none',);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['posting_date'] = this.postingDate;
    data['customer'] = this.customer;
    data['set_warehouse'] = this.setWarehouse;
    data['currency'] = this.currency;
    data['territory'] = this.territory;
    data['status'] = this.status;
    return data;
  }
}