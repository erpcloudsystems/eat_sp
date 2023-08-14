import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../../../widgets/form_widgets.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../new_version/core/resources/app_values.dart';
class ManufacturingConnectionsAndItemsPageSection extends StatelessWidget {

  final Map<String, dynamic> data;
  final dynamic model;
  const ManufacturingConnectionsAndItemsPageSection({super.key, required this.data, this.model});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
          height: MediaQuery.of(context).size.height * 0.70,
          child: DefaultTabController(
            length: manufacturingPagesTabs.length,
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
                          fontSize: DoublesManager.d_16,
                          fontWeight: FontWeight.w600),
                      unselectedLabelStyle: GoogleFonts.cairo(
                          fontSize: DoublesManager.d_16, fontWeight: FontWeight.w600),
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorPadding: EdgeInsets.zero,
                      isScrollable: false,
                      labelPadding: const EdgeInsets.symmetric(horizontal: DoublesManager.d_4),
                      padding: EdgeInsets.zero,
                      tabs: manufacturingPagesTabs,
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
        );
  }
}