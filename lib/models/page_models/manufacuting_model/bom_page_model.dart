import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class BomPageModel {
  final Map<String, dynamic> data;

  BomPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("name"): data['name'] ?? tr('none'),
        tr('Item'): data['item'] ?? tr('none')
      },
      {
        tr('Item Name'): data['item_name'] ?? tr('none'),
      },
      {
        tr('Quantity'): (data['quantity'] ?? tr('none')).toString(),
        tr('UOM'): data['uom'] ?? tr('none')
      },
      {
        tr('Project'): data['Project'] ?? tr('none'),
        tr('Currency'): data['currency'] ?? tr('none'),
      },
      {
        tr('Is Default'): data['is_default'].toString(),
        tr(StringsManager.rateOfMaterialsBasedOn):
            (data['rm_cost_as_per'] ?? tr('none')).toString(),
      },
      {
        tr(StringsManager.allowAlternativeItem):
            (data['allow_alternative_item'] ?? tr('none')).toString(),
        tr(StringsManager.withOperations):
            (data['with_operations'] ?? tr('none')).toString()
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr('Description'): data['description'] ?? tr('none'),
      },
    ];
  }
}
