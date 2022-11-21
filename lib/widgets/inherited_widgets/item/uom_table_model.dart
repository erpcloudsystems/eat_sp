import 'package:next_app/models/list_models/list_model.dart';
import 'package:uuid/uuid.dart';

class UOMTableModel extends ListModel<UOMModel> {
  UOMTableModel(List<UOMModel>? list) : super(list);

  factory UOMTableModel.fromJson(Map<String, dynamic> json) {
    var _list = <UOMModel>[];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        _list.add(new UOMModel.fromJson(v));
      });
    }
    return UOMTableModel(_list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = super.list.map((v) => v.toJson).toList();
    return data;
  }
}

class UOMModel {
  String id;
  String uom;
  double conversionFactor;



  UOMModel(
      {
        required this.id,
        required this.uom,
        required this.conversionFactor,

      });

  factory UOMModel.fromJson(Map<String, dynamic> json) {
    return UOMModel(
      id: json['id'] ?? Uuid().v1().toString(),
      uom: json['uom'] ?? '',
      conversionFactor: json['conversion_factor'] ?? 0.0,

    );
  }

  Map<String, dynamic> get toJson {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uom'] = this.uom;
    data['conversion_factor'] = this.conversionFactor;

    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is UOMModel && this.uom == other.uom;

  @override
  int get hashCode => uom.hashCode;

}


