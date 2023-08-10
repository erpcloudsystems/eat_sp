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
            (data['for_quantity'] ?? tr('none')).toString(),
      },
      {
        tr(StringsManager.company): data['company'] ?? tr('none'),
        tr(StringsManager.wipWarehouse): data['wip_warehouse'] != null
            ? data['wip_warehouse'][0]
            : tr('none')
      },
      {
        tr(StringsManager.bomNo): data['bom_no'] ?? tr('none'),
        tr(StringsManager.workOrder): data['work_order'] ?? tr('none')
      },
      {
        tr(StringsManager.operation): data['operation'] ?? tr('none'),
        tr(StringsManager.workstation): data['workstation'] ?? tr('none')
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
