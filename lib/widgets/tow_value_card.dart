import '../core/constants.dart';
import 'package:flutter/material.dart';

class TowValueCard extends StatelessWidget {
  final String first, second;
  final void Function(BuildContext context)? onTap;

  const TowValueCard(this.first, this.second, {required this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
      ),
      margin: const EdgeInsets.all(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
        onTap: onTap == null ? null : () => onTap!(context),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            border: Border.all(color: APPBAR_COLOR, width: 0.8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                Text(first),
                Divider(height: 8, thickness: 0.8),
                Text(second),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
