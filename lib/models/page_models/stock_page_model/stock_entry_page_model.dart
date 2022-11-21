import 'package:easy_localization/easy_localization.dart';

import '../model_functions.dart';

class StockEntryPageModel {
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> items;

  StockEntryPageModel(this.data)
      : items = List<Map<String, dynamic>>.from(data['items'] ?? [])
    ..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  List<Map<String, String>> get card1Items {
    return [
      {tr("Stock Entry Type"): data['stock_entry_type'] ?? tr('none'), tr("Purpose"): data['purpose'] ?? tr('none')},
      {tr("Date"): data['posting_date'] == null ? tr('none') : reverse(data['posting_date']), tr("Status"): data['status'] ?? tr('none')},
      {tr("From Warehouse"): data['from_warehouse'] ?? tr('none'), tr("To Warehouse"): data['to_warehouse'] ?? tr('none')},
      {tr("Project"): data['project'] ?? tr('none')}
    ];
  }

  List<MapEntry<String, String>> getItemCard(int index) {
    return [
      MapEntry(tr("Item Code"), items[index]['item_code'] ?? tr('none')),
      MapEntry(tr("Item Group"), items[index]['item_group'] ?? tr('none')),
      MapEntry(tr("UOM"), items[index]['uom'] ?? tr('none')),
      MapEntry(tr("Quantity"), items[index]['qty'].toString()),
      // MapEntry(tr("Rate"), currency(itemsList[index]['rate'])),
      // MapEntry(tr("Amount"), currency(itemsList[index]['amount'])),
    ];
  }

  List<String> get itemListNames {
    return [
      tr('Item Code'),
      tr('Item Name'),
      tr('Description'),
      tr('Item Group'),
      //    tr('Image'),
      tr('Quantity'),
      tr('Qty as per Stock UOM'),
      tr('Stock UOM'),
      tr('UOM'),
      tr('UOM Conversion Factor'),

      tr('Source Warehouse'),
      tr('Target Warehouse'),
      tr('Cost Center'),
      tr('Project'),
      tr('Actual Qty'),
      tr('Transferred Qty'),
    ];
  }

  List<String> itemListValues(int index) {
    return [
      data['items'][index]['item_code'] ?? tr('none'),
      data['items'][index]['item_name'] ?? tr('none'),
      data['items'][index]['description'] ?? tr('none'),
      data['items'][index]['item_group'] ?? tr('none'),
      //  data['items'][index]['image'] ,
      data['items'][index]['qty'].toString(),
      data['items'][index]['transfer_qty'].toString(),
      data['items'][index]['uom'] ?? tr('none'),
      data['items'][index]['uom'] ?? tr('none'),
      data['items'][index]['conversion_factor'].toString(),

      data['items'][index]['s_warehouse'] ?? tr('none'),
      data['items'][index]['t_warehouse'] ?? tr('none'),
      data['items'][index]['cost_center'] ?? tr('none'),
      data['items'][index]['project'] ?? tr('none'),
      data['items'][index]['actual_qty'].toString(),
      data['items'][index]['transferred_qty'].toString(),
    ];
  }
}
