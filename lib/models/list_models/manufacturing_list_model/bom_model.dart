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
  String? name, item, itemName, uom, project, currency;
  int? quantity,
      setRateOfSubAssemblyItemBasedOnBom,
      rateOfMaterialsBasedOn,
      allowAlternativeItem,
      inspectionRequired,
      withOperations,
      isDefault;

  BomItemModel({
    this.setRateOfSubAssemblyItemBasedOnBom,
    this.rateOfMaterialsBasedOn,
    this.allowAlternativeItem,
    this.inspectionRequired,
    this.withOperations,
    this.isDefault,
    this.itemName,
    this.currency,
    this.quantity,
    this.project,
    this.name,
    this.item,
    this.uom,
  });

  BomItemModel.fromJson(Map<String, dynamic> json) {
    setRateOfSubAssemblyItemBasedOnBom =
        json['set_rate_of_sub_assembly_item_based_on_bom'];
    allowAlternativeItem = json['allow_alternative_item'];
    inspectionRequired = json['inspection_required'];
    rateOfMaterialsBasedOn = json['rm_cost_as_per'];
    withOperations = json['with_operations'];
    isDefault = json['is_default'];
    itemName = json['item_name'];
    currency = json['currency'];
    quantity = json['quantity'];
    project = json['project'];
    name = json['name'];
    item = json['item'];
    uom = json['uom'];
  }

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
