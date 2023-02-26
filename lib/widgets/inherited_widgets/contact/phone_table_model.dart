import '../../../models/list_models/list_model.dart';
import 'package:uuid/uuid.dart';

class PhoneTableModel extends ListModel<PhoneModel> {
  PhoneTableModel(List<PhoneModel>? list) : super(list);

  factory PhoneTableModel.fromJson(Map<String, dynamic> json) {
    var _list = <PhoneModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new PhoneModel.fromJson(v));
      });
    }
    return PhoneTableModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson).toList();
    return data;
  }
}

class PhoneModel {
  String id;
  String phone;
  int isPrimaryPhone;
  int isPrimaryMobile;

  PhoneModel({
    required this.id,
    required this.phone,
    required this.isPrimaryPhone,
    required this.isPrimaryMobile,
  });

  factory PhoneModel.fromJson(Map<String, dynamic> json) {
    return PhoneModel(
      id: json['id'] ?? Uuid().v1().toString(),
      phone: json['phone'] ?? '',
      isPrimaryPhone: json['is_primary_phone'] ?? 0,
      isPrimaryMobile: json['is_primary_mobile_no'] ?? 0,
    );
  }

  Map<String, dynamic> get toJson {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['is_primary_phone'] = this.isPrimaryPhone;
    data['is_primary_mobile_no'] = this.isPrimaryMobile;

    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is PhoneModel && this.phone == other.phone;

  @override
  int get hashCode => phone.hashCode;
}
