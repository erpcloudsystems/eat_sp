import 'package:equatable/equatable.dart';

class ItemPriceEntity extends Equatable {
  final String priceList,
      itemCode,
      itemGroup,
      itemName,
      currency,
      priceListRate;

  const ItemPriceEntity({
    required this.priceList,
    required this.itemName,
    required this.itemGroup,
    required this.itemCode,
    required this.currency,
    required this.priceListRate,
  });

  @override
  List<Object?> get props => [
        priceList,
        itemCode,
        itemGroup,
        itemName,
        currency,
        priceListRate,
      ];
}
