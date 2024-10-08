import 'package:NextApp/new_version/core/extensions/status_converter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../models/page_models/hr_page_model/journal_entry_page_model.dart';

class JournalEntryPage extends StatelessWidget {
  const JournalEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = JournalEntryPageModel(context, data);

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Text('Journal Entry',
                    style: TextStyle(
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
            const SizedBox(height: 4),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
              2,
              statusColor(int.parse(data['docstatus'].toString())
                          .convertStatusToString()) !=
                      Colors.transparent
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle,
                            color: statusColor(
                                int.parse(data['docstatus'].toString())
                                    .convertStatusToString()),
                            size: 12),
                        const SizedBox(width: 8),
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(int.parse(data['docstatus'].toString())
                              .convertStatusToString()),
                        ),
                      ],
                    )
                  : Text(int.parse(data['docstatus'].toString())
                      .convertStatusToString()),
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
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
                    data['accounts'] == null || data['accounts'].isEmpty
                        ? const NothingHere()
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: data['accounts'].length,
                            itemBuilder: (_, index) => ItemCard3(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) => PageDetailsDialog(
                                          names: model.accountListNames,
                                          values:
                                              model.accountListValues(index),
                                          title: (data['accounts'][index]
                                                      ['name'] ??
                                                  tr('none'))
                                              .toString())),
                                  id: data['accounts'][index]['idx'].toString(),
                                  values: model.accountCardValues(index),
                                )),
                  ]),
                )
              ],
            ),
          ),
        ),
        PageCard(
          color: color,
          items: model.card2Items,
        ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
