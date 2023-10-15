import 'package:flutter/material.dart';

import '../../../../../models/page_models/model_functions.dart';
import '../../../../../widgets/list_card.dart';

class Totals extends StatelessWidget {
  const Totals({Key? key, required this.items}) : super(key: key);
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    double netTotal = 0;

    for (var item in items) {
      netTotal += item['amount'];
    }

    return Row(
      children: [
        ListTitle(title: 'Net Total', value: currency(netTotal)),
      ],
    );
  }
}
