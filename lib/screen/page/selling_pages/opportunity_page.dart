import '../../../models/page_models/selling_page_model/opportunity_page_model.dart';
import '../../../provider/module/module_provider.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../widgets/create_from_page/create_from_page_button.dart';
import '../../../widgets/create_from_page/create_from_page_consts.dart';
import '../../../widgets/page_group.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../widgets/comments_button.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../widgets/nothing_here.dart';

class OpportunityPage extends StatelessWidget {
  const OpportunityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = OpportunityPageModel(context, data);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        PageCard(
          color: color,
          items: model.card1Items,
          header: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CreateFromPageButton(
                  doctype: 'Opportunity',
                  data: data,
                  items: data['opportunity_from'] == "Customer"
                      ? fromOpportunity
                      : fromOpportunity2,
                  disableCreate: false,
                ),
              ],
            ),
            Text('Opportunity',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('Opportunity From: ' + (data['opportunity_from'] ?? 'none')),
            Text('${data['opportunity_from'] ?? ""} : ' +
                (data['party_name'] ?? 'none')),
            Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(data['customer_name'] ?? 'none')),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
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
            )
          ],
        ),

        /// second card ///
        PageCard(
          color: color,
          items: model.card2Items,
          swapWidgets: [
            SwapWidget(
                5,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value: (data['with_items'] ?? 0) == 0 ? false : true,
                        onChanged: null))),
          ],
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
                  child: TabBarView(children: [
                    data['items'] == null || data['items'].isEmpty
                        ? NothingHere()
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            //shrinkWrap: true,
                            itemCount: model.items.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ItemWithImageCard(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return PageDetailsDialog(
                                              title: model.items[index]
                                                      ['name'] ??
                                                  'none',
                                              names: model.itemListNames,
                                              values:
                                                  model.itemListValues(index),
                                            );
                                          });
                                    },
                                    id: model.items[index]['idx'].toString(),
                                    imageUrl:
                                        model.items[index]['image'].toString(),
                                    itemName: model.items[index]['item_name'],
                                    names: model.getItemCard(index)),
                          ),
                    data['conn'] == null || data['conn'].isEmpty
                        ? NothingHere()
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
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
