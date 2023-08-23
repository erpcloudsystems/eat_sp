import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '/widgets/page_group.dart';
import '/widgets/nothing_here.dart';
import '../../../core/constants.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/create_from_page/create_from_page_button.dart';
import '../../../widgets/create_from_page/create_from_page_consts.dart';
import '../../../models/page_models/selling_page_model/lead_page_model.dart';

class LeadPage extends StatelessWidget {
  const LeadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final model = LeadPageModel(data);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          header: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CreateFromPageButton(
                  doctype: 'Lead',
                  data: data,
                  items: fromLead,
                  disableCreate:
                      data['status'].toString() == "Converted" ? true : false,
                ),
              ],
            ),
            const Text(
              'Lead',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
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
            ),
            SwapWidget(
              2,
              SizedBox(
                height: 30,
                child: Checkbox(
                  value: (data['organization_lead'] ?? 0) == 0 ? false : true,
                  onChanged: null,
                ),
              ),
            )
          ],
        ),

        ///
        /// card 2
        ///
        PageCard(items: model.card2Items),

        //    if(data['conn'] != null || data['conn'].isNotEmpty)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            //border: Border.all(color: Colors.blueAccent),
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              'Connections'.tr(),
              style: const TextStyle(
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
