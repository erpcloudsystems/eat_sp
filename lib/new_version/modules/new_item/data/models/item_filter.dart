import 'package:equatable/equatable.dart';

class ItemsFilter extends Equatable {
  final String? itemGroup;
  final int startKey;
  final String? searchText;
  final String? priceList;
  final int? allowSales;
  final String? warehouse;

  const ItemsFilter(
      {this.itemGroup,
      this.startKey = 0,
      this.searchText,
      this.priceList,
      this.allowSales,
      this.warehouse});

  @override
  List<Object?> get props => [
        itemGroup,
        startKey,
        searchText,
        priceList,
        allowSales,
        warehouse,
      ];
}
