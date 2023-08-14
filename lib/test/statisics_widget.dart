import 'package:NextApp/core/constants.dart';
import 'package:flutter/material.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({
    Key? key,
    required this.text,
    this.color = APPBAR_COLOR,
    required this.number,
  }) : super(key: key);
  final String number;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Text(
              number,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
