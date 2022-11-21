import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/user/user_provider.dart';
import '../model_functions.dart';

class MaterialRequestPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  final List<Map<String, dynamic>> items;

  MaterialRequestPageModel(this.context, this.data)
      : items = List<Map<String, dynamic>>.from(data['items'] ?? [])
          ..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  final List<Tab> tabs = const [
    Tab(text: 'Items'),
    Tab(text: 'Connections'),
  ];

  List<Map<String, String>> get card1Items {
    return [

      {
        tr("Transaction Date"): data['transaction_date'] == null
            ? tr('none')
            : reverse(data['transaction_date']),
        tr("Required By Date"): data['schedule_date'] == null
            ? tr('none')
            : reverse(data['schedule_date']),

      },
      {
        tr("Purpose"): data['material_request_type'] ?? tr('none'),
        //tr("Purpose"): data['purpose'] ?? tr('none')
        tr("Status"): data['status'] ?? tr('none')
      },
      (data['material_request_type'] == 'Customer Provided')?
      {
        tr("Customer"): data['customer'] ?? tr('none'),
      }:{},

      (data['material_request_type'] == 'Material Transfer')?
      {
        tr("Source Warehouse"): data['set_from_warehouse'] ?? tr('none'),
      }:
      {},
      {
        tr("Target Warehouse"): data['set_warehouse'] ?? tr('none'),
        //tr("To Warehouse"): data['to_warehouse'] ?? tr('none')
      },
      //{tr("Project"): data['project'] ?? tr('none')}
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
