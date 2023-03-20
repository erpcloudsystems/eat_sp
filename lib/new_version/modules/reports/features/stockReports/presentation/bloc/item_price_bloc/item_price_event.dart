part of 'item_price_bloc.dart';

@immutable
abstract class ItemPriceEvent extends Equatable {
  const ItemPriceEvent();

  @override
  List<Object> get props => [];
}

class GetItemPriceEvent extends ItemPriceEvent {
  final ItemPriceFilters itemPriceFilters;

   const GetItemPriceEvent({
    required this.itemPriceFilters,
  });

  @override
  List<Object> get props => [
        GetItemPriceEvent,
      ];
}

class ResetItemPriceEvent extends ItemPriceEvent {
  const ResetItemPriceEvent();
}
