import '../../../provider/module/module_provider.dart';
import '../../form/selling_forms/sales_order_form.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../widgets/create_from_page/create_from_page_button.dart';
import '../../../widgets/create_from_page/create_from_page_consts.dart';
import '../../../widgets/page_group.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/page_models/selling_page_model/quotation_page_model.dart';
import '../../../widgets/comments_button.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../widgets/nothing_here.dart';

class QuotationPage extends StatelessWidget {
  const QuotationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = QuotationPageModel(context, data);

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
                  doctype: 'Quotation',
                  data: data,
                  items: fromQuotation,
                  disableCreate: (data['status'].toString() != "Ordered" &&
                          data['docstatus'].toString() == "1" &&
                          data['quotation_to'].toString() == "Customer")
                      ? false
                      : true,
                ),
              ],
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Quotation',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                if (data['docstatus'] != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child:
                          context.read<ModuleProvider>().submitDocumentWidget(),
                    ),
                  ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('Quotation To: ' + (data['quotation_to'] ?? 'none')),
            Text('${data['quotation_to'] ?? ""} : ' +
                (data['party_name'] ?? 'none')),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(data['customer_name'] ?? 'none'),
            ),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          swapWidgets: [
            SwapWidget(
              2,
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
              widgetNumber: 2,
            )
          ],
        ),

        /// second card ///
        PageCard(
          color: color,
          items: model.card2Items,
          swapWidgets: [
            SwapWidget(
                4,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value: (data['ignore_pricing_rule'] ?? 0) == 0
                            ? false
                            : true,
                        onChanged: null)))
          ],
        ),

        ///third card
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
                                                names: model.subList1Names,
                                                values:
                                                    model.subList1Item(index));
                                          });
                                    },
                                    id: model.items[index]['idx'].toString(),
                                    imageUrl:
                                        model.items[index]['image'].toString(),
                                    itemName: model.items[index]['item_name'],
                                    names: model.quotationItem(index)),
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
                                  values: model.taxesCardValues(index),
                                )),

                    //
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
                                  values: model.paymentCardValues(index),
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
