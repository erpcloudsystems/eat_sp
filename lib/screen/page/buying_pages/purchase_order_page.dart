import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/resources/strings_manager.dart';
import '../../../widgets/create_from_page/create_from_page_button.dart';
import '../../../widgets/create_from_page/create_from_page_consts.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/comments_button.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../models/page_models/buying_page_model/purchase_order_page_model.dart';

class PurchaseOrderPage extends StatelessWidget {
  const PurchaseOrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = PurchaseOrderPageModel(context, data);

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CreateFromPageButton(
                  doctype: DocTypesName.purchaseOrder,
                  data: data,
                  items: fromPurchaseOrder,
                  disableCreate:
                      (data['docstatus'].toString() == "1") ? false : true,
                ),
                if (data['docstatus'] != null && data['amended_to'] == null )
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
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Purchase Order',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('Supplier: ' + (data['supplier_name'] ?? 'none')),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(data['supplier_name'] ?? 'none'),
            ),
            //   Text(data['lead_name'] ?? 'none'),
            SizedBox(height: 4),
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
              4,
              Checkbox(
                  value: (data['ignore_pricing_rule'] ?? 0) == 0 ? false : true,
                  onChanged: null),
              widgetNumber: 1)
        ]),

        ///
        /// card 3
        ///
        PageCard(color: color, items: model.card3Items),

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
                    child: Center(
                      child: TabBar(
                        labelStyle: GoogleFonts.cairo(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                        unselectedLabelStyle: GoogleFonts.cairo(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        unselectedLabelColor: Colors.grey.shade600,
                        //indicatorPadding: EdgeInsets.zero,
                        isScrollable: false,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.zero,
                        tabs: model.tabs,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    data['purchase_order_items'] == null ||
                            data['purchase_order_items'].isEmpty
                        ? NothingHere()
                        : ListView.builder(
                            physics: BouncingScrollPhysics(), shrinkWrap: true,
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
                                          names: model.itemListNames,
                                          values: model.itemListValues(index));
                                    });
                              },
                              id: model.items[index]['idx'].toString(),
                              names: model.getItemCard(index),
                              imageUrl: model.items[index]['image'].toString(),
                              itemName: model.items[index]['item_name'],
                            ),
                          ),

                    //
                    data['taxes'] == null || data['taxes'].isEmpty
                        ? NothingHere()
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: data['taxes'].length,
                            itemBuilder: (_, index) => ItemCard3(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) => PageDetailsDialog(
                                          names: model.taxesListNames,
                                          values: model.taxesListValues(index),
                                          title: (data['taxes'][index]
                                                      ['name'] ??
                                                  tr('none'))
                                              .toString())),
                                  id: data['taxes'][index]['idx'].toString(),
                                  values: model.getTaxesCard(index),
                                )),

                    data['payment_schedule'] == null ||
                            data['payment_schedule'].isEmpty
                        ? NothingHere()
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            itemCount: data['payment_schedule'].length,
                            itemBuilder: (_, index) => ItemCard3(
                                  onPressed: () => showDialog(
                                      context: context,
                                      builder: (_) => PageDetailsDialog(
                                          names: model.paymentListNames,
                                          values:
                                              model.paymentListValues(index),
                                          title: (data['payment_schedule']
                                                      [index]['name'] ??
                                                  tr('none'))
                                              .toString())),
                                  id: data['payment_schedule'][index]['idx']
                                      .toString(),
                                  values: model.getPaymentCard(index),
                                )),

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
