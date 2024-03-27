import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UnderDevelopmentScreen extends StatelessWidget {
  UnderDevelopmentScreen({Key? key, required this.message}) : super(key: key);

  final message;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/under_construction2.json',
                  repeat: false,
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                TextButton(
                  child: Text('Send Token to WhatsApp For Testing'),
                  onPressed: () async {
                    // final box = context.findRenderObject() as RenderBox?;
                    // await Share.share(deviceTokenToSendPushNotification,
                    //     sharePositionOrigin:
                    //         box!.localToGlobal(Offset.zero) & box.size);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
