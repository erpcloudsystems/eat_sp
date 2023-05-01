import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';
import '../../../new_version/core/extensions/status_converter.dart';

class CustomerVisitPageModel {
  final Map<String, dynamic> data;
  final BuildContext context;

  CustomerVisitPageModel(this.context, this.data);

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Customer Address"): data['customer_address'] ?? tr('none'),
      },
    ];
  }

  List<Map<String, String>> get card2Items {
    return [
      {
        tr("Posting Date"): reverse(data['posting_date']),
        tr("Time"): data['time'] ?? 'none',
      },
      {
        tr("Description"): data['description'] ?? tr('none'),
        tr("Status"):
            int.parse(data['docstatus'].toString()).convertStatusToString(),
      },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr("Longitude"): data['longitude'].toString(),
        tr("Latitude"): data['latitude'].toString(),
      },
    ];
  }
}
