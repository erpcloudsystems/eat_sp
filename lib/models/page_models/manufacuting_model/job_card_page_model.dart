import 'package:easy_localization/easy_localization.dart';

import '../../../new_version/core/resources/strings_manager.dart';

class JobCardPageModel {
  final Map<String, dynamic> data;

  JobCardPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr(StringsManager.item): data['item'] ?? tr('none')
      },
      {
        tr(StringsManager.itemName): data['item_name'] ?? tr('none'),
      },
      {
        tr('Start Date'): data['start_date'] ?? tr('none'),
        tr('End Date'): data['end_date'] ?? tr('none')
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
