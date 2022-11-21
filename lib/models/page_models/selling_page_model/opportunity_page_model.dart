import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';

class OpportunityPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  OpportunityPageModel(this.context, this.data)
      : _items = List<Map<String, dynamic>>.from(data['items'] ?? [])..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  final List<Map<String, dynamic>> _items;

  List<Map<String, dynamic>> get items => _items;

  final List<Tab> tabs = const [
    Tab(text: 'Items'),
    Tab(text: 'Connections'),
  ];

  List<Map<String, String>> get card1Items {
    return [
      {tr("Status"): data['status'] ?? tr('none'), tr("Date"): reverse(data['transaction_date'])},
      {tr("Customer Group"): data['customer_group'] ?? tr('none'), tr("Territory"): data['territory'] ?? tr('none')},
      {tr("Customer Address"): data['customer_address'] != null ? formatDescription(data['customer_address']) : tr('none')},
      {tr("Address"): data['address_display'] != null ? formatDescription(data['address_display']) : tr('none')},
      {tr("Contact Person"): data['contact_person'] ?? tr('none'), tr("Mobile No"): data['contact_mobile'] ?? tr('none')},
      {tr("Contact Email"): data['contact_email'] ?? tr('none')},
      {tr('From Lead'): data['lead_name'] ?? tr('none')},

    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {tr('Source'): data['source'] ?? tr('none'), tr('Campaign Name'): data['campaign_name'] ?? tr('none')},
      {tr('Opportunity Type'): data['opportunity_type'] ?? tr('none'), tr('Order Lost Reason'): data['order_lost_reason'] ?? tr('none')},
      {tr('Next Contact By'): data['contact_by'] ?? tr('none'), tr('Next Contact Date'): reverse(data['contact_date'])},
      {tr('To Discuss'): formatDescription(data['to_discuss'])},
      {tr('With Items'): data['with_items'].toString()},
    ];
  }

  List<String> get itemListNames => [
        tr('Item Code'),
        tr('Item Name'),
        tr('Item Group'),
        tr('Brand'),
        tr('Description'),
        tr('Quantity'),
        tr('UOM'),
      ];

  List<String> itemListValues(int index) {
    return [
      _items[index]['item_code'] ?? tr('none'),
      _items[index]['item_name'] ?? tr('none'),
      _items[index]['item_group'] ?? tr('none'),
      _items[index]['brand'] ?? tr('none'),
      _items[index]['description'] ?? tr('none'),
      _items[index]['qty'].toString(),
      _items[index]['uom'] ?? tr('none'),
    ];
  }

  List<MapEntry<String, String>> getItemCard(int index) {
    return [
      MapEntry(tr('Item Code'), items[index]['item_code'] ?? 'none'),
      MapEntry(tr('Item Group'), items[index]['item_group'] ?? 'none'),
      MapEntry(tr('UOM'), items[index]['uom'] ?? 'none'),
      MapEntry(tr('Quantity'), items[index]['qty'] == null ? tr('none') : (items[index]['qty'] as double).toStringAsFixed(0)),
    ];
  }
}
