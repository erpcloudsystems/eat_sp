import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),

              Image.asset("assets/logo.png", width: 230, fit: BoxFit.contain),
              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 40),
              //     child: Lottie.asset('assets/lottie/wemen_logining.json',repeat: true,),
              //     // LinearProgressIndicator(
              //     //   color: LOADING_PROGRESS_COLOR,
              //     //   backgroundColor: Colors.transparent,
              //     // ),
              //   ),
              // ),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
