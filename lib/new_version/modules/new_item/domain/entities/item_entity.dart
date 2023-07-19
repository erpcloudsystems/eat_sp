import 'package:equatable/equatable.dart';

import '../../data/models/item_model.dart';

class ItemEntity extends Equatable {
  final String name, itemName, itemCode, itemGroup, uom, imageUrl ,barCode;
  final double netRate, priceListRate;
  final List<UomModel> uomList;

  const ItemEntity({
    required this.name,
    required this.itemName,
    required this.itemCode,
    required this.uom,
    required this.imageUrl,
    required this.itemGroup,
    required this.netRate,
    required this.priceListRate,
    required this.uomList,
    required this.barCode
  });
  @override
  List<Object?> get props => [
        name,
        itemCode,
        itemGroup,
        itemName,
        uom,
        imageUrl,
        netRate,
        priceListRate,
        uomList,
        barCode,
      ];
}