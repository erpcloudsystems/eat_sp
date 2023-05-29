import 'package:flutter/material.dart';

import '../../widgets/under_development.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnderDevelopmentScreen(
        message: 'App settings still under development');
  }
}
