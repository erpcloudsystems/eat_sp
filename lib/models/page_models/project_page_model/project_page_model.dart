import '../model_functions.dart';
import 'package:easy_localization/easy_localization.dart';

class ProjectPageModel {
  final Map<String, dynamic> data;

  ProjectPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr('Priority'): data['priority'] ?? tr('none')
      },
      {
        tr('Is Active'): data['is_active'].toString(),
        tr('Project Name'): data['project_name'].toString(),
      },
      {
        tr('Department'): data['department'] ?? tr('none'),
        tr('Percent Complete'): data['percent_complete'].toString()
      },
      {
        tr('Project Type'): data['project_type'] ?? tr('none'),
        tr('Task Completion'): data['percent_complete_method'] ?? tr('none'),
      },
      {
        tr('Customer'): data['customer'] ?? tr('none'),
      },
      {
        tr('Start Date'): data['expected_start_date'] ?? tr('none'),
        tr('End Date'): data['expected_end_date'] ?? tr('none')
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr('Notes'): data['notes'] ?? tr('none'),
      },
    ];
  }
}
