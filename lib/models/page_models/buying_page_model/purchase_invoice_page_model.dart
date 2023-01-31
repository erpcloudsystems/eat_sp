import '../../../provider/user/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_functions.dart';

class PurchaseInvoicePageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  PurchaseInvoicePageModel(this.context, this.data)
      : _items = List<Map<String, dynamic>>.from(
            data['purchase_invoice_item'] ?? [])
          ..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

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
        tr("Date"): data['posting_date'] != null
            ? reverse(data['posting_date'])
            : tr('none'),
        tr("Due Date"):
            data['due_date'] != null ? reverse(data['due_date']) : tr('none')
      },
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr("Tax Id"): data['tax_id'] ?? tr('none'),
      },
      //{tr("Customer Group"): data['customer_group'] ?? tr('none'), tr("Territory"): data['territory'] ?? tr('none')},
      {
        tr("Supplier Address"): data['supplier_address'] != null
            ? formatDescription(data['supplier_address'])
            : tr('none'),
      },
      {
        tr("Address"): formatDescription(data['address_display'] ?? tr('none')),
      },
      {
        tr("Contact"): data['contact_display'] ?? tr('none'),
        tr("Mobile No"): data['contact_mobile'] ?? tr('none'),
      },
      {
        tr("Contact Email"): data['contact_email'] ?? tr('none'),
      }
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Project"): data['project'] ?? tr('none'),
        tr("Cost Center"): data['cost_center'] ?? tr('none'),
      },
      {
        tr("Currency"): data['currency'] ?? tr('none'),
        tr("Exchange Rate"): data['conversion_rate'].toString(),
      },
      {
        tr("Price List"): data['buying_price_list'] ?? tr('none'),
        tr("Price List Currency"): data['price_list_currency'] ?? tr('none'),
      },
      {
        tr("Ignore Pricing Rule"): data['ignore_pricing_rule'].toString(),
        tr("Price List Exchange Rate"): data['plc_conversion_rate'].toString(),
      },
      {
        tr("Update Stock"): data['update_stock'].toString(),
        tr("Is Return"): data['is_return'].toString(),
      },
      {
        tr("Source Warehouse"): data['set_warehouse'] ?? tr('none'),
      },
      {
        tr("Terms & Conditions"): data['tc_name'] ?? tr('none'),
        tr("Payment Terms Template"): data['payment_terms_template'] ?? tr('none'),
      },

    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr("Total Quantity"): data['total_qty'].toString(),
      },
      {
        tr("Total ") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_total']),
        tr("Net Total ") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_net_total'])
      },
      (data['base_total'] == data['total'])
          ? {}
          : {
              tr("Total  ") + "(${data['currency']})": currency(data['total']),
              tr("Net Total  ") + "(${data['currency']})":
                  currency(data['net_total'])
            },
      {
        tr("Total Taxes and Charges ") +
                context.read<UserProvider>().defaultCurrency:
            currency(data['base_total_taxes_and_charges'])
      },
      (data['base_total_taxes_and_charges'] == data['total_taxes_and_charges'])
          ? {}
          : {
              tr("Total Taxes and Charges  ") + "(${data['currency']})":
                  currency(data['total_taxes_and_charges']),
            },
      {
        tr("Apply Additional Discount On"): data['apply_discount_on'].toString()
      },
      {
        tr("Additional Discount Amount ") +
                context.read<UserProvider>().defaultCurrency:
            currency(data['base_discount_amount'])
      },
      (data['base_discount_amount'] == data['discount_amount'])
          ? {}
          : {
              tr("Additional Discount Amount  ") + "(${data['currency']})":
                  currency(data['discount_amount'])
            },
      {
        tr("Additional Discount Percentage"):
            percent(data['additional_discount_percentage']),
      },
      {
        tr("Grand Total  ") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_grand_total'])
      },
      {
        tr("In Words  ") + context.read<UserProvider>().defaultCurrency:
            data['base_in_words'] ?? tr('none')
      },
      (data['base_grand_total'] == data['grand_total'])
          ? {}
          : {
              tr("Grand Total ") + "(${data['currency']})":
                  currency(data['grand_total'])
            },
      (data['base_grand_total'] == data['grand_total'])
          ? {}
          : {
              tr("In Words  ") + "(${data['currency']})":
                  data['in_words'] ?? tr('none')
            },
    ];
  }

  // List<Map<String, String>> get addressDisplayValues{
  //   return [
  //     {
  //       tr("Total Quantity"): data['total_qty'].toString(),
  //     },
  //   ];
  // }

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
  }

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
      MapEntry(tr('Account Head'),
          (data['child_purchase_taxes_and_charges'][index]['account_head'] ?? tr('none')).toString()),
      MapEntry(tr('Type'),
          (data['child_purchase_taxes_and_charges'][index]['charge_type'] ?? tr('none')).toString()),
      MapEntry(
          tr('Rate'), (data['child_purchase_taxes_and_charges'][index]['rate'] ?? tr('none')).toString()),
      MapEntry(tr('Amount'), currency(data['child_purchase_taxes_and_charges'][index]['tax_amount'])),
      MapEntry(tr('Total'), currency(data['child_purchase_taxes_and_charges'][index]['total'])),
    ];
  }

  List<String> get taxesListNames {
    return [
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
      tr('Tax Amount After Discount Amount ') +
          context.read<UserProvider>().defaultCurrency,
    ];
  }

  List<String> taxesListValues(int index) {
    return [
      (data['child_purchase_taxes_and_charges'][index]['charge_type'] ?? tr('none')).toString(),
      (data['child_purchase_taxes_and_charges'][index]['row_id'] ?? tr('none')).toString(),
      (data['child_purchase_taxes_and_charges'][index]['account_head'] ?? tr('none')).toString(),
      (data['child_purchase_taxes_and_charges'][index]['description'] ?? tr('none')).toString(),
      (data['child_purchase_taxes_and_charges'][index]['cost_center'] ?? tr('none')).toString(),
      (data['child_purchase_taxes_and_charges'][index]['rate'] ?? tr('none')).toString(),
      (data['child_purchase_taxes_and_charges'][index]['account_currency'] ?? tr('none'))
          .toString(), // TODO reemove it
      currency(data['child_purchase_taxes_and_charges'][index]['tax_amount']),
      currency(data['child_purchase_taxes_and_charges'][index]['total']),
      currency(data['child_purchase_taxes_and_charges'][index]['tax_amount_after_discount_amount']),
      currency(data['child_purchase_taxes_and_charges'][index]['base_tax_amount']),
      currency(data['child_purchase_taxes_and_charges'][index]['base_total']),
      currency(data['child_purchase_taxes_and_charges'][index]['base_tax_amount_after_discount_amount']),
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

  List<String> get paymentListNames {
    return [
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
  }

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
