import 'package:easy_localization/easy_localization.dart';

class TaskPageModel {
  final Map<String, dynamic> data;

  TaskPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr('Priority'): data['priority'] ?? tr('none')
      },
      {
        tr('Is Group'): data['is_group'].toString(),
        tr('Parent Task'): data['parent_task'].toString(),
      },
      {
        tr('Project'): data['project'] ?? tr('none'),
        'Subject'.tr(): data['subject'] ?? tr('none')
      },
      {
        tr('Progress'): data['progress'].toString(),
        tr('Expected Time'): data['expected_time'].toString(),
      },
      {
        tr('Start Date'): data['exp_start_date'] ?? tr('none'),
        tr('End Date'): data['exp_end_date'] ?? tr('none')
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
