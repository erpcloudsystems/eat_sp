import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../widgets/create_from_page/create_from_page_button.dart';
import '../../../widgets/create_from_page/create_from_page_consts.dart';
import '../../../models/page_models/stock_page_model/material_request_page_model.dart';

class MaterialRequestPage extends StatelessWidget {
  const MaterialRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = MaterialRequestPageModel(context, data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Row(
              children: [
                CreateFromPageButton(
                  doctype: 'Material Request',
                  data: data,
                  items: data['material_request_type'] == 'Purchase'
                      ? formMaterialRequestToPurchaseOrder
                      : formMaterialRequestStockEntry,
                  disableCreate:
                      data['docstatus'].toString() == "1" ? false : true,
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                const Text('Material Request   ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
                2,
                color != null
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
                widgetNumber: 2)
          ],
        ),
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
                        ? const NothingHere()
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
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
