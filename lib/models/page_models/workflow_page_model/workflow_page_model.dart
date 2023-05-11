import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WorkflowPageModel {
  final Map<String, dynamic> data;

  WorkflowPageModel(this.data);

  final List<Tab> tabs = const [
    Tab(text: 'States'),
    Tab(text: 'Transactions'),
  ];

  List<Map<String, String>> get card1Items {
    return [
      {
        tr("Workflow Name"): data['workflow_name'] ?? tr('none'),
        tr('Document Type'): data['document_type'] ?? tr('none')
      },
      {
        tr('Is Active'): data['is_active'].toString(),
        tr('Override Status'): data['override_status'].toString(),
      },

      {
        tr('Creation'): data['creation'] ?? tr('none'),
        tr('Modified'): data['modified'] ?? tr('none')
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
