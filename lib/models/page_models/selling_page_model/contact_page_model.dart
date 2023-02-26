import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';

class ContactPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  ContactPageModel(this.context, this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("First Name"): data['first_name'] ?? tr('none'),
        tr("User"): data['user'] ?? tr('none'),
      },
      {
        tr("Mobile"): data['mobile_no'] ?? tr('none'),
        tr("Phone"): data['phone'] ?? tr('none'),
      },
      {
        tr("Email"): data['email_id'] ?? tr('none'),
        tr("Is Primary Contact"): data['is_primary_contact'].toString(),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      if (data['links'] != null)
        {
          // tr("Name"): data['links'][0]['name'] ?? tr('none'),
          tr("Link Doctype"): data['links'][0]['link_doctype'] ?? tr('none'),
          tr("Link Name"): data['links'][0]['link_name'] ?? tr('none'),
        },
      // if(data['links']!=null)

      // {
      //   tr("Link Title"): data['links'][0]['link_title'] ?? tr('none'),
      // },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr("status"): data['status'] ?? tr('none'),
        tr("Advance Account"): data['advance_account'] ?? tr('none')
      },
      {
        tr("Company"): data['company'] ?? tr('none'),
        tr("Mode of Payment"): data['mode_of_payment'] ?? tr('none'),
      },
    ];
  }
}
