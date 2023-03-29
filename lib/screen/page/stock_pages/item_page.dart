import 'dart:developer';

import '../../../core/constants.dart';
import '../../../models/page_models/stock_page_model/item_page_model.dart';
import '../../../service/service.dart';
import '../../../provider/module/module_provider.dart';
import '../../../provider/user/user_provider.dart';
import '../../table_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/comments_button.dart';
import '/widgets/page_group.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;
    log(data.toString());
    final Color? color = context.read<ModuleProvider>().color;

    final model = ItemPageModel(data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          header: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 100),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            context.read<UserProvider>().url +
                                data['image'].toString(),
                            headers: APIService().getHeaders,
                            // width: 45,
                            // height: 45,
                            loadingBuilder: (context, child, progress) {
                              return progress != null
                                  ? SizedBox(
                                      child: Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    )
                                  : child;
                            },
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return SizedBox(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        )),
                  ),
                  Container(
                      width: 1,
                      color: Colors.grey.shade400,
                      margin: const EdgeInsets.symmetric(vertical: 8)),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(data['item_name'] ?? tr('none'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                          Text(
                            'Item Code: ' + (data['item_code'] ?? tr('none')),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 4),
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
          ],
          items: model.mainTable,
          swapWidgets: [
            SwapWidget(
                1,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value: (data['disabled'] ?? 0) == 0 ? false : true,
                        onChanged: null))),
            SwapWidget(
                2,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value: (data['is_stock_item'] ?? 0) == 0 ? false : true,
                        onChanged: null)),
                widgetNumber: 2),
            SwapWidget(
                3,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value: (data['include_item_in_manufacturing'] ?? 0) == 0
                            ? false
                            : true,
                        onChanged: null)),
                widgetNumber: 2),
            SwapWidget(
                4,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value:
                            (data['is_fixed_asset'] ?? 0) == 0 ? false : true,
                        onChanged: null))),
            SwapWidget(
                5,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value: (data['is_sales_item'] ?? 0) == 0 ? false : true,
                        onChanged: null))),
            SwapWidget(
                6,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value:
                            (data['is_purchase_item'] ?? 0) == 0 ? false : true,
                        onChanged: null))),
          ],
        ),

        CommentsButton(color: color),

        ///
        /// table buttons
        ///

        TableButton(
            tableName: 'UOMs Table',
            table: List<Map<String, dynamic>>.from(data['uoms'] ?? {}),
            columnsName: [
              MapEntry('idx', tr('Row #')),
              MapEntry('uom', tr('UOM')),
              MapEntry('conversion_factor', tr('Conversion Factor')),
            ]),
        TableButton(
            tableName: 'Prices Table',
            table: List<Map<String, dynamic>>.from(
                data['selling_price_lists_rate'] ?? {}),
            columnsName: [
              MapEntry('price_list', tr('Price List')),
              MapEntry('price_list_rate', tr('Rate')),
              MapEntry('currency', tr('Currency')),
            ]),
        TableButton(
            tableName: 'Balances Table',
            table:
                List<Map<String, dynamic>>.from(data['stock_balances'] ?? {}),
            columnsName: [
              MapEntry('warehouse', tr('Warehouse')),
              MapEntry('warehouse_type', tr('Warehouse Type')),
              MapEntry('actual_qty', tr('Balance')),
              MapEntry('reserved_qty', tr('Reserved Qty')),
              MapEntry('ordered_qty', tr('Ordered Qty')),
              MapEntry('indented_qty', tr('Requested Qty')),
              MapEntry('projected_qty', tr('Projected Qty')),
            ]),

        SizedBox(height: 10)
      ],
    );
  }
}

class TableButton extends StatelessWidget {
  final List<MapEntry<String, String>> columnsName;
  final List<Map<String, dynamic>> table;

  // final List<Map<String, dynamic>> table;
  final String tableName;

  const TableButton(
      {required this.tableName,
      required this.columnsName,
      required this.table,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
              primary: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              onPrimary: Colors.grey),
          onPressed: table.isEmpty
              ? null
              : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TableScreen(
                              title: tableName,
                              table: table,
                              columnsName: columnsName)));
                },
          child: Row(
            children: [
              Text(tableName,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black)),
              Spacer(),
              Icon(Icons.arrow_right_sharp, color: Colors.blueAccent, size: 26)
            ],
          )),
    );
  }
}
