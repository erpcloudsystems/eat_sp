import 'package:equatable/equatable.dart';

class ItemsFilter extends Equatable {
  String? itemGroup;
  final int startKey;
  String? searchText;
  String? priceList;

  ItemsFilter(
      {this.itemGroup, this.startKey = 0, this.searchText, this.priceList});

  @override
  List<Object?> get props => [
        itemGroup,
        startKey,
        searchText,
        priceList,
      ];
}
