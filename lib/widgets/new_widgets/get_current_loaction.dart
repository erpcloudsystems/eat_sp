import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/new_controller/home_provider.dart';

class GetCurrentLocationButton extends StatelessWidget {
  const GetCurrentLocationButton({super.key, required this.docId});
  final String docId;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return ElevatedButton(
          onPressed: homeProvider.customerLocationLoading
              ? null
              : () async {
                  await homeProvider.updateCustomerLocation(
                    customerName: docId,
                  );
                },
          child: homeProvider.customerLocationLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text('Update customer location'.tr()),
        );
      },
    );
  }
}
