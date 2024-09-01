import 'package:flutter/material.dart';

class CustomLoadingWithImage extends StatefulWidget {
  const CustomLoadingWithImage({Key? key}) : super(key: key);

  @override
  State<CustomLoadingWithImage> createState() => _CustomLoadingWithImageState();
}

class _CustomLoadingWithImageState extends State<CustomLoadingWithImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25),  // Flicker out
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),  // Flicker in quickly
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 25),  // Flicker out
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),  // Stay on longer
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
                Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                FadeTransition(
                  opacity: _animation,
                  child: Image.asset(
                    'assets/logo.png',
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
