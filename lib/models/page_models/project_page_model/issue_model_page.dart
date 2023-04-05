import '../model_functions.dart';
import 'package:easy_localization/easy_localization.dart';

class IssuePageModel {
  final Map<String, dynamic> data;

  IssuePageModel(this.data);


  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr('Priority'): data['priority'] ?? tr('none')
      },
      {
        tr('Issue Type'): data['issue_type'].toString(),
        tr('Project'): data['project'].toString(),
      },
      {
        tr('Creation'): data['creation'] ?? tr('none'),
        tr('Modified'): data['modified'] ?? tr('none')
      },
      {
        tr('Opening Date'): data['opening_date'] ?? tr('none'),
        tr('Opening Time'): data['opening_time'] ?? tr('none')
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
