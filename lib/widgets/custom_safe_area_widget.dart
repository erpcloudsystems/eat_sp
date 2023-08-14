import 'package:NextApp/core/constants.dart';
import 'package:flutter/material.dart';

class CustomSafeAreaWidget extends StatelessWidget {
  const CustomSafeAreaWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: APPBAR_COLOR,
        child: child,
      ),
    );
  }
}
