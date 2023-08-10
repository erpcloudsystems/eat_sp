import 'package:easy_localization/easy_localization.dart';

import '../../../new_version/core/resources/strings_manager.dart';

class JobCardPageModel {
  final Map<String, dynamic> data;

  JobCardPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr(StringsManager.project): data['project'] ?? tr('none')
      },
      {
        tr(StringsManager.itemName): data['item_name'] ?? tr('none'),
      },
      {
        tr(StringsManager.qtyToManufacture):
            (data['quantity to manufacture'] ?? tr('none')).toString(),
      },
      {
        tr(StringsManager.company): data['Company'] ?? tr('none'),
        tr(StringsManager.wipWarehouse): data['WIP Warehouse'] != null
            ? data['WIP Warehouse'][0]
            : tr('none')
      },
      {
        tr(StringsManager.bomNo): data['BOM No'] ?? tr('none'),
        tr(StringsManager.workOrder): data['Work Order'] ?? tr('none')
      },
      {
        tr(StringsManager.operation): data['Operation'] ?? tr('none'),
        tr(StringsManager.workstation): data['Work Station'] ?? tr('none')
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr('Note'): data['note'] ?? tr('none'),
      },
    ];
  }
}
