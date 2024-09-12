import 'package:equatable/equatable.dart';


class ItemEntity extends Equatable {
  final String name,
      itemName,
      itemCode,
      itemGroup,
      uom,
      imageUrl,
      barCode,
      itemTaxTemplate,
      stockUom
      ;
  final double netRate, priceListRate,taxPercent, qty;

  const ItemEntity({
    required this.name,
    required this.itemName,
    required this.itemCode,
    required this.uom,
    required this.imageUrl,
    required this.itemGroup,
    required this.netRate,
    required this.priceListRate,
    required this.barCode,
    required this.itemTaxTemplate,
    required this.taxPercent,
    required this.qty,
    required this.stockUom
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
        barCode,
        itemTaxTemplate,
        taxPercent,
        qty,
        stockUom,
      ];
}
