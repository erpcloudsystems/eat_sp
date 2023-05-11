import 'package:flutter/material.dart';

class RowButtonAddWidget extends StatelessWidget {
  const RowButtonAddWidget({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  8.0,
                ),
              ),
            ),
          ),
          child: Icon(
            Icons.add,
          ),
        )
      ],
    );
  }
}
