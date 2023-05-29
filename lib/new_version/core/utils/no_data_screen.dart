import 'package:flutter/material.dart';
import '../resources/strings_manager.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(StringsManager.noData),
      ),
      body: const Center(
        child: Text(StringsManager.noData),
      ),
    );
  }
}
