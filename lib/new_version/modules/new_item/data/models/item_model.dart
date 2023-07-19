import 'package:NextApp/new_version/modules/new_item/domain/entities/item_entity.dart';
import 'package:equatable/equatable.dart';

class NewItemModel extends ItemEntity {
  const NewItemModel({
    required super.name,
    required super.itemName,
    required super.itemCode,
    required super.uom,
    required super.imageUrl,
    required super.itemGroup,
    required super.netRate,
    required super.priceListRate,
    required super.uomList,
    required super.barCode,
  });

  factory NewItemModel.fromJson(Map<String, dynamic> json) => NewItemModel(
        name: json['name'] ?? 'none',
        uom: json['uom'] ?? 'none',
        imageUrl: json['image'] ?? 'none',
        itemCode: json['item_code'] ?? 'none',
        barCode: json['barcode'] ?? 'none',
        itemName: json['item_name'] ?? 'none',
        itemGroup: json['item_group'] ?? 'none',
        netRate: json['net_rate'] ?? 0,
        priceListRate: json['price_list_rate'] ?? 0,
        uomList: List.from(
          json['uom_list'].map(
            (e) => UomModel.fromJson(e),
          ),
        ),
      );

  @override
  List<Object?> get props => [
        name,
        uom,
        imageUrl,
        itemCode,
        itemName,
        itemGroup,
        netRate,
        priceListRate,
        barCode,
      ];
}

class UomModel extends Equatable {
  final String name, uom;
  final double conversionFactor;

  const UomModel({
    required this.name,
    required this.uom,
    required this.conversionFactor,
  });
  factory UomModel.fromJson(Map<String, dynamic> json) => UomModel(
        name: json['name'] ?? 'none',
        uom: json['uom'] ?? 'none',
        conversionFactor: json['conversion_factor'] ?? 0,
      );
  @override
  List<Object?> get props => [
        name,
        uom,
        conversionFactor,
      ];
}