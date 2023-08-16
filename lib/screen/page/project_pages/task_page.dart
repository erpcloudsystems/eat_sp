import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../widgets/comments.dart';
import '../../../widgets/page_common_button.dart';
import '../../../widgets/page_group.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../widgets/create_from_page/create_from_page_consts.dart';
import '../../../widgets/create_from_page/create_from_page_button.dart';
import '../../../models/page_models/project_page_model/task_page_model.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;
    for (var k in data.keys) {
      log("$k : ${data[k]}");
    }
    final Color? color = context.read<ModuleProvider>().color;
    final model = TaskPageModel(data);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        /// Task details
        PageCard(
          header: [
            Row(
              children: [
                CreateFromPageButton(
                  doctype: DocTypesName.task,
                  data: data,
                  items: fromTask,
                  disableCreate: false,
                ),
              ],
            ),
            const Text(
              'Task',
              style: TextStyle(
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
            const SizedBox(height: 4),
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
                        const SizedBox(width: 8),
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(data['status'] ?? 'none'),
                        ),
                      ],
                    )
                  : Text(data['status'] ?? 'none'),
            ),
            SwapWidget(
              2,
              SizedBox(
                height: 30,
                child: Checkbox(
                  value: (data['organization_lead'] ?? 0) == 0 ? false : true,
                  onChanged: null,
                ),
              ),
            )
          ],
        ),

        /// Task description
        PageCard(items: model.card2Items),

        // /// Connections
        // Container(
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
        //   ),
        //   padding: const EdgeInsets.all(8),
        //   margin: const EdgeInsets.all(8),
        //   child: const Center(
        //     child: Text(
        //       'Connections',
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.20,
        //   child: (data['conn'] != null && data['conn'].isNotEmpty)
        //       ? ListView.builder(
        //           physics: const BouncingScrollPhysics(),
        //           padding: const EdgeInsets.symmetric(horizontal: 12),
        //           shrinkWrap: true,
        //           itemCount: data['conn'].length,
        //           itemBuilder: (_, index) => ConnectionCard(
        //               imageUrl: data['conn'][index]['icon'] ?? tr('none'),
        //               docTypeId: data['conn'][index]['name'] ?? tr('none'),
        //               count: data['conn'][index]['count'].toString()))
        //       : const NothingHere(),
        // ),

        /// Comment button
        GridView.count(
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 2.8,
          children: [
            PageCommonButton(
              sheetFunction: showCommentsSheet,
              buttonText: StringsManager.comments.tr(),
              dataKey: 'comments',
              buttonIcon: Icons.message,
            ),
            // TODO: sheetFunction isn't ready
            PageCommonButton(
              sheetFunction: showCommentsSheet,
              buttonText: StringsManager.assignedTo.tr(),
              dataKey: '_assign',
              buttonIcon: Icons.person,
            ),
            // TODO: sheetFunction & database Key
            PageCommonButton(
              sheetFunction: showCommentsSheet,
              buttonText: StringsManager.logs.tr(),
              dataKey: 'comments',
              buttonIcon: Icons.history,
            ),
            // TODO: sheetFunction & database Key
            PageCommonButton(
              sheetFunction: showCommentsSheet,
              buttonText: StringsManager.sharedWith.tr(),
              dataKey: '_assign',
              buttonIcon: Icons.share,
            ),
          ],
        )
        // Row(
        //   children: [
        //     PageCommonButton(
        //       sheetFunction: showCommentsSheet,
        //       buttonText: StringsManager.comments.tr(),
        //       dataKey: 'comments',
        //       buttonIcon: Icons.message,
        //     ),
        //     PageCommonButton(
        //       sheetFunction: showCommentsSheet,
        //       buttonText: StringsManager.assigns.tr(),
        //       dataKey: '_assign',
        //       buttonIcon: Icons.person,
        //     ),
        //   ],
        // ),
        // Row(
        //   children: [
        //     CommentsButton(color: color),
        //     CommentsButton(color: color),
        //   ],
        // ),
        ,
        const SizedBox(
          height: 100,
        )
      ],
    );
  }
}
