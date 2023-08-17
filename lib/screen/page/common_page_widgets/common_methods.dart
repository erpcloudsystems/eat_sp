import 'package:flutter/material.dart';

import '../../../new_version/core/resources/app_values.dart';

class CommonPageMethods {
  static const bottomSheetBorderRadius = DoublesManager.d_18;
  
  static Future<dynamic> commonBottomSheet(
      {required BuildContext context, required Widget builderWidget}) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        useSafeArea: true,
        builder: (_) => builderWidget);
  }

}
