import 'package:flutter/material.dart';

import '../main.dart';
import '../screen/home_screen.dart';
import '../screen/page/common_page_widgets/comments.dart';

showSnackBar(String message, BuildContext context, {Color? color}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: color ?? Theme.of(context).colorScheme.secondary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      content: Text(
        message,
        style: const TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
      )));
}

showErrorSnackBar(String message, error, BuildContext context, {Color? color}) {
  scaffoldMessengerKey.currentState!.clearSnackBars();
  scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: color ?? Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message),
          TextButton(
              onPressed: () {
                showDialog(
                    context: (context),
                    builder: (_) => AlertDialog(
                          backgroundColor: Colors.white,
                          insetPadding: const EdgeInsets.all(10),
                          content: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    child: Center(
                                        child: Text(error,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)))),
                              ],
                            ),
                          ),
                        ));
              },
              child: const Text('More'))
        ],
      )));
}
