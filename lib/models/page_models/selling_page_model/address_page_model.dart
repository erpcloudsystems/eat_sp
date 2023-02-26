import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddressPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  AddressPageModel(this.context, this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Address Title"): data['address_title'] ?? tr('none'),
        tr("Address Type"): data['address_type'] ?? tr('none'),
      },
      {
        tr("Address Line 1"): data['address_line1'] ?? tr('none'),
      },
      {
        tr("City/Town"): data['city'] ?? tr('none'),
        tr("Country"): data['country'] ?? tr('none'),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      (data['reference'] != null)
          ? {
              tr("Link Doctype"):
                  data['reference'][0]['link_doctype'] ?? tr('none'),
              tr("Link Name"): data['reference'][0]['link_name'] ?? tr('none')
            }
          : {tr("Link Doctype"): tr('none'), tr("Link Name"): tr('none')},
      {
        tr("Is Primary"): data['is_primary_address'].toString(),
      },
      {
        tr("Longitude"): data['longitude'].toString(),
        tr("Latitude"): data['latitude'].toString(),
      },
    ];
  }
}
