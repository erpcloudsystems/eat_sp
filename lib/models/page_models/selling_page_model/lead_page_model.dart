import '../model_functions.dart';
import 'package:easy_localization/easy_localization.dart';

class LeadPageModel {
  final Map<String, dynamic> data;

  LeadPageModel(this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Status"): data['status'] ?? tr('none'),
        tr('Person Name'): data['lead_name'] ?? tr('none')
      },
      {
        tr('Lead Is A Company'): data['organization_lead'].toString(),
        tr('Company Name'): data['company_name'] ?? tr('none')
      },
      {
        tr('Industry'): data['industry'] ?? tr('none'),
        tr('Market Segment'): data['market_segment'] ?? tr('none')
      },
      {
        tr('Territory'): data['territory'] ?? tr('none'),
        tr('Address'): data['address_line1'] ?? tr('none')
      },
      {
        tr('City'): data['city'] ?? tr('none'),
        tr('Country'): data['country'] ?? tr('none')
      },
      {
        tr('Mobile No.'): data['mobile_no'] ?? tr('none'),
        tr('Email Address'): data['email_id'] ?? tr('none')
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr('Source'): data['source'] ?? tr('none'),
        tr('Campaign Name'): data['campaign_name'] ?? tr('none')
      },
      {
        tr('Request Type'): data['request_type'] ?? tr('none'),
        tr('Lead Owner'):
            (data['lead_owner'] ?? tr('none')).toString().split('@')[0]
      },
      {
        tr('Next Contact By'): data['contact_by'] ?? tr('none'),
        tr('Next Contact Date'):
            (data['contact_date'] ?? tr('none')).toString().split('@')[0]
      },
      {tr('Notes'): formatDescription(data['notes'])},
    ];
  }
}
