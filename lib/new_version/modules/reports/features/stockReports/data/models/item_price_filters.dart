import 'package:equatable/equatable.dart';

class ItemPriceFilters extends Equatable {
  final String? priceList;
  final String? itemCode;
  final String? itemGroup;
  final int? startKey;

  const ItemPriceFilters({
    this.priceList,
    this.itemCode,
    this.itemGroup,
    this.startKey = 0,
  });

  @override
  List<Object?> get props => [
        priceList,
        itemCode,
        itemGroup,
        startKey,
      ];
}
