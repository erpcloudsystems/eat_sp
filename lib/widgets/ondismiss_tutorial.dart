import 'package:flutter/material.dart';

class DissmissTutorial extends StatefulWidget {
   DissmissTutorial(
      {Key? key, required this.child, this.isSlid = false, required this.height})
      : super(key: key);

  final Widget child;
  final double height;
  bool isSlid;
  @override
  _DissmissTutorialState createState() => _DissmissTutorialState();
}

class _DissmissTutorialState extends State<DissmissTutorial> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height,
          margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.redAccent),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Icon(Icons.delete_forever, color: Colors.white, size: 30),
            ),
          ),
        ),
        AnimatedSlide(
          offset: widget.isSlid ? Offset(-0.2, 0) : Offset(0, 0),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          child: widget.child,
        )
      ],
    );
  }
}
