import 'package:next_app/provider/user/user_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_functions.dart';

class SalesOrderPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  SalesOrderPageModel(this.context, this.data)
      : items = List<Map<String, dynamic>>.from(data['items'] ?? [])
          ..sort((a, b) => ((a['idx'] ?? 0) as int).compareTo(b['idx'] ?? 0));

  final List<Map<String, dynamic>> items;

  final List<Tab> tabs = const [
    Tab(text: 'Items'),
    Tab(text: 'Taxes'),
    Tab(text: 'Payment'),
    Tab(text: 'Connections'),
  ];

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Date"): data['transaction_date'] == null
            ? tr('none')
            : reverse(data['transaction_date']),
        tr("Delivery Date"): data['delivery_date'] == null
            ? tr('none')
            : reverse(data['delivery_date'])
      },
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr("Tax Id"): data['tax_id'] ?? tr('none')
      },
      {
        tr("Customer Group"): data['customer_group'] ?? tr('none'),
        tr("Territory"): data['territory'] ?? tr('none')
      },
      {
        tr("Customer Address"): data['customer_address'] ?? tr('none'),
        tr("Address"): formatDescription(data['address_display'] ?? tr('none'))
      },
      {
        tr("Contact"): data['contact_display'] ?? tr('none'),
        tr("Mobile No"): data['contact_mobile'] ?? tr('none')
      },
      {
        tr("Contact Email"): data['contact_email'] ?? tr('none'),
        'driver': data['driver'] ?? tr('none'),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Project"): data['project'] ?? tr('none'),
        tr("Order Type"): data['order_type'] ?? tr('none')
      },
      {
        tr("Currency"): data['currency'] ?? tr('none'),
        tr("Exchange Rate"): currency(data['conversion_rate'])
      },
      {
        tr("Price List"): data['selling_price_list'] ?? tr('none'),
        tr("Price List Currency"): data['price_list_currency'] ?? tr('none')
      },
      {
        tr("Price List Exchange Rate"): currency(data['plc_conversion_rate']),
        tr("Ignore Pricing Rule"): data['ignore_pricing_rule'].toString()
      },
      {
        tr("Set Source Warehouse"): data['set_warehouse'] ?? tr('none'),
        tr("Campaign"): data['campaign'] ?? tr('none')
      },
      {
        tr("Source"): data['source'] ?? tr('none'),
        tr("Terms & Conditions"): data['tc_name'] ?? tr('none')
      },
      // {tr("Terms & Conditions Details"): data['terms'] != null ? formatDescription(data['terms']) : tr('none')},
      {
        tr("Payment Terms Template"):
            data['payment_terms_template'] ?? tr('none'),
        tr("Sales Partner"): data['sales_partner'] ?? tr('none')
      },
      {
        tr("Commission Rate"): percent(data['commission_rate']),
        tr("Total Commission"): data['total_commission'].toString()
      },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr("Total Quantity"): data['total_qty'].toString(),
        tr("Total ") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_total'])
      },
      {
        tr("Net Total ") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_net_total'])
      },
      {
        tr("Total"): currency(data['total']),
        tr("Net Total"): currency(data['net_total'])
      },
      {
        tr("Total Taxes and Charges ") +
                context.read<UserProvider>().defaultCurrency:
            currency(data['base_total_taxes_and_charges'])
      },
      {
        tr("Total Taxes and Charges"):
            currency(data['total_taxes_and_charges']),
        tr("Apply Additional Discount On"):
            data['apply_discount_on'] ?? tr('none')
      },
      {
        tr("Additional Discount Amount ") +
                context.read<UserProvider>().defaultCurrency:
            currency(data['base_discount_amount'])
      },
      {
        tr("Additional Discount Percentage"):
            percent(data['additional_discount_percentage']),
        tr("Additional Discount Amount"): currency(data['discount_amount'])
      },
      {
        tr("Grand Total ") + context.read<UserProvider>().defaultCurrency:
            currency(data['base_grand_total'])
      },
      {
        tr("In Words ") + context.read<UserProvider>().defaultCurrency:
            data['base_in_words'] ?? tr('none')
      },
      {tr("Grand Total"): currency(data['grand_total'])},
      {tr("In Words"): data['in_words'] ?? tr('none')},
    ];
  }

  List<MapEntry<String, String>> getItemCard(int index) {
    return [
      MapEntry(tr("Item Code"), items[index]['item_code'] ?? tr('none')),
      MapEntry(tr("Item Group"), items[index]['item_group'] ?? tr('none')),
      MapEntry(tr("UOM"), items[index]['uom'] ?? tr('none')),
      MapEntry(tr("Quantity"), items[index]['qty'].toString()),
      MapEntry(tr("Rate"), currency(items[index]['rate'])),
      MapEntry(tr("Amount"), currency(items[index]['amount'])),
    ];
  }

  List<MapEntry<String, String>> getTaxesCard(int index) {
    return [
      MapEntry(tr("Type"), data['taxes'][index]['charge_type'] ?? tr('none')),
      MapEntry(tr("Account Head"),
          data['taxes'][index]['account_head'] ?? tr('none')),
      MapEntry(tr("Rate"), data['taxes'][index]['rate'].toString()),
      MapEntry(tr("Tax Amount"), currency(data['taxes'][index]['tax_amount'])),
      MapEntry(tr("Total"), currency(data['taxes'][index]['total'])),
    ];
  }

  List<MapEntry<String, String>> getPaymentCard(int index) {
    return [
      MapEntry(
          tr('Payment Term'),
          (data['payment_schedule'][index]['payment_term'] ?? tr('none'))
              .toString()),
      MapEntry(
          tr('Description'),
          (data['payment_schedule'][index]['description'] ?? tr('none'))
              .toString()
              .trim()),
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

  List<String> get itemListNames {
    return [
      tr('Delivery Date'),
      tr('Item Code'),
      tr('Item Name'),
      tr('Description'),
      tr('Item Group'),
      tr('Brand'),
      //    tr('Image'),
      tr('Quantity'),
      tr('Stock UOM'),
      tr('UOM'),
      tr('UOM Conversion Factor'),
      tr('Qty as per Stock UOM'),
      tr('Price List Rate'),
      tr('Price List Rate') + context.read<UserProvider>().defaultCurrency,
      tr('Margin Type'),
      tr('Margin Rate or Amount'),
      tr('Rate With Margin'),
      tr('Discount (%) on Price List Rate with Margin'),
      tr('Discount Amount'),
      tr('Rate With Margin') + context.read<UserProvider>().defaultCurrency,
      tr('Rate'),
      tr('Net Rate'),
      tr('Amount'),
      tr('Item Tax Template'),
      tr('Net Amount'),
      tr('Rate') + context.read<UserProvider>().defaultCurrency,
      tr('Net Rate') + context.read<UserProvider>().defaultCurrency,
      tr('Amount ') + context.read<UserProvider>().defaultCurrency,
      tr('Net Amount ') + context.read<UserProvider>().defaultCurrency,
      tr('Billed Amount'),
      tr('Valuation Rate'),
      tr('Gross Profit'),
      tr('Warehouse'),
      tr('Against Doctype'),
      tr('Projected Qty'),
      tr('Actual Qty'),
      tr('Ordered Qty'),
      tr('Planned Quantity'),
      tr('Work Order Qty'),
      tr('Delivered Qty'),
      tr('Produced Quantity'),
      tr('Returned Qty'),
      tr('Additional Notes'),
    ];
  }

  List<String> itemListValues(int index) {
    return [
      data['items'][index]['delivery_date'] == null
          ? tr('none')
          : reverse(data['items'][index]['delivery_date']),
      data['items'][index]['item_code'] ?? tr('none'),
      data['items'][index]['item_name'] ?? tr('none'),
      data['items'][index]['description'] ?? tr('none'),
      data['items'][index]['item_group'] ?? tr('none'),
      data['items'][index]['brand'] ?? tr('none'),
      //  data['items'][index]['image'] ,
      data['items'][index]['qty'].toString(),
      data['items'][index]['uom'] ?? tr('none'),
      data['items'][index]['uom'] ?? tr('none'),
      data['items'][index]['conversion_factor'].toString(),
      data['items'][index]['stock_qty'].toString(),
      currency(data['items'][index]['price_list_rate']),
      currency(data['items'][index]['base_price_list_rate']),
      data['items'][index]['margin_type'] ?? tr('none'),
      data['items'][index]['margin_rate_or_amount'].toString(),
      currency(data['items'][index]['rate_with_margin']),
      percent(data['items'][index]['discount_percentage']),
      currency(data['items'][index]['discount_amount']),
      currency(data['items'][index]['base_rate_with_margin']),
      currency(data['items'][index]['rate']),
      currency(data['items'][index]['net_rate']),
      currency(data['items'][index]['amount']),
      data['items'][index]['item_tax_template'] ?? tr('none'),
      currency(data['items'][index]['net_amount']),
      currency(data['items'][index]['base_rate']),
      currency(data['items'][index]['base_net_rate']),
      currency(data['items'][index]['base_amount']),
      currency(data['items'][index]['base_net_amount']),
      currency(data['items'][index]['billed_amt']),
      currency(data['items'][index]['valuation_rate']),
      currency(data['items'][index]['gross_profit']),
      data['items'][index]['warehouse'] ?? tr('none'),
      data['items'][index]['prevdoc_docname'] ?? tr('none'),
      data['items'][index]['projected_qty'].toString(),
      data['items'][index]['actual_qty'].toString(),
      data['items'][index]['ordered_qty'].toString(),
      data['items'][index]['planned_qty'].toString(),
      data['items'][index]['work_order_qty'].toString(),
      data['items'][index]['delivered_qty'].toString(),
      data['items'][index]['produced_qty'].toString(),
      data['items'][index]['returned_qty'].toString(),
      data['items'][index]['additional_notes'] ?? tr('none'),
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
      data['taxes'][index]['charge_type'] ?? tr('none'),
      data['taxes'][index]['row_id'] ?? tr('none'),
      data['taxes'][index]['account_head'] ?? tr('none'),
      data['taxes'][index]['description'] ?? tr('none'),
      data['taxes'][index]['cost_center'] ?? tr('none'),
      data['taxes'][index]['rate'].toString(),
      data['taxes'][index]['account_currency'] ?? tr('none'),
      currency(data['taxes'][index]['tax_amount']),
      currency(data['taxes'][index]['total']),
      currency(data['taxes'][index]['tax_amount_after_discount_amount']),
      currency(data['taxes'][index]['base_tax_amount']),
      currency(data['taxes'][index]['base_total']),
      currency(data['taxes'][index]['base_tax_amount_after_discount_amount']),
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
      data['payment_schedule'][index]['payment_term'] ?? tr('none'),
      ((data['payment_schedule'][index]['description'] ?? tr('none')) as String)
          .trim(),
      reverse(data['payment_schedule'][index]['due_date']),
      data['payment_schedule'][index]['mode_of_payment'] ?? tr('none'),
      percent(data['payment_schedule'][index]['invoice_portion']),
      data['payment_schedule'][index]['discount_type'] ?? tr('none'),
      reverse(data['payment_schedule'][index]['discount_date']),
      data['payment_schedule'][index]['discount'].toString(),
      currency(data['payment_schedule'][index]['payment_amount']),
      currency(data['payment_schedule'][index]['outstanding']),
      currency(data['payment_schedule'][index]['paid_amount']),
      currency(data['payment_schedule'][index]['discounted_amount']),
      currency(data['payment_schedule'][index]['base_payment_amount']),
    ];
  }
}
