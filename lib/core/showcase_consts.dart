import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:uuid/uuid.dart';

/// List Tutorials Keys
final createGK = GlobalKey();
final filterGK = GlobalKey();
final countGK = GlobalKey();
final listSearchGK = GlobalKey();

/// Filters Tutorials Keys
final clearFiltersGK = GlobalKey();
final chooseFiltersGK = GlobalKey();
final applyFiltersGK = GlobalKey();

class CustomShowCase extends StatelessWidget {
  CustomShowCase(
      {Key? key,
      required this.child,
      required this.title,
      required this.description,
      this.overlayPadding,
      required this.globalKey})
      : super(key: key);

  final String title;
  final String description;
  final GlobalKey<State<StatefulWidget>> globalKey;
  final Widget child;
  final EdgeInsets? overlayPadding;

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey,
      title: title,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
      description: description,
      shapeBorder: CircleBorder(),
      radius: BorderRadius.all(Radius.circular(8)),
      overlayPadding: overlayPadding ?? EdgeInsets.zero,
      blurValue: 1,
      // showArrow: false,
      child: child,
    );
  }
}
