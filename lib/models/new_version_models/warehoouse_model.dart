class WarehouseModel {
  final String? docName;
  final String? applicableFor;
  final int? isDefault;

  WarehouseModel({this.docName, this.applicableFor,this.isDefault});

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      docName: json['doc'] ?? '',
      applicableFor: json['applicable_for'] ?? '',
      isDefault: json['is_default']?? 0,
    );
  }
}
