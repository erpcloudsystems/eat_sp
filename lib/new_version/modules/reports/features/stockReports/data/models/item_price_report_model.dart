import 'package:NextApp/new_version/modules/reports/features/stockReports/domain/entities/item_price_entity.dart';

class ItemPriceReportModel extends ItemPriceEntity {
  const ItemPriceReportModel({
    required super.priceList,
    required super.itemName,
    required super.itemGroup,
    required super.itemCode,
    required super.currency,
    required super.priceListRate,
  });
  factory ItemPriceReportModel.fromJson(Map<String, dynamic> json) =>
      ItemPriceReportModel(
        priceList: json['price_list'] ?? 'none',
        itemCode: json['item_code'] ?? 'none',
        currency: json['currency'] ?? 'none',
        itemName: json['item_name'] ?? 'none',
        itemGroup: json['item_group'] ?? 'none',
        priceListRate: json['price_list_rate'].toString(),
      );

  @override
  List<Object?> get props => [
        priceList,
        currency,
        priceListRate,
        itemCode,
        itemName,
        itemGroup,
      ];
}
