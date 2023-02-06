import '../../widgets/under_development.dart';
import 'package:flutter/material.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentScreen(
      message:'App Settings still under development'
    );

  }
}
