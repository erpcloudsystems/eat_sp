import 'package:flutter/material.dart';

class CustomLoadingWithImage extends StatefulWidget {
  const CustomLoadingWithImage({Key? key}) : super(key: key);

  @override
  State<CustomLoadingWithImage> createState() => _CustomLoadingWithImageState();
}

class _CustomLoadingWithImageState extends State<CustomLoadingWithImage>
    with SingleTickerProviderStateMixin {
  double curtain = 1.0;
  bool selected = false;

  late AnimationController controller;
  late Animation<double> animation;

  void load() {
    controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        // Do something
        setState(() {});
      });
    controller.forward();
    // changeColors();
  }

  Future changeColors() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 0), () {
        if (controller.status == AnimationStatus.completed) {
          controller.reverse();
        } else {
          controller.forward();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        width: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/logo.png',
                  color: Colors.grey,
                ),
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: animation.value,
                    child: Image.asset(
                      'assets/logo.png',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
