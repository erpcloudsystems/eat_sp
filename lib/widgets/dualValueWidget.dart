import '../core/constants.dart';
import 'package:flutter/material.dart';

class DualValueWidget extends StatelessWidget {
  const DualValueWidget(this.firstValue, this.secondValue, {Key? key}) : super(key: key);

  final String firstValue, secondValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
        child: Column(
          children: [Text(firstValue), SizedBox(height: 8), Text(secondValue)],
        ),
      ),
    );
  }
}
