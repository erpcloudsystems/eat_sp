import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

class UnderDevelopmentScreen extends StatelessWidget {
  UnderDevelopmentScreen({Key? key,required this.message}) : super(key: key);

  final message ;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
      Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/under_construction2.json',
                  repeat: false,
                ),
                Text(message,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
