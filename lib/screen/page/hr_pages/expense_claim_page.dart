import 'package:next_app/provider/module/module_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:next_app/models/page_models/selling_page_model/sales_order_model.dart';
import 'package:next_app/core/cloud_system_widgets.dart';
import 'package:next_app/widgets/dialog/page_details_dialog.dart';
import 'package:next_app/widgets/nothing_here.dart';
import 'package:next_app/widgets/page_group.dart';

import '../../../core/constants.dart';
import '../../../models/page_models/buying_page_model/purchase_order_page_model.dart';
import '../../../models/page_models/hr_page_model/attendance_request_page_model.dart';
import '../../../models/page_models/hr_page_model/employee_advance_page_model.dart';
import '../../../models/page_models/hr_page_model/employee_checkin_page_model.dart';
import '../../../models/page_models/hr_page_model/expense_claim_page_model.dart';
import '../../../models/page_models/hr_page_model/leave_application_page_model.dart';
import '../../../service/service.dart';
import '../../../widgets/comments_button.dart';

class ExpenseClaimPage extends StatelessWidget {
  const ExpenseClaimPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = ExpenseClaimPageModel(context, data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Expense Claim',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('Employee Id: ' + (data['employee'] ?? 'none')),
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
                3,
                Checkbox(
                    value: (data['is_paid'] ?? 0) == 0 ? false : true,
                    onChanged: null),
                widgetNumber: 1)
          ],
        ),
        PageCard(
          color: color,
          items: model.card2Items,
        ),
        PageCard(
          color: color,
          items: model.card3Items,
        ),
        CommentsButton(color: color),
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
                    data['expenses'] == null ||
                            data['expenses'].isEmpty
                        ? NothingHere()
                        : ListView.builder(physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: data['expenses'].length,
                            itemBuilder: (_, index) => ItemCard3(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) => PageDetailsDialog(
                                          names: model.expenseListNames,
                                          values:
                                              model.expenseListValues(index),
                                          title: (data['expenses']
                                                      [index]['name'] ??
                                                  tr('none'))
                                              .toString())),
                                  id: data['expenses'][index]['idx']
                                      .toString(),
                                  values: model.expenseCardValues(index),
                                )),

                    data['conn'] == null || data['conn'].isEmpty
                        ? NothingHere()
                        : ListView.builder(physics: BouncingScrollPhysics(),
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
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
