import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../screen/home_screen.dart';
import 'comments.dart';

showSnackBar(String message, BuildContext context, {Color? color}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color ?? Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      content: Text(
        message,
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
      )));
}

showErrorSnackBar(String message, error, BuildContext context, {Color? color}) {
  scaffoldMessengerKey.currentState!.clearSnackBars();
  scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
      duration: Duration(seconds: 4),
      backgroundColor: color ?? Colors.white,
      shape: RoundedRectangleBorder(
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
                          insetPadding: EdgeInsets.all(10),
                          content: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
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
              child: Text('More'))
        ],
      )));
}
