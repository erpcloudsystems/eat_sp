import 'package:bloc/bloc.dart';
import '../../../../../../service/service.dart';
import '../../../../../core/network/api_constance.dart';
import '../../../data/models/item_filter.dart';
import '../../../data/models/item_model.dart';
import '../../../domain/entities/item_entity.dart';
part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  List<ItemEntity> items = [];
  bool hasReachedMax = false;

  Future getAllItems({required ItemsFilter itemFilter}) async {
    try {
      if (hasReachedMax) return;
      if (state is GettingItemsLoadingState || itemFilter.searchText != null) {
        emit(GettingItemsLoadingState());

        final response = await APIService().genericGet(
          ApiConstance.generalItemListEndPoint,
          {
            if (itemFilter.itemGroup != null)
              'item_group': itemFilter.itemGroup,
            'price_list': itemFilter.priceList,
            'page_length': ApiConstance.pageLength,
            if (itemFilter.allowSales != null)
              "allow_sales": itemFilter.allowSales,
            'start': itemFilter.startKey,
            if (itemFilter.searchText != null)
              'search_text': itemFilter.searchText,
            if (itemFilter.warehouse != null) 'warehouse': itemFilter.warehouse
          },
        );

        // Parse the 'message' array from the JSON response.
        final itemsList = List.from(response['message'])
            .map((e) => NewItemModel.fromJson(e))
            .toList();

        items = itemsList;
        emit(GetAllItemsSuccessfullyState(items));
      } else {
        final response = await APIService().genericGet(
          ApiConstance.generalItemListEndPoint,
          {
            'price_list': itemFilter.priceList,
            'page_length': ApiConstance.pageLength,
            if (itemFilter.allowSales != null)
              "allow_sales": itemFilter.allowSales,
            if (itemFilter.startKey != 0) 'start': items.length + 1,
            if (itemFilter.searchText != null)
              'search_text': itemFilter.searchText,
          },
        );
        final newItemList = List.from(response['message'])
            .map((e) => NewItemModel.fromJson(e))
            .toList();

        items = List.of(items)..addAll(newItemList);

        hasReachedMax = items.length < ApiConstance.pageLength;

        emit(GetAllItemsSuccessfullyState(items));
      }
    } catch (error) {
      emit(GettingAllItemsFailedState(error.toString()));
      print(error.toString());
    }
  }

  void resetItem() {
    emit(GettingItemsLoadingState());
    items = [];
    hasReachedMax = false;
  }
}
