import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/page_group.dart';
import '../../../widgets/comments_button.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/hr_page_model/leave_application_page_model.dart';

class LeaveApplicationPage extends StatelessWidget {
  const LeaveApplicationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = LeaveApplicationPageModel(context, data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Leave Application     ',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                if (data['docstatus'] != null && data['amended_to'] == null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child:
                          context.read<ModuleProvider>().submitDocumentWidget(),
                    ),
                  )
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('Employee: ' + (data['employee'] ?? 'none')),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(data['employee_name'] ?? 'none'),
            ),
            SizedBox(height: 4),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
                1,
                color != null
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
                widgetNumber: 2)
          ],
        ),

        ///
        /// card 2
        ///
        PageCard(color: color, items: model.card2Items, swapWidgets: [
          SwapWidget(
              3,
              Checkbox(
                  value: (data['half_day'] ?? 0) == 0 ? false : true,
                  onChanged: null),
              widgetNumber: 1)
        ]),

        CommentsButton(color: color),

        // if (data['conn'] != null || data['conn'].isNotEmpty)
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(BORDER_RADIUS),
        //       //border: Border.all(color: Colors.blueAccent),
        //     ),
        //     child: Center(child: Text('Connections', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        //     padding: const EdgeInsets.all(8),
        //     margin: const EdgeInsets.all(8),
        //   ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.45,
        //   child: (data['conn'] != null && data['conn'].isNotEmpty)
        //       ? ListView.builder(physics: BouncingScrollPhysics(),
        //       padding: const EdgeInsets.symmetric(horizontal: 12),
        //       shrinkWrap: true,
        //       itemCount: data['conn'].length,
        //       itemBuilder: (_, index) {
        //         print(data['conn']);
        //         return ConnectionCard(
        //             imageUrl: data['conn'][index]['icon'] ?? tr('none'),
        //             docTypeId: data['conn'][index]['name'] ?? tr('none'),
        //             count: data['conn'][index]['count'].toString());
        //       })
        //       : NothingHere(),
        // ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
