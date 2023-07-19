import 'package:NextApp/new_version/modules/new_item/data/models/item_filter.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/api_constance.dart';
import '../../../../core/network/dio_helper.dart';
import '../models/item_group_model.dart';
import '../models/item_model.dart';

abstract class BaseItemsDataSource {
  Future<List<NewItemModel>> getItemList(ItemsFilter itemFilter);

  Future<List<ItemGroupModel>> getItemGroupList(ItemsFilter itemFilter);
}

class ItemDataSourceByDio implements BaseItemsDataSource {
  final BaseDioHelper _dio;

  ItemDataSourceByDio(this._dio);

  @override
  Future<List<NewItemModel>> getItemList(ItemsFilter itemFilter) async {
    final response = await _dio.get(
      endPoint: ApiConstance.generalItemListEndPoint,
      query: {
        'item_group': itemFilter.itemGroup,
        'price_list': itemFilter.priceList,
      },
    ) as Response;

    final itemList = List.from(response.data['message'])
        .map((e) => NewItemModel.fromJson(e))
        .toList();

    return itemList;
  }

  @override
  Future<List<ItemGroupModel>> getItemGroupList(ItemsFilter itemFilter) async {
    final response = await _dio.get(
      endPoint: ApiConstance.getItemGroup,
      query: {
        'item_name': itemFilter.itemGroup,
        'search_text': itemFilter.searchText,
      },
    ) as Response;

    final itemGroupList = List.from(response.data['message'])
        .map((e) => ItemGroupModel.fromJson(e))
        .toList();

    return itemGroupList;
  }
}
