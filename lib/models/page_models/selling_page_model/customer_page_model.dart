import '../model_functions.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomerPageModel {
  final Map<String, dynamic> data;

  CustomerPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {tr("Customer Balance"): currency(data['balance']), tr('Disabled'): data['disabled'].toString()},
      {tr('Customer Type'): data['customer_type'] ?? tr('none'), tr('Customer Group'): data['customer_group'] ?? tr('none')},
      {tr('Territory'): data['territory'] ?? tr('none'), tr('Market Segment'): data['market_segment'] ?? tr('none')},
      {tr('Industry'): data['industry'] ?? tr('none'), tr('Tax ID'): data['tax_id'] ?? tr('none')},
      {tr('Customer Primary Address'): data['customer_primary_address'] ?? tr('none')},
      {tr('Primary Address'): formatDescription(data['primary_address'] ?? tr('none'))},
      {tr('Customer Primary Contact'): data['customer_primary_contact'] ?? tr('none'), tr('Mobile No'): data['mobile_no'] ?? tr('none')},
      {tr('Email Id'): data['email_id'] ?? tr('none')},
      {tr('From Lead'): data['lead_name'] ?? tr('none')},
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {tr("Currency"): data['default_currency'] ?? tr('none'), tr('Price List'): data['default_price_list'] ?? tr('none')},
      {tr('Sales Partner'): data['default_sales_partner'] ?? tr('none'), tr('Payment Terms Template'): data['payment_terms'] ?? tr('none')},
      {tr('Credit Limit'): (data["credit_limits"] == null || data["credit_limits"].isEmpty) ? tr('none') : currency(data["credit_limits"][0]['credit_limit'])},
      {tr('Bypass Credit Limit Check at Sales Order'): data['bypass_credit_limit_check'] ?? tr('none')},
      {
        tr("Longitude"): data['longitude'].toString(),
        tr("Latitude"): data['latitude'].toString() ,
      },
    ];
  }



}
