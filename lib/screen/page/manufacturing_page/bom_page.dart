import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';


import 'connections_items.dart';
import '../../../core/constants.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/comments_button.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/model_functions.dart';
import '../../../new_version/core/resources/app_values.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../models/page_models/manufacuting_model/bom_page_model.dart';

class BomPage extends StatelessWidget {
  const BomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;
    for (var k in data.keys) {
      log("$k : ${data[k]}");
    }
    final Color? color = context.read<ModuleProvider>().color;
    final model = BomPageModel(data);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          header: [
            if (data['docstatus'] != null && data['amended_to'] == null)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: DoublesManager.d_12),
                  child: context.read<ModuleProvider>().submitDocumentWidget(),
                ),
              ),
            const Text(
              DocTypesName.bom,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                context.read<ModuleProvider>().pageId,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Divider(color: Colors.grey.shade400, thickness: 1),
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
                        Icon(
                          Icons.circle,
                          color: statusColor(data['status'] ?? 'none'),
                          size: DoublesManager.d_12,
                        ),
                        const SizedBox(width: DoublesManager.d_8),
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(data['status'] ?? 'none'),
                        ),
                      ],
                    )
                  : Text(data['status'] ?? 'none'),
            ),
            SwapWidget(
              5,
              SizedBox(
                height: 30,
                child: Checkbox(
                  value: (data['is_default'] ?? 0) == 0 ? false : true,
                  onChanged: null,
                ),
              ),
            ),
            SwapWidget(
              6,
              SizedBox(
                height: 30,
                child: Checkbox(
                  value:
                      (data['allow_alternative_item'] ?? 0) == 0 ? false : true,
                  onChanged: null,
                ),
              ),
            ),
            SwapWidget(
                6,
                SizedBox(
                  height: 30,
                  child: Checkbox(
                    value: (data['with_operations'] ?? 0) == 0 ? false : true,
                    onChanged: null,
                  ),
                ),
                widgetNumber: 2),
          ],
        ),

        /// BOM operations
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              StringsManager.operations.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          child: (data['bom_perations'] != null &&
                  data['bom_perations'].isNotEmpty)
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: data['bom_perations'].length,
                  itemBuilder: (_, index) => PageCard(
                    items: [
                      {
                        StringsManager.operation.tr(): data['bom_perations']
                            [index]['operation'],
                        StringsManager.operatingCost.tr(): currency(
                            data['bom_perations'][index]['operating_cost']),
                        StringsManager.operationTime: data['bom_perations']
                                [index]['time_in_mins']
                            .toString(),
                      }
                    ],
                  ),
                )
              : const NothingHere(),
        ),

        /// BOM description
        PageCard(items: model.card2Items),

        /// Comment button
        CommentsButton(color: color),

        /// Connections & Items
        ManufacturingConnectionsAndItemsPageSection(data: data, model: model),
      ],
    );
  }
}
