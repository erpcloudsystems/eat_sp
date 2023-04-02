import 'package:flutter/material.dart';
import '../resources/strings_manager.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(StringsManager.noData),
      ),
      body: Center(
        child: Text(StringsManager.noData),
      ),
    );
  }
}
