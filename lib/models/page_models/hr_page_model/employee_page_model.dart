import '../model_functions.dart';
import 'package:easy_localization/easy_localization.dart';

class EmployeePageModel {
  final Map<String, dynamic> data;

  EmployeePageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr('Gender'): data['gender'].toString(),
        tr('Date of Birth'): data['date_of_birth'].toString(),
      },
      {
        tr('Status'): data['status'] ?? tr('none'),
        tr('Date of Joining'): data['date_of_joining'] ?? tr('none'),
      },
      {
        tr('Employment Type'): data['employment_type'] ?? tr('none'),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr('Department'): data['department'] ?? tr('none'),
      },
      {
        tr('Designation'): data['designation'] ?? tr('none'),
        tr("Branch"): data['branch'] ?? tr('none'),
      },
      {tr('Leave Approver'): data['leave_approver'] ?? tr('none')},
      (data['leave_approver'] == null)
          ? {}
          : {
              tr('Leave Approver Name'):
                  data['leave_approver_name'] ?? tr('none'),
            },
      {tr('ERPNext User'): data['user_id'] ?? tr('none')},
      {
        tr('Attendance Device ID (Biometric/RF tag ID)'):
            data['attendance_device_id'] ?? tr('none')
      },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr(''): 'emails', // guide Value for PageExpandableCardItem
      },
      {
        tr(''): 'address', // guide Value PageExpandableCardItem
      },
      {
        tr('Cell Number'): data['cell_number'] ?? tr('none'),
      },
      {
        tr('Holiday List'): data['holiday_list'] ?? tr('none'),
        tr('Default Shift'): data['default_shift'] ?? tr('none')
      },
    ];
  }

  List<Map<String, String>> get emailsItems {
    return [
      {
        tr('Personal Email'): data['emails']['personal_email'] ?? tr('-'),
        tr('Prefered Email'): data['emails']['prefered_email'] ?? tr('-'),
        tr('Company Email'): data['emails']['company_email'] ?? tr('-'),
      },
    ];
  }

  List<Map<String, String>> get addressItems {
    return [
      {
        tr('Current Address'): data['address']['current_address'] ?? tr('-'),
        tr('Permanent Address'):
            data['address']['permanent_address'] ?? tr('-'),
      },
    ];
  }
}
