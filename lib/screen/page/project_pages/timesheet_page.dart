import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/comments_button.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/project_page_model/timesheet_page_model.dart';

class TimesheetPage extends StatelessWidget {
  const TimesheetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;
    for (var k in data.keys) log("➡️ $k: ${data[k]}");
    final Color? color = context.read<ModuleProvider>().color;
    final model = TimesheetPageModel(data);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        /// Task details
        PageCard(
          header: [
            if (data['docstatus'] != null && data['amended_to'] == null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: context.read<ModuleProvider>().submitDocumentWidget(),
                ),
              ),
            Text(
              'Timesheet',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                context.read<ModuleProvider>().pageId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
              1,
              statusColor(data['status'] ?? 'none') != Colors.transparent
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle,
                            color: statusColor(data['status'] ?? 'none'),
                            size: 12),
                        SizedBox(width: 8),
                        FittedBox(
                          child: Text(data['status'] ?? 'none'),
                          fit: BoxFit.fitHeight,
                        ),
                      ],
                    )
                  : Text(data['status'] ?? 'none'),
            ),
          ],
        ),

        /// TIME LOGS
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            //border: Border.all(color: Colors.blueAccent),
          ),
          child: Center(
            child: Text(
              'Time Logs',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
        ),
        SizedBox(
          child: (data['time_logs'] != null && data['time_logs'].isNotEmpty)
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: data['time_logs'].length,
                  itemBuilder: (_, index) => PageCard(
                    items: [
                      {
                        'Activity': data['time_logs'][index]['activity_type'],
                        'Project': data['time_logs'][index]['project'],
                        'Hours': data['time_logs'][index]['hours'].toString(),
                      }
                    ],
                  ),
                )
              : NothingHere(),
        ),

        /// Time description
        PageCard(
          items: model.card2Items,
        ),

        /// Comment button
        CommentsButton(color: color),

        /// Connections
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            //border: Border.all(color: Colors.blueAccent),
          ),
          child: Center(
            child: Text(
              'Connections',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: (data['conn'] != null && data['conn'].isNotEmpty)
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: data['conn'].length,
                  itemBuilder: (_, index) => ConnectionCard(
                      imageUrl: data['conn'][index]['icon'] ?? tr('none'),
                      docTypeId: data['conn'][index]['name'] ?? tr('none'),
                      count: data['conn'][index]['count'].toString()))
              : NothingHere(),
        ),
      ],
    );
  }
}
