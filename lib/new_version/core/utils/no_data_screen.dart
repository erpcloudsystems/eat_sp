import 'package:flutter/material.dart';
import '../resources/strings_manager.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppStrings.noData),
      ),
      body: Center(child: Text(AppStrings.noData),),
    );
  }
}
