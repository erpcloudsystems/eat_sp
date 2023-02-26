import '../../../models/page_models/stock_page_model/stock_entry_page_model.dart';
import '../../../provider/module/module_provider.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/page_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/comments_button.dart';

class StockEntryPage extends StatelessWidget {
  const StockEntryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = StockEntryPageModel(data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Stock Entry',
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
        CommentsButton(color: color),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.70,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text('Items',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))),
              ),
              Expanded(
                child: data['items'] == null || data['items'].isEmpty
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
                                      title:
                                          model.items[index]['name'] ?? 'none',
                                      names: model.itemListNames,
                                      values: model.itemListValues(index));
                                });
                          },
                          id: model.items[index]['idx'].toString(),
                          imageUrl: model.items[index]['image'].toString(),
                          names: model.getItemCard(index),
                          itemName: model.items[index]['item_name'],
                        ),
                      ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
