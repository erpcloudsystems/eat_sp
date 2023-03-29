import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

Widget CustomTextField(
    String title, TextEditingController controller, int width, int height) {
  return Container(
    width: width.toDouble(),
    height: height.toDouble(),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date.';
        }
        return null;
      },
    ),
  );
}

Widget DatePicker(String dpTitle, TextEditingController controller,
    BuildContext context, int width, int height) {
  return Container(
    width: width.toDouble(),
    height: height.toDouble(),
    child: TextFormField(
      style: TextStyle(color: Colors.black),
      readOnly: true,
      enabled: true,
      controller: controller,
      decoration: InputDecoration(
          suffixIcon: Icon(Icons.date_range), labelText: dpTitle),
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2015),
          lastDate: DateTime(2025),
        ).then((selectedDate) {
          if (selectedDate != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
          }
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date.';
        }
        return null;
      },
    ),
  );
}

Widget statusText(Color statusColor, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Icon(
        Icons.circle,
        color: statusColor,
        size: 12,
      ),
      SizedBox(width: 8),
      Text(text)
    ],
  );
}

Color statusColor(String status) {
  switch (status) {
    case 'Random':
      return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
          .withOpacity(1.0);
    case "Closed":
      return Colors.red;
    case "Lost":
      return Colors.red;
    case "Draft":
      return Colors.red;
    case 'Cancelled':
      return Colors.red;
    case 'Overdue':
      return Colors.red;
    case 'Expired':
      return Colors.red;
    case 'To Deliver and Bill':
      return Colors.orange;
    case 'To Bill':
      return Colors.orange;
    case 'To Deliver':
      return Colors.orange;
    case 'Pending':
      return Colors.orange;
    case 'Partially Ordered':
      return Colors.orange;
    case 'bill':
      return Colors.orange;
    case 'Unpaid':
      return Colors.orange;
    case 'Open':
      return Colors.orange;
    case 'Replied':
      return Colors.orange;
    case 'Lead':
      return Colors.orange;
    case 'Opportunity':
      return Colors.orange;
    case 'Quotation':
      return Colors.orange;
    case 'Paid':
      return Colors.green;
    case 'Completed':
      return Colors.green;
    case 'Converted':
      return Colors.green;
    case 'Transferred':
      return Colors.green;
    case 'Received':
      return Colors.green;
    case 'Ordered':
      return Colors.green;
    case 'Submitted':
      return Colors.green;
    case 'Closed':
      return Colors.black;
    case 'Hold':
      return Colors.black;

    //HR
    case 'Approved':
      return Colors.green;
    case 'Open':
      return Colors.orange;
    case 'Cancelled':
      return Colors.red;
    case 'Rejected':
      return Colors.red;

    case 'Active':
      return Colors.green;
    case 'Inactive':
      return Colors.red;
    case 'Suspended':
      return Colors.orange;
    case 'Left':
      return Colors.grey;
    case 'Claimed':
      return Colors.blue;
    // Project
    case 'Working':
      return Colors.green;
    case 'Template':
      return Colors.blue;
    case 'Pending Review':
      return Colors.orange;

    default:
      return Colors.transparent;
  }
}
