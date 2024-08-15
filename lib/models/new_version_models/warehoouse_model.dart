class WarehouseModel {
  final String? docName;
  final String? applicableFor;

  WarehouseModel({this.docName, this.applicableFor});

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      docName: json['doc'] ?? '',
      applicableFor: json['applicable_for'] ?? '',
    );
  }
}
