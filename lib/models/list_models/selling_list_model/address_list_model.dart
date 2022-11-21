import 'package:next_app/models/list_models/list_model.dart';

class AddressListModel extends ListModel<AddressItemModel> {
  AddressListModel(List<AddressItemModel>? list) : super(list);

  factory AddressListModel.fromJson(Map<String, dynamic> json) {
    var _list = <AddressItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new AddressItemModel.fromJson(v));
      });
    }
    return AddressListModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class AddressItemModel {
  final String id;
  final String addressTitle;
  final String addressType;
  final String addressLine1;
  final String city;
  final String country;
  final String linkDocType;
  final String linkName;
  final String status;

  AddressItemModel(
      {required this.id,
        required this.addressTitle,
        required this.addressType,
        required this.addressLine1,
        required this.city,
        required this.country,
        required this.linkDocType,
        required this.linkName,
        required this.status,
      });

  factory AddressItemModel.fromJson(Map<String, dynamic> json) {
    return AddressItemModel(
      id: json['name']??'none',
      addressTitle: json['address_title']??'none',
      addressType: json['address_type']??'none',
      addressLine1: json['address_line1']??'none',
      city: json['city']??'none',
      country: json['country']??'none',
      linkDocType: json['link_doctype']??'none',
      linkName: json['link_name']??'none',
      status: 'Random',
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.id;
    data['address_title'] = this.addressTitle;
    data['address_type'] = this.addressType;
    data['address_line1'] = this.addressLine1;
    data['city'] = this.city;
    data['country'] = this.country;
    data['link_doctype'] = this.linkDocType;
    data['link_name'] = this.linkName;
    return data;
  }
}
