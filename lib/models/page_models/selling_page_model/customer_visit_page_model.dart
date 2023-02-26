import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../model_functions.dart';

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
        //tr("Date"): data['time'].split(" ")[0],
        tr("Time"): data['time'] ?? 'none',
      },
      {
        tr("Description"): data['description'] ?? tr('none'),
      },
    ];
  }

  List<Map<String, String>> get card3Items {
    return [
      {
        tr("Longitude"): data['longitude'].toString(),
        tr("Latitude"): data['latitude'].toString(),
      },
      {
        tr("Location"): data['location'] ?? tr('none'),
      },
    ];
  }
}
