import '../list_model.dart';

class BomListModel extends ListModel<BomItemModel> {
  BomListModel(List<BomItemModel>? list) : super(list);

  factory BomListModel.fromJson(Map<String, dynamic> json) {
    List<BomItemModel> list = [];
    if (json['message'] != null) {
      json['message'].forEach((v) {
        list.add(BomItemModel.fromJson(v));
      });
    }
    return BomListModel(list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['data'] = super.list.map((v) => v.toJson()).toList();
    return data;
  }
}

class BomItemModel {
  final double quantity;
  final String name, item, itemName, uom, project, rateOfMaterialsBasedOn, currency;
  final int setRateOfSubAssemblyItemBasedOnBom,
      allowAlternativeItem,
      inspectionRequired,
      withOperations,
      isDefault;

  BomItemModel({
    required this.setRateOfSubAssemblyItemBasedOnBom,
    required this.rateOfMaterialsBasedOn,
    required this.allowAlternativeItem,
    required this.inspectionRequired,
    required this.withOperations,
    required this.isDefault,
    required this.itemName,
    required this.currency,
    required this.quantity,
    required this.project,
    required this.name,
    required this.item,
    required this.uom,
  });

  factory BomItemModel.fromJson(Map<String, dynamic> json) => BomItemModel(
        setRateOfSubAssemblyItemBasedOnBom:
            json['set_rate_of_sub_assembly_item_based_on_bom'] ?? 0,
        allowAlternativeItem: json['allow_alternative_item'] ?? 0,
        inspectionRequired: json['inspection_required'] ?? 0,
        rateOfMaterialsBasedOn: json['rm_cost_as_per'] ?? 'none',
        withOperations: json['with_operations'] ?? 0,
        isDefault: json['is_default'] ?? 0,
        itemName: json['item_name'] ?? 'none',
        currency: json['currency'] ?? 'EGP',
        quantity: json['quantity'] ?? 1.0,
        project: json['project'] ?? 'none',
        name: json['name'] ?? 'none',
        item: json['item'] ?? 'none ',
        uom: json['uom'] ?? 'none',
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['item'] = item;
    data['uom'] = uom;
    data['project'] = project;
    data['quantity'] = quantity;
    data['currency'] = currency;
    data['item_name'] = itemName;
    data['is_default'] = isDefault;
    data['with_operations'] = withOperations;
    data['rm_cost_as_per'] = rateOfMaterialsBasedOn;
    data['inspection_required'] = inspectionRequired;
    data['allow_alternative_item'] = allowAlternativeItem;
    data['set_rate_of_sub_assembly_item_based_on_bom'] =
        setRateOfSubAssemblyItemBasedOnBom;
    return data;
  }
}
