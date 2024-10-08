import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../model_functions.dart';

class BomPageModel {
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> items;

  BomPageModel(this.data)
      : items = List<Map<String, dynamic>>.from(data['items'] ?? [])
          ..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr('Item'): data['item'] ?? tr('none')
      },
      {
        tr('Item Name'): data['item_name'] ?? tr('none'),
      },
      {
        tr('Quantity'): (data['quantity'] ?? tr('none')).toString(),
        tr('UOM'): data['uom'] ?? tr('none')
      },
      {
        tr('Project'): data['Project'] ?? tr('none'),
        tr('Currency'): data['currency'] ?? tr('none'),
      },
      {
        tr('Is Default'): data['is_default'].toString(),
        tr(StringsManager.rateOfMaterialsBasedOn):
            (data['rm_cost_as_per'] ?? tr('none')).toString(),
      },
      {
        tr(StringsManager.allowAlternativeItem):
            (data['allow_alternative_item'] ?? tr('none')).toString(),
        tr(StringsManager.withOperations):
            (data['with_operations'] ?? tr('none')).toString()
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr('Description'): data['description'] ?? tr('none'),
      },
    ];
  }

  List<MapEntry<String, String>> getItemCard(int index) {
    return [
      MapEntry(tr("Item Code"), items[index]['item_code'] ?? tr('none')),
      MapEntry(tr("UOM"), items[index]['uom'] ?? tr('none')),
      MapEntry(tr("Item Group"), items[index]['item_group'] ?? tr('none')),
         MapEntry(
          tr('Quantity'),
          items[index]['qty'] == null
              ? tr('none')
              : (items[index]['qty'] as double).toStringAsFixed(0)),
    ];
  }

  List<String> get subList1Names {
    return [
      tr('Item Code'),
      tr('Item Name'),
      tr('Item Group'),
      tr('Quantity'),
      tr('Brand'),
      tr('Stock UOM'),
      tr('UOM'),
      tr('Rate'),
    ];
  }

  List<String> subList1Item(int index) {
    return [
      items[index]['item_code'] ?? tr('none'),
      items[index]['item_name'] ?? tr('none'),
      items[index]['item_group'] ?? tr('none'),
      (items[index]['qty'] ?? 0).toString(),
      items[index]['brand'] ?? tr('none'),
      items[index]['stock_uom'] ?? tr('none'),
      items[index]['uom'] ?? tr('none'),
      currency(items[index]['rate']),
    ];
  }
}
