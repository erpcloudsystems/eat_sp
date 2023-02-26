import 'package:easy_localization/easy_localization.dart';

class ItemPageModel {
  final Map<String, dynamic> data;

  ItemPageModel(this.data);

  List<Map<String, String>> get mainTable {
    return [
      {
        tr('Disabled'): data['disabled'].toString(),
        tr('Item Group'): data['item_group'] ?? tr('none')
      },
      {
        tr('Default UOM'): data['uom'] ?? tr('none'),
        tr('Maintain Stock'): data['is_stock_item'].toString()
      },
      {
        tr('Brand'): data['brand'] ?? tr('none'),
        tr('Include In Maunfacturing'):
            data['include_item_in_manufacturing'].toString()
      },
      {
        tr('Is Fixed Asset'): data['is_fixed_asset'].toString(),
        tr('Asset Category'): data['asset_category'] ?? tr('none')
      },
      {
        tr('Is Sales Item'): data['is_sales_item'].toString(),
        tr('Sales UOM'): data['sales_uom'] ?? tr('none')
      },
      {
        tr('Is Purchase Item'): data['is_purchase_item'].toString(),
        tr('Purchase UOM'): data['purchase_uom'] ?? tr('none')
      },
      {
        tr('Description'): data['description'] ?? tr('none'),
      },
    ];
  }
}
