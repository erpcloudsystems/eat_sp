import 'package:next_app/provider/user/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_functions.dart';

class SupplierQuotationPageModel {
  late final Map<String, dynamic> data;
  final BuildContext context;

  SupplierQuotationPageModel(this.context, this.data)
      : _items = List<Map<String, dynamic>>.from(data['items'] ?? [])
          ..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  final List<Map<String, dynamic>> _items;

  List<Map<String, dynamic>> get items => _items;

  final List<Tab> tabs = const [
    Tab(text: 'Items'),
    Tab(text: 'Taxes'),
    Tab(text: 'Payment'),
    Tab(child: FittedBox(child: Text('Connections'))),
  ];
  //name -  - supplier - supplier_name -
  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Transaction Date"): data['transaction_date'] != null
            ? reverse(data['transaction_date'])
            : tr('none'),
        tr("Valid Till"): data['valid_till'] != null
            ? reverse(data['valid_till'])
            : tr('none')
      },
      {
        tr("Supplier Address"): data['supplier_address'] ?? tr('none'),
        tr("Status"): data['status'] ?? tr('none')
      },
      // should be 2 - add any thing to Address
      {
        tr("Contact Person"): data['contact_person'] ?? tr('none'),
        tr("Mobile No"): data['contact_mobile'] ?? tr('none')
      },
      {tr("Address Display"): formatDescription(data['address_display'])},
      {tr("Email"): data['contact_email'] ?? tr('none')},
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Currency"): data['currency'] ?? tr('none'),
        tr("Exchange Rate"): data['conversion_rate'].toString(),
      },
      {
        tr("Price List"): data['buying_price_list']?? tr('none'),
        tr("Price List Currency"): data['price_list_currency'] ?? tr('none'),
      },
      {
        tr("Ignore Pricing Rule"): data['ignore_pricing_rule'].toString(),
        tr("Price Lis t Conversion Rate"): data['plc_conversion_rate'].toString()
      },
      // {
      //   tr("Terms & Conditions"): data['tc_name'] ?? tr('none'),
      //   tr("Payment Terms Template"): data['payment_terms_template'] ?? tr('none'),
      // },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr("Total Quantity"): data['total_qty'].toString(),
      },
      {
        tr("Total") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_total']),
        tr("Net Total") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_net_total']),
      },
      (data['base_total'] == data['total'])
          ? {}
          : {
              tr("Total") + "(${data['currency']})": currency(data['total']),
              tr("Net Total") + "(${data['currency']})":
                  currency(data['net_total']),
            },
      {
        tr("Total Taxes And Charges") +
                context.read<UserProvider>().defaultCurrency:
            currency(data['base_total_taxes_and_charges'])
      },
      (data['total_taxes_and_charges'] == data['base_total_taxes_and_charges'])
          ? {}
          : {
              tr("Total Taxes And Charges") + "(${data['currency']})":
                  currency(data['total_taxes_and_charges'])
            },
      {tr("Apply Discount On"): data['apply_discount_on'] ?? tr('none')},
      {
        tr("Discount Amount") + context.read<UserProvider>().defaultCurrency:
            data['base_discount_amount'].toString()
      },
      {
        tr("Additional Discount Percentage") :
            percent(data['additional_discount_percentage']).toString()
      },
      (data['discount_amount'] == data['base_discount_amount'])
          ? {}
          : {
              tr("Discount Amount") + "(${data['currency']})":
                  data['discount_amount'].toString(),
            },
      {
        tr("Grand Total") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_grand_total'])
      },
      {
        tr("In Words") + context.read<UserProvider>().defaultCurrency:
            data['base_in_words'].toString()
      },
      (data['grand_total'] == data['base_grand_total'])
          ? {}
          : {
              tr("Grand Total") + "(${data['currency']})":
                  currency(data['grand_total'])
            },
      (data['grand_total'] == data['base_grand_total'])
          ? {}
          : {
              tr("In Words") + "(${data['currency']})":
                  data['in_words'].toString()
            },
    ];
  }

  List<String> get subList1Names => [
        tr('Item Code'),
        tr('Item Name'),
        tr('Description'),
        tr('Supplier Part no'),
        tr('Lead Time Days'),
        tr('Expected Delivery Date'),
        tr('Is Free Item'),
        tr('Item Group'),
        tr('Brand'),
        tr('Qty'),
        tr('Stock Qty'),
        tr('Stock Uom'),
        tr('Uom'),
        tr('Conversion Factor'),
        tr('Price List Rate'),
        tr('Discount Percentage'),
        tr('Discount Amount'),
        tr('Base Price List Rate'),
        tr('Rate'),
        tr('Amount'),
        tr('Item Tax Template'),
        tr('Base Rate'),
        tr('Base Amount'),
        tr('Pricing Rules'),
        tr('Net Rate'),
        tr('Net Amount'),
        tr('Base Net Rate'),
        tr('Base Net Amount'),
        tr('weight Per Unit'),
        tr('Total Weight'),
        tr('Weight_uom'),
        tr('Warehouse'),
        tr('Prevdoc Doctype'),
        tr('Material Request'),
        tr('Sales Order'),
        tr('Request For Quotation'),
        tr('Material Request Item'),
        tr('Request For Quotation Item'),
        tr('Manufacturer'),
        tr('Manufacturer Part no'),
        tr('Project'),
      ];

  List<String> subList1Item(int index) {
    return [
      _items[index]['item_code'] ?? tr('none'),
      _items[index]['item_name'] ?? tr('none'),
      _items[index]['description'] ?? tr('none'),
      _items[index]['supplier_part_no'] ?? tr('none'),
      _items[index]['lead_time_days'].toString(),
      _items[index]['expected_delivery_date'] ?? tr('none'),
      _items[index]['is_free_item'].toString(),
      _items[index]['item_group'] ?? tr('none'),
      _items[index]['brand'] ?? tr('none'),
      _items[index]['qty'].toString(),
      _items[index]['stock_qty'].toString(),
      _items[index]['stock_uom'] ?? tr('none'),
      _items[index]['uom'] ?? tr('none'),
      _items[index]['conversion_factor'].toString(),
      currency(_items[index]['price_list_rate']),
      percent(_items[index]['discount_percentage']),
      currency(_items[index]['discount_amount']),
      currency(_items[index]['base_price_list_rate']),
      currency(_items[index]['rate']),
      currency(_items[index]['amount']),
      _items[index]['item_tax_template'] ?? tr('none'),
      currency(_items[index]['base_rate']),
      currency(_items[index]['base_amount']),
      _items[index]['pricing_rules'] ?? tr('none'),
      currency(_items[index]['net_rate']),
      currency(_items[index]['net_amount']),
      currency(_items[index]['base_net_rate']),
      currency(_items[index]['base_net_amount']),
      _items[index]['weight_per_unit'].toString(),
      _items[index]['total_weight'].toString(),
      _items[index]['weight_uom'] ?? tr('none'),
      _items[index]['warehouse'] ?? tr('none'),
      _items[index]['prevdoc_doctype'] ?? tr('none'),
      _items[index]['material_request'] ?? tr('none'),
      _items[index]['sales_order'] ?? tr('none'),
      _items[index]['request_for_quotation'] ?? tr('none'),
      _items[index]['material_request_item'] ?? tr('none'),
      _items[index]['request_for_quotation_item'] ?? tr('none'),
      _items[index]['manufacturer'] ?? tr('none'),
      _items[index]['manufacturer_part_no'] ?? tr('none'),
      _items[index]['project'] ?? tr('none'),
    ];
  }

  // TODO check if this wotking
  List<MapEntry<String, String>> taxesCardValues(int index) {
    return [
      MapEntry(tr('Account Head'),
          (data['taxes'][index]['account_head'] ?? tr('none')).toString()),
      MapEntry(tr('Type'),
          (data['taxes'][index]['charge_type'] ?? tr('none')).toString()),
      MapEntry(
          tr('Rate'), (data['taxes'][index]['rate'] ?? tr('none')).toString()),
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
        tr('Tax Amount  ') + context.read<UserProvider>().defaultCurrency,
        tr('Total  ') + context.read<UserProvider>().defaultCurrency,
        tr('Tax Amount After Discount Amount  ') +
            context.read<UserProvider>().defaultCurrency,
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
      MapEntry(
          tr('Payment Term'),
          (data['payment_schedule'][index]['payment_term'] ?? tr('none'))
              .toString()),
      MapEntry(
          tr('Description'),
          (data['payment_schedule'][index]['description'] ?? tr('none'))
              .toString()),
      MapEntry(
          tr('Due Date'),
          data['payment_schedule'][index]['due_date'] != null
              ? reverse(data['payment_schedule'][index]['due_date'])
              : tr('none')),
      MapEntry(tr('Invoice Portion'),
          percent(data['payment_schedule'][index]['invoice_portion'])),
      MapEntry(tr('Payment Amount'),
          currency(data['payment_schedule'][index]['payment_amount'])),
    ];
  }

  List<String> get paymentListNames => [
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
        tr('Payment Amount  ') + context.read<UserProvider>().defaultCurrency,
      ];
  //TODO check this
  List<String> paymentListValues(int index) {
    return [
      (data['payment_schedule'][index]['payment_term'] ?? tr('none'))
          .toString(),
      (data['payment_schedule'][index]['description'] ?? tr('none')).toString(),
      data['payment_schedule'][index]['due_date'] != null
          ? reverse(data['payment_schedule'][index]['due_date'])
          : tr('none'),
      (data['payment_schedule'][index]['mode_of_payment'] ?? tr('none'))
          .toString(),
      (data['payment_schedule'][index]['invoice_portion'] ?? tr('none'))
          .toString(),
      (data['payment_schedule'][index]['discount_type'] ?? tr('none'))
          .toString(),
      data['payment_schedule'][index]['discount_date'] != null
          ? reverse(data['payment_schedule'][index]['discount_date'])
          : tr('none'),
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
      MapEntry(
          tr('Quantity'),
          items[index]['qty'] == null
              ? tr('none')
              : (items[index]['qty'] as double).toStringAsFixed(0)),
      MapEntry(tr('Rate'), currency(items[index]['rate'])),
      MapEntry(tr('Amount'), currency(items[index]['amount'])),
    ];
  }
}
