import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/comments_button.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/app_values.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../models/page_models/manufacuting_model/job_card_page_model.dart';

class JobCardPage extends StatelessWidget {
  const JobCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;
    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }
    final Color? color = context.read<ModuleProvider>().color;
    final model = JobCardPageModel(data);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: DoublesManager.d_8),
      children: [
        /// Task details
        PageCard(
          header: [
            //________________________Submitting button___________________________
            if (data['docstatus'] != null && data['amended_to'] == null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: DoublesManager.d_12),
                  child: context.read<ModuleProvider>().submitDocumentWidget(),
                ),
              ),
            //________________________DOCTYPE button & ID ___________________________
            Text(
              DocTypesName.jobCard,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: DoublesManager.d_16.sp,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(DoublesManager.d_4),
              child: Text(
                context.read<ModuleProvider>().pageId,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: DoublesManager.d_4),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          //____________________________Status Section_________________________________
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
              1,
              statusColor(data['status'] ?? 'none') != Colors.transparent
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          color: statusColor(data['status'] ?? 'none'),
                          size: DoublesManager.d_12,
                        ),
                        const SizedBox(width: DoublesManager.d_8),
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(data['status'] ?? 'none'),
                        ),
                      ],
                    )
                  : Text(data['status'] ?? 'none'),
            ),
          ],
        ),
        //____________________________Time Logs Section_________________________________

        /// TIME LOGS
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
          ),
          padding: const EdgeInsets.all(DoublesManager.d_8),
          margin: const EdgeInsets.all(DoublesManager.d_8),
          child: Center(
            child: Text(
              StringsManager.timeLogs.tr(),
              style: TextStyle(
                fontSize: DoublesManager.d_16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          child: (data['time_logs'] != null && data['time_logs'].isNotEmpty)
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: data['time_logs'].length,
                  itemBuilder: (_, index) => PageCard(
                    items: [
                      {
                        StringsManager.employee.tr(): data['time_logs'][index]
                                ['employee'] ??
                            StringsManager.none.tr(),
                        StringsManager.completedQuantity.tr():
                            (data['time_logs'][index]['completed_qty'] ??
                                    StringsManager.none.tr())
                                .toString(),
                      }
                    ],
                  ),
                )
              : const NothingHere(),
        ),

        //____________________________Time Logs Section_________________________________

        /// Comment button
        CommentsButton(color: color),

        /// Connections & Items
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.70,
          child: DefaultTabController(
            length: model.tabs.length,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(DoublesManager.d_8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DoublesManager.d_10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(DoublesManager.d_10),
                    child: TabBar(
                      labelStyle: GoogleFonts.cairo(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      unselectedLabelStyle: GoogleFonts.cairo(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorPadding: EdgeInsets.zero,
                      isScrollable: false,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                      padding: EdgeInsets.zero,
                      tabs: model.tabs,
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    data['items'] == null || data['items'].isEmpty
                        ? const NothingHere()
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: model.items.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ItemWithImageCard(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PageDetailsDialog(
                                          title: model.items[index]['name'] ??
                                              'none',
                                          names: model.subList1Names,
                                          values: model.subList1Item(index));
                                    });
                              },
                              id: model.items[index]['idx'].toString(),
                              imageUrl: model.items[index]['image'].toString(),
                              itemName: model.items[index]['item_name'],
                              names: model.getItemCard(index),
                            ),
                          ),
                    data['conn'] == null || data['conn'].isEmpty
                        ? const NothingHere()
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: data['conn'].length,
                            itemBuilder: (_, index) => ConnectionCard(
                                imageUrl:
                                    data['conn'][index]['icon'] ?? tr('none'),
                                docTypeId:
                                    data['conn'][index]['name'] ?? tr('none'),
                                count:
                                    data['conn'][index]['count'].toString())),
                  ]),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
