import 'package:easy_localization/easy_localization.dart';

class IssuePageModel {
  final Map<String, dynamic> data;

  IssuePageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr('Subject'): data['subject'] ?? tr('none')
      },
      {
        tr('Issue Type'): data['issue_type'] ?? tr('none'),
      },
      {
        tr('Priority'): data['priority'] ?? tr('none'),
        tr('Project'): data['project'] ?? tr('none'),
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
