import 'package:next_app/provider/user/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_functions.dart';

class SalesInvoicePageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  SalesInvoicePageModel(this.context, this.data)
      : _items = List<Map<String, dynamic>>.from(data['items'] ?? [])..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  final List<Map<String, dynamic>> _items;

  List<Map<String, dynamic>> get items => _items;

  final List<Tab> tabs = const [
    Tab(text: 'Items'),
    Tab(text: 'Taxes'),
    Tab(text: 'Payment'),
    Tab(child: FittedBox(child: Text('Connections'))),
  ];

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Date"): data['posting_date'] != null ? reverse(data['posting_date']) : tr('none'),
        tr("Due Date"): data['due_date'] != null ? reverse(data['due_date']) : tr('none')
      },
      {tr("Status"): data['status'] ?? tr('none'), tr("Tax Id"): data['tax_id'] ?? tr('none')},
      {tr("Customer Group"): data['customer_group'] ?? tr('none'), tr("Territory"): data['territory'] ?? tr('none')},
      {tr("Customer Address"): data['customer_address'] != null ? formatDescription(data['customer_address']) : tr('none')},
      {tr("Address"): data['address_display'] != null ? formatDescription(data['address_display']) : tr('none')},
      {
        tr("City"): data['city'] ?? tr('none'),
        tr("Country"): data['country'] ?? tr('none'),
      },
      {tr("Contact"): data['contact_display'] ?? tr('none'), tr("Mobile No"): data['contact_mobile'] ?? tr('none')},
      {tr("Contact Email"): data['contact_email'] ?? tr('none')}
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {tr("Is Return"): data['is_return'].toString(), tr("Project"): data['project'] ?? tr('none')},
      {tr("Cost Center"): data['cost_center'] ?? tr('none'), tr("Currency"): data['currency'] ?? tr('none')},
      {tr("Exchange Rate"): data['conversion_rate'].toString(), tr("Price List"): data['selling_price_list'] ?? tr('none')},
      {tr("Price List Currency"): data['price_list_currency'] ?? tr('none'), tr("Price List Exchange Rate"): data['plc_conversion_rate'].toString()},
      {tr("Ignore Pricing Rule"): data['ignore_pricing_rule'].toString(), tr("Update Stock"): data['update_stock'].toString()},
      {tr("Source Warehouse"): data['set_warehouse'] ?? tr('none'), tr("Payment Terms Template"): data['payment_terms_template'] ?? tr('none')},
      {tr("Terms & Conditions"): data['tc_name'] ?? tr('none'), tr("Sales Partner"): data['sales_partner'] ?? tr('none')},
      {
        tr("Commission Rate"): data['commission_rate'] == null ? tr('none') : data['commission_rate'].toString(),
        tr("Total Commission"): data['total_commission'] == null ? tr('none') : data['total_commission'].toString()
      },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {tr("Total Quantity"): data['total_qty'].toString(), tr("Total ") + context.read<UserProvider>().defaultCurrency: currency(data['base_total'])},
      {tr("Net Total ") + context.read<UserProvider>().defaultCurrency: currency(data['base_net_total'])},
      {tr("Total"): currency(data['total']), tr("Net Total"): currency(data['net_total'])},
      {tr("Total Taxes and Charges ") + context.read<UserProvider>().defaultCurrency: currency(data['base_total_taxes_and_charges'])},
      {tr("Total Taxes and Charges"): currency(data['total_taxes_and_charges']), tr("Apply Additional Discount On"): data['apply_discount_on'].toString()},
      {tr("Additional Discount Amount ") + context.read<UserProvider>().defaultCurrency: currency(data['base_discount_amount'])},
      {
        tr("Additional Discount Percentage"): percent(data['additional_discount_percentage']),
        tr("Additional Discount Amount"): currency(data['discount_amount'])
      },
      {tr("Grand Total ") + context.read<UserProvider>().defaultCurrency: currency(data['base_grand_total'])},
      {tr("In Words ") + context.read<UserProvider>().defaultCurrency: data['base_in_words'] ?? tr('none')},
      {tr("Grand Total"): currency(data['grand_total'])},
      {tr("In Words"): data['in_words'] ?? tr('none')},
      {
        tr("Longitude"): data['longitude'].toString(),
        tr("Latitude"): data['latitude'].toString() ,
      },
    ];
  }

  List<String> get subList1Names =>
      [
        tr('Item Code'),
        tr('Item Name'),
        tr('Description'),
        tr('Item Group'),
        tr('Brand'),
        tr('Quantity'),
        tr('Stock UOM'),
        tr('UOM'),
        tr('UOM Conversion Factor'),
        tr('Qty as per Stock UOM'),
        tr('Price List Rate'),
        tr('Price List Rate ') + context.read<UserProvider>().defaultCurrency,
        tr('Margin Type'),
        tr('Margin Rate or Amount'),
        tr('Rate With Margin'),
        tr('Discount (%) on Price List Rate with Margin'),
        tr('Discount Amount'),
        tr('Rate With Margin ') + context.read<UserProvider>().defaultCurrency,
        tr('Rate'),
        tr('Net Rate'),
        tr('Amount'),
        tr('Net Amount'),
        tr('Item Tax Template'),
        tr('Rate ') + context.read<UserProvider>().defaultCurrency,
        tr('Net Rate ') + context.read<UserProvider>().defaultCurrency,
        tr('Amount ') + context.read<UserProvider>().defaultCurrency,
        tr('Net Amount ') + context.read<UserProvider>().defaultCurrency,
        tr('Warehouse'),
        tr('Actual Qty'),
        tr('Delivered Qty'),
      ];

  List<String> subList1Item(int index) {
    return [
      _items[index]['item_code'] ?? tr('none'),
      _items[index]['item_name'] ?? tr('none'),
      _items[index]['description'] ?? tr('none'),
      _items[index]['item_group'] ?? tr('none'),
      _items[index]['brand'] ?? tr('none'),
      _items[index]['qty'].toString(),
      _items[index]['uom'] ?? tr('none'),
      _items[index]['uom'] ?? tr('none'),
      _items[index]['conversion_factor'].toString(),
      _items[index]['stock_qty'].toString(),
      currency(_items[index]['price_list_rate']),
      currency(_items[index]['base_price_list_rate']),
      _items[index]['margin_type'] ?? tr('none'),
      (_items[index]['margin_rate_or_amount'] ?? tr('none')).toString(),
      currency(_items[index]['rate_with_margin']),
      (_items[index]['discount_percentage'] ?? tr('none')).toString(),
      currency(_items[index]['discount_amount']),
      currency(_items[index]['base_rate_with_margin']),
      currency(_items[index]['rate']),
      currency(_items[index]['net_rate']),
      currency(_items[index]['amount']),
      currency(_items[index]['net_amount']),
      _items[index]['item_tax_template'] ?? tr('none'),
      currency(_items[index]['base_rate']),
      currency(_items[index]['base_net_rate']),
      currency(_items[index]['base_amount']),
      currency(_items[index]['base_net_amount']),
      (_items[index]['warehouse'] ?? tr('none')).toString(),
      (_items[index]['actual_qty'] ?? tr('none')).toString(),
      (_items[index]['delivered_qty'] ?? tr('none')).toString(),
    ];
  }

  List<MapEntry<String, String>> taxesCardValues(int index) {
    return [
      MapEntry(tr('Account Head'), (data['taxes'][index]['account_head'] ?? tr('none')).toString()),
      MapEntry(tr('Type'), (data['taxes'][index]['charge_type'] ?? tr('none')).toString()),
      MapEntry(tr('Rate'), (data['taxes'][index]['rate'] ?? tr('none')).toString()),
      MapEntry(tr('Amount'), currency(data['taxes'][index]['tax_amount'])),
      MapEntry(tr('Total'), currency(data['taxes'][index]['total'])),
    ];
  }

  List<String> get taxesListNames => [
        tr('Type'),
        tr('Reference Row #'),
        tr('Account Head'),
        tr('Description'),
        tr('Cost Center'),
        tr('Rate'),
        tr('Account Currency'),
        tr('Tax Amount'),
        tr('Total'),
        tr('Tax Amount After Discount Amount'),
        tr('Tax Amount ') + context.read<UserProvider>().defaultCurrency,
        tr('Total ') + context.read<UserProvider>().defaultCurrency,
        tr('Tax Amount After Discount Amount ') + context.read<UserProvider>().defaultCurrency,
      ];

  List<String> taxesListValues(int index) {
    return [
      (data['taxes'][index]['charge_type'] ?? tr('none')).toString(),
      (data['taxes'][index]['row_id'] ?? tr('none')).toString(),
      (data['taxes'][index]['account_head'] ?? tr('none')).toString(),
      (data['taxes'][index]['description'] ?? tr('none')).toString(),
      (data['taxes'][index]['cost_center'] ?? tr('none')).toString(),
      (data['taxes'][index]['rate'] ?? tr('none')).toString(),
      (data['taxes'][index]['account_currency'] ?? tr('none')).toString(),
      currency(data['taxes'][index]['tax_amount']),
      currency(data['taxes'][index]['total']),
      currency(data['taxes'][index]['tax_amount_after_discount_amount']),
      currency(data['taxes'][index]['base_tax_amount']),
      currency(data['taxes'][index]['base_total']),
      currency(data['taxes'][index]['base_tax_amount_after_discount_amount']),
    ];
  }

  List<MapEntry<String, String>> paymentCardValues(int index) {
    return [
      MapEntry(tr('Payment Term'), (data['payment_schedule'][index]['payment_term'] ?? tr('none')).toString()),
      MapEntry(tr('Description'), (data['payment_schedule'][index]['description'] ?? tr('none')).toString()),
      MapEntry(tr('Due Date'), data['payment_schedule'][index]['due_date'] != null ? reverse(data['payment_schedule'][index]['due_date']) : tr('none')),
      MapEntry(tr('Invoice Portion'), percent(data['payment_schedule'][index]['invoice_portion'])),
      MapEntry(tr('Payment Amount'), currency(data['payment_schedule'][index]['payment_amount'])),
    ];
  }

  List<String> get paymentListNames =>
      [
        tr('Payment Term'),
        tr('Description'),
        tr('Due Date'),
        tr('Mode of Payment'),
        tr('Invoice Portion'),
        tr('Discount Type'),
        tr('Discount Date'),
        tr('Discount'),
        tr('Payment Amount'),
        tr('Outstanding Amount'),
        tr('Paid Amount'),
        tr('Discounted Amount'),
        tr('Payment Amount ') + context.read<UserProvider>().defaultCurrency,
      ];

  List<String> paymentListValues(int index) {
    return [
      (data['payment_schedule'][index]['payment_term'] ?? tr('none')).toString(),
      (data['payment_schedule'][index]['description'] ?? tr('none')).toString(),
      data['payment_schedule'][index]['due_date'] != null ? reverse(data['payment_schedule'][index]['due_date']) : tr('none'),
      (data['payment_schedule'][index]['mode_of_payment'] ?? tr('none')).toString(),
      (data['payment_schedule'][index]['invoice_portion'] ?? tr('none')).toString(),
      (data['payment_schedule'][index]['discount_type'] ?? tr('none')).toString(),
      data['payment_schedule'][index]['discount_date'] != null ? reverse(data['payment_schedule'][index]['discount_date']) : tr('none'),
      (data['payment_schedule'][index]['discount'] ?? tr('none')).toString(),
      currency(data['payment_schedule'][index]['payment_amount']),
      currency(data['payment_schedule'][index]['outstanding']),
      currency(data['payment_schedule'][index]['paid_amount']),
      currency(data['payment_schedule'][index]['discounted_amount']),
      currency(data['payment_schedule'][index]['base_payment_amount']),
    ];
  }

  List<MapEntry<String, String>> quotationItem(int index) {
    return [
      MapEntry(tr('Item Code'), items[index]['item_code'] ?? 'none'),
      MapEntry(tr('Item Group'), items[index]['item_group'] ?? 'none'),
      MapEntry(tr('UOM'), items[index]['uom'] ?? 'none'),
      MapEntry(tr('Quantity'), items[index]['qty'] == null ? tr('none') : (items[index]['qty'] as double).toStringAsFixed(0)),
      MapEntry(tr('Rate'), currency(items[index]['rate'])),
      MapEntry(tr('Amount'), currency(items[index]['amount'])),
    ];
  }
}
