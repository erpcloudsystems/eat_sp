import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants.dart';
import '../../domain/entities/faq_entity.dart';
import '../../../../../widgets/form_widgets.dart';
import '../../../../core/resources/app_values.dart';

class FaqItem extends StatefulWidget {
  const FaqItem({
    super.key,
    required this.faqs,
    required this.index,
  });

  final List<Faq> faqs;
  final int index;

  @override
  State<FaqItem> createState() => _FaqItemState();
}

bool isSelected = false;

class _FaqItemState extends State<FaqItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected
          ? APPBAR_COLOR.withOpacity(.1)
          : Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomExpandableTile(
        hideArrow: true,
        opened: (opened) => setState(() => isSelected = opened),
        title: Text(
          widget.faqs[widget.index].question,
          style: GoogleFonts.bebasNeue(
              fontSize: DoublesManager.d_18.sp, color: APPBAR_COLOR),
        ),
        children: [
          Text(
            widget.faqs[widget.index].answer,
            style: TextStyle(
                fontSize: DoublesManager.d_18.sp, color: Colors.black),
          )
        ],
      ),
    );
  }
}
