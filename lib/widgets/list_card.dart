import 'package:flutter/material.dart';

import '../core/cloud_system_widgets.dart';
import '../core/constants.dart';

///this is a generic class presents any list card
class ListCard extends StatelessWidget {
  final String id;
  final String title;
  final String status;
  final List<String> names, values;
  final void Function(BuildContext context)? onPressed;

  const ListCard({
    Key? key,
    required this.id,
    this.title = '',
    this.status = '',
    required this.names,
    required this.values,
    this.onPressed,
  })  : assert(names.length == values.length),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> secondRow = [];
    for (int i = 3; i < names.length; i++) {
      secondRow.add(ListTitle(title: names[i], value: values[i]));
      if (i < names.length - 1)
        secondRow.add(
          Container(
            width: 1,
            color: Colors.white,
            height: 42,
          ),
        );
    }

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
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
          child: InkWell(
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            onTap: () => onPressed != null ? onPressed!(context) : null,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (statusColor(status) != Colors.transparent)
                      Container(color: statusColor(status), width: 6),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (title != '')
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Center(
                                          child: Text(
                                            title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Center(
                                        child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(id, maxLines: 1))),
                                  )),
                                  if (statusColor(status) != Colors.transparent)
                                    SizedBox(width: 6)
                                ],
                              ),
                            ),
                            if (names.isNotEmpty)
                              Divider(
                                thickness: 1,
                                color: Colors.white,
                                height: 0,
                              ),
                            if (names.isNotEmpty)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ListTitle(title: names[0], value: values[0]),
                                  if (names.length > 1)
                                    ListTitle(
                                        title: names[1], value: values[1]),
                                  if (names.length > 2)
                                    ListTitle(
                                        title: names[2], value: values[2]),
                                  if (statusColor(status) != Colors.transparent)
                                    SizedBox(width: 6)
                                ],
                              ),
                            if (secondRow.isNotEmpty || status.isNotEmpty)
                              Divider(
                                thickness: 1,
                                color: Colors.white,
                                height: 8,
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ...secondRow,
                                if (status != '' &&
                                    status != 'Random' &&
                                    secondRow.isNotEmpty)
                                  Container(
                                      width: 1,
                                      color: Colors.white,
                                      height: 42),
                                if (status != '' && status != 'Random')
                                  StatusWidget(status),
                                if (statusColor(status) != Colors.transparent)
                                  SizedBox(width: 6)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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

///presents a cell of title and value
///structured of Column contains [title], [value]
///with fixed height of 55
class ListTitle extends StatelessWidget {
  final String title;
  final String? value;
  final int flex;
  final Widget? child;

  const ListTitle({required this.title, this.value, this.flex = 1, this.child})
      : assert(value != null || child != null);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != '')
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1),
              ),
            ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: child ??
                    Text(
                      value!,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///simple function takes a date and returns a formatted String: day-month-year
String formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

String formatDateAndTime(DateTime date) =>
    '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}';

String formatTime(TimeOfDay date) =>
    '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:00';

class StatusWidget extends StatelessWidget {
  final String status;

  const StatusWidget(this.status);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Text(
        //   'Status',
        //   style: const TextStyle(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        statusColor(status) != Colors.transparent
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(Icons.circle, color: statusColor(status), size: 12),
                  // SizedBox(width: 8),
                  FittedBox(
                    child: Text(
                      status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ],
              )
            : Text(status),
      ],
    );
  }
}
