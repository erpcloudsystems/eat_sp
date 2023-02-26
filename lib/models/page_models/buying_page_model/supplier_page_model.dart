import '../model_functions.dart';
import 'package:easy_localization/easy_localization.dart';

class SupplierPageModel {
  final Map<String, dynamic> data;

  SupplierPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Supplier Balance"): currency(data['balance']),
        tr('Disabled'): data['disabled'].toString()
      },
      {
        tr('Supplier Type'): data['supplier_type'] ?? tr('none'),
        tr('Supplier Group'): data['supplier_group'] ?? tr('none')
      },
      // {tr('Territory'): data['territory'] ?? tr('none'), tr('Market Segment'): data['market_segment'] ?? tr('none')},
      {tr('Tax ID'): data['tax_id'] ?? tr('none')},
      {
        tr('Supplier Primary Address'):
            data['supplier_primary_address'] ?? tr('none')
      },
      // {
      //   tr('Primary Address'):
      //       formatDescription(data['primary_address'] ?? tr('none'))
      // },
      {
        tr('Address Line'): data['address_line1'] ?? tr('none'),
      },
      {
        tr('Supplier Primary Contact'):
            data['supplier_primary_contact'] ?? tr('none'),
      },
      {
        tr('Country'): data['country'] ?? tr('none'),
        tr('City'): data['city'] ?? tr('none')
      },
      {
        tr('Email Id'): data['email_id'] ?? tr('none'),
        tr('Mobile No'): data['mobile_no'] ?? tr('none')
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Currency"): data['default_currency'] ?? tr('none'),
        tr('Price List'): data['default_price_list'] ?? tr('none')
      },
      {tr('Payment Terms Template'): data['payment_terms'] ?? tr('none')},
    ];
  }
}
