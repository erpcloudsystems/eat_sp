import 'package:flutter/material.dart';

import '../../../../core/resources/app_values.dart';

class UserProfileCard extends StatelessWidget {
  final String title, subtitle;
  final double? titleFontSize, leadingPadding;
  final IconData icon;
  const UserProfileCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.titleFontSize,
    this.leadingPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(DoublesManager.d_15),
      elevation: DoublesManager.d_10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(DoublesManager.d_30))),
      child: ListTile(
        minLeadingWidth: leadingPadding ?? DoublesManager.d_40,
        leading: Padding(
          padding: const EdgeInsets.only(top: DoublesManager.d_8),
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: TextStyle(
              color: const Color.fromARGB(255, 99, 96, 96),
              fontSize: titleFontSize ?? DoublesManager.d_15),
        ),
        subtitle: Text(
          subtitle,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
