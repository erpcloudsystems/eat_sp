import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/resources/app_values.dart';

final double mainTableBlockWidth = DoublesManager.d_100.w;
final double mainTableBlockHeight = DoublesManager.d_52.h;

class RightHandDetailWidgets extends StatelessWidget {
  const RightHandDetailWidgets({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(text),
      width: mainTableBlockWidth,
      height: mainTableBlockHeight,
      padding: EdgeInsets.only(
        left: DoublesManager.d_20,
      ),
      alignment: Alignment.center,
    );
  }
}
