import 'dart:developer';

import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../models/page_models/manufacuting_model/bom_page_model.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/comments_button.dart';
import '../../../provider/module/module_provider.dart';

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
        /// Task details
        PageCard(
          header: [
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

        /// Task description
        PageCard(items: model.card2Items),

        /// Comment button
        CommentsButton(color: color),

        /// Connections
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            //border: Border.all(color: Colors.blueAccent),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          child: const Center(
            child: Text(
              'Connections',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: (data['conn'] != null && data['conn'].isNotEmpty)
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: data['conn'].length,
                  itemBuilder: (_, index) => ConnectionCard(
                      imageUrl: data['conn'][index]['icon'] ?? tr('none'),
                      docTypeId: data['conn'][index]['name'] ?? tr('none'),
                      count: data['conn'][index]['count'].toString()))
              : const NothingHere(),
        ),
      ],
    );
  }
}
