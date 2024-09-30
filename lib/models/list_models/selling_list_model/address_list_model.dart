import '../list_model.dart';

class AddressListModel extends ListModel<AddressItemModel> {
  AddressListModel(List<AddressItemModel>? super.list);

  factory AddressListModel.fromJson(Map<String, dynamic> json) {
    var list = <AddressItemModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        list.add(AddressItemModel.fromJson(v));
      });
    }
    return AddressListModel(list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  final String addressCode;

  AddressItemModel({
    required this.id,
    required this.addressTitle,
    required this.addressType,
    required this.addressLine1,
    required this.city,
    required this.country,
    required this.linkDocType,
    required this.linkName,
    required this.status,
    required this.addressCode,
  });

  factory AddressItemModel.fromJson(Map<String, dynamic> json) {
    return AddressItemModel(
      id: json['name'] ?? 'none',
      addressTitle: json['address_title'] ?? 'none',
      addressType: json['address_type'] ?? 'none',
      addressLine1: json['address_line1'] ?? 'none',
      city: json['city'] ?? 'none',
      country: json['country'] ?? 'none',
      linkDocType: json['link_doctype'] ?? 'none',
      linkName: json['link_name'] ?? 'none',
      addressCode: json['custom_code'] ?? 'none',
      status: 'Random',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = id;
    data['address_title'] = addressTitle;
    data['address_type'] = addressType;
    data['address_line1'] = addressLine1;
    data['city'] = city;
    data['country'] = country;
    data['link_doctype'] = linkDocType;
    data['link_name'] = linkName;
    return data;
  }
}
