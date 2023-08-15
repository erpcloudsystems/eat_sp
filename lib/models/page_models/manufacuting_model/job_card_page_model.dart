import 'package:easy_localization/easy_localization.dart';

import '../../../new_version/core/resources/strings_manager.dart';

class JobCardPageModel {
  final Map<String, dynamic> data;
  final List<Map<String, dynamic>> items;

  JobCardPageModel(this.data)
      : items = List<Map<String, dynamic>>.from(data['items'] ?? [])
          ..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr(StringsManager.project): data['project'] ?? tr('none')
      },
      {
        tr(StringsManager.itemName): data['item_name'] ?? tr('none'),
      },
      {
        tr(StringsManager.qtyToManufacture):
            (data['for_quantity'] ?? tr('none')).toString(),
      },
      {
        tr(StringsManager.company): data['company'] ?? tr('none'),
        tr(StringsManager.wipWarehouse): data['wip_warehouse'] != null
            ? data['wip_warehouse'][0]
            : tr('none')
      },
      {
        tr(StringsManager.bomNo): data['bom_no'] ?? tr('none'),
        tr(StringsManager.workOrder): data['work_order'] ?? tr('none')
      },
      {
        tr(StringsManager.operation): data['operation'] ?? tr('none'),
        tr(StringsManager.workstation): data['workstation'] ?? tr('none')
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        StringsManager.remarks.tr(): data['remarks'] ?? tr('none'),
      },
    ];
  }

  List<MapEntry<String, String>> getItemCard(int index) {
    return [
      MapEntry(tr("Item Code"), items[index]['item_code'] ?? tr('none')),
      MapEntry(tr("UOM"), items[index]['uom'] ?? tr('none')),
      MapEntry(tr("Item Group"), items[index]['item_group'] ?? tr('none')),
    ];
  }

  List<String> get subList1Names {
    return [
      tr('Item Code'),
      tr('Item Name'),
      tr('Description'),
      tr('Item Group'),
      tr('Brand'),
      tr('Quantity'),
      tr('Stock UOM'),
      tr('UOM'),
      tr('Min Order Quantity'),
      tr('Last Purchase Rate'),
      tr('Valuation Rate'),
    ];
  }

  List<String> subList1Item(int index) {
    return [
      items[index]['item_code'] ?? tr('none'),
      items[index]['item_name'] ?? tr('none'),
      items[index]['description'] ?? tr('none'),
      items[index]['item_group'] ?? tr('none'),
      items[index]['brand'] ?? tr('none'),
      (items[index]['required_qty'] ?? tr('none')).toString(),
      items[index]['stock_uom'] ?? tr('none'),
      items[index]['uom'] ?? tr('none'),
      (items[index]['min_order_qty'] ?? tr('none')).toString(),
      (items[index]['last_purchase_rate'] ?? tr('none')).toString(),
      (items[index]['valuation_rate'] ?? tr('none')).toString(),
    ];
  }
}
