import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';

Future<BuildContext> showLoadingDialog(BuildContext context, String message) {
  Completer<BuildContext> completer = Completer<BuildContext>();
  showDialog(
      barrierDismissible: false,
      barrierColor: Colors.grey.withOpacity(0.4),
      context: context,
      builder: (BuildContext dialogContext) {
        if (!completer.isCompleted) completer.complete(dialogContext);

        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(12),
          child: PopScope(
            canPop: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message, style: const TextStyle(fontSize: 17)),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: LinearProgressIndicator(
                      color: LOADING_PROGRESS_COLOR,
                      backgroundColor: Color.fromARGB(0, 172, 121, 121),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
  return completer.future;
}

Future<bool?> checkDialog([
  context,
  String message = '',
  String title = '',
]) {
  final Completer<bool?> completer = Completer<bool?>();
  CoolAlert.show(
    context: context,
    type: CoolAlertType.custom,
    barrierDismissible: true,
    showCancelBtn: true,
    confirmBtnText: 'Yes',
    cancelBtnText: 'No',
    title: (title != '') ? title : null,
    widget: Text(
      message,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      textAlign: TextAlign.center,
    ),
    borderRadius: GLOBAL_BORDER_RADIUS,
    backgroundColor: Colors.white,
    confirmBtnColor: Colors.white,
    confirmBtnTextStyle: const TextStyle(
        color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18.0),
    lottieAsset: 'assets/lottie/warning.json',
    loopAnimation: true,
    onConfirmBtnTap: () => completer.complete(true),
    onCancelBtnTap: () => completer.complete(false),
  );
  return completer.future;
}
