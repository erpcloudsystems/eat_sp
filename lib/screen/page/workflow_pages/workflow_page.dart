import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../core/constants.dart';
import '../../../models/page_models/workflow_page_model/workflow_page_model.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/comments_button.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/page_group.dart';

class WorkflowPage extends StatelessWidget {
  const WorkflowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;
    final Color? color = context.read<ModuleProvider>().color;
    final model = WorkflowPageModel(data);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        /// Task details
        PageCard(
          header: [
            Text(
              'Workflow',
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
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
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

        /// Comment button
        CommentsButton(color: color),
        /// States and Transactions
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.70,
          child: DefaultTabController(
            length: model.tabs.length,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
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
                  child: TabBarView(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: (data['states'] != null &&
                                data['states'].isNotEmpty)
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                shrinkWrap: true,
                                itemCount: data['states'].length,
                                itemBuilder: (_, index) => PageCard(
                                  items: [
                                    {
                                      "State": data['states'][index]['state'] ?? 'none'.tr(),
                                      "Doc Status": data['states'][index]['docstatus'].toString(),
                                      "Allow Edit": data['states'][index]['allow_edit'] ?? 'none'.tr(),
                                    }
                                  ],
                                ),
                              )
                            : NothingHere(),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: (data['transitions'] != null &&
                                data['transitions'].isNotEmpty)
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                shrinkWrap: true,
                                itemCount: data['transitions'].length,
                                itemBuilder: (_, index) => PageCard(
                                  items: [
                                    {
                                      "State": data['transitions'][index]['state'] ?? 'none'.tr(),
                                      "Action": data['transitions'][index]['action'] ?? 'none'.tr(),
                                      "Next State": data['transitions'][index]['next_state'] ?? 'none'.tr(),
                                    }
                                  ],
                                ),
                              )
                            : NothingHere(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
