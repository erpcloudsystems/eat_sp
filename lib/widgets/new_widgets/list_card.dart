import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/cloud_system_widgets.dart';
import '../../core/constants.dart';
import '../list_card.dart';

class ListCardTest extends StatelessWidget {
  final String id;
  final String title;
  final String status;
  final IconData rightIcon;
  final String rightText;
  final IconData leftIcon;
  final String leftText;
  final void Function(BuildContext context)? onPressed;

  const ListCardTest({
    Key? key,
    required this.id,
    this.title = '',
    this.status = '',
    this.onPressed,
    required this.rightIcon,
    required this.leftIcon,
    required this.rightText,
    required this.leftText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
        border: Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            GLOBAL_BORDER_RADIUS,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
          child: InkWell(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            onTap: () => onPressed != null ? onPressed!(context) : null,
            child: Ink(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  GLOBAL_BORDER_RADIUS,
                ),
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                id,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Status Widget
                        if (status != '' && status != 'Random')
                          Container(
                            width: 1,
                            color: Colors.white,
                            height: 42,
                          ),
                        if (status != '' && status != 'Random')
                          Container(
                            width: 100.w,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: statusColor(status),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusColor(status),
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: StatusWidget(status),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                leftIcon,
                                color: APPBAR_COLOR,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  leftText,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                rightIcon,
                                color: APPBAR_COLOR,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  rightText,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
