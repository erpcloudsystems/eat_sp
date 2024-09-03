import 'package:flutter/material.dart';
import '../../../../../widgets/list_card.dart';

class Totals extends StatelessWidget {
  const Totals({super.key, required this.items});
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) {
    double netTotal = 0;

    for (var item in items) {
      netTotal += item['amount'];
    }

    return Row(
      children: [
        ListTitle(title: 'Net Total', value: netTotal.toStringAsFixed(4)),
      ],
    );
  }
}
