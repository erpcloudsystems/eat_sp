import 'package:easy_localization/easy_localization.dart';

class TimesheetPageModel {
  final Map<String, dynamic> data;

  TimesheetPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr('Project'): data['parent_project'] ?? tr('none')
      },
      {
        tr('Customer'): data['customer'].toString(),
        tr('Employee'): data['employee_name'].toString(),
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
