import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

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
    int qty = items[index]['qty'].toInt();
    return [
      MapEntry(tr("Item Code"), items[index]['item_code'] ?? tr('none')),
      MapEntry(tr("Item Group"), items[index]['item_group'] ?? tr('none')),
      MapEntry(tr("UOM"), items[index]['uom'] ?? tr('none')),
      MapEntry(tr("Quantity"), qty.toString()),
    ];
  }

  List<String> get subList1Names {
    return [
      tr('Item Code'),
      tr('Item Name'),
      tr('Schedule Date'),
      tr('Description'),
      tr('Item Group'),
      tr('Quantity'),
      tr('Stock UOM'),
      tr('UOM'),
      tr('UOM Conversion Factor'),
      tr('Qty as per Stock UOM'),
      tr('Stock qty'),
      tr('Min Order Quantity'),
      tr('Projected quantity'),
      tr('Actual quantity'),
      tr('Ordered Quantity'),
      tr('Received Quantity'),
      tr('Rate'),
      tr('Amount'),
      tr('Cost Center '),
      tr('Expense Account'),
      tr('Warehouse'),
    ];
  }

  List<String> subList1Item(int index) {
    return [
      items[index]['item_code'] ?? tr('none'),
      items[index]['item_name'] ?? tr('none'),
      items[index]['schedule_date'] ?? tr('none'),
      items[index]['description'] ?? tr('none'),
      items[index]['item_group'] ?? tr('none'),
      items[index]['brand'] ?? tr('none'),
      items[index]['qty'].toString(),
      items[index]['stock_uom'] ?? tr('none'),
      items[index]['uom'] ?? tr('none'),
      items[index]['conversion_factor'].toString(),
      items[index]['stock_qty'].toString(),
      (items[index]['min_order_qty'] ?? tr('none')).toString(),
      (items[index]['projected_qty'] ?? tr('none')).toString(),
      (items[index]['actual_qty'] ?? tr('none')).toString(),
      (items[index]['ordered_qty'] ?? tr('none')).toString(),
      (items[index]['received_qty'] ?? tr('none')).toString(),
      (items[index]['rate'] ?? tr('none')).toString(),
      (items[index]['amount'] ?? tr('none')).toString(),
      items[index]['cost_center'] ?? tr('none'),
      items[index]['expense_account'] ?? tr('none'),
      items[index]['warehouse'] ?? tr('none'),
    ];
  }
}
