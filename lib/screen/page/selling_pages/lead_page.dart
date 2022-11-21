import 'package:next_app/core/constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/screen/form/selling_forms/customer_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:next_app/models/page_models/selling_page_model/lead_page_model.dart';
import '../../../widgets/comments_button.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../widgets/create_from_page/create_from_page_button.dart';
import '../../../widgets/create_from_page/create_from_page_consts.dart';
import '/widgets/nothing_here.dart';
import '/widgets/page_group.dart';

class LeadPage extends StatelessWidget {
  const LeadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;
    final Color? color = context.read<ModuleProvider>().color;

    final model = LeadPageModel(data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [


        PageCard(
          header: [
            Row(
              mainAxisAlignment:  MainAxisAlignment.end,
              children: [
                CreateFromPageButton(
                  data: data,
                  items: fromLead,
                ),
              ],
            ),
            Text('Lead',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            //   Text(data['lead_name'] ?? 'none'),
            SizedBox(height: 4),
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
                        SizedBox(width: 8),
                        FittedBox(
                          child: Text(data['status'] ?? 'none'),
                          fit: BoxFit.fitHeight,
                        ),
                      ],
                    )
                  : Text(data['status'] ?? 'none'),
              //widgetNumber: 1,
            ),
            SwapWidget(
                2,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value: (data['organization_lead'] ?? 0) == 0
                            ? false
                            : true,
                        onChanged: null)))
          ],
        ),

        ///
        /// card 2
        ///
        PageCard(items: model.card2Items),

        CommentsButton(color: color),

        //    if(data['conn'] != null || data['conn'].isNotEmpty)
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
            //border: Border.all(color: Colors.blueAccent),
          ),
          child: Center(
              child: Text('Connections',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold))),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: (data['conn'] != null && data['conn'].isNotEmpty)
              ? ListView.builder(physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: data['conn'].length,
                  itemBuilder: (_, index) => ConnectionCard(
                      imageUrl: data['conn'][index]['icon'] ?? tr('none'),
                      docTypeId: data['conn'][index]['name'] ?? tr('none'),
                      count: data['conn'][index]['count'].toString()))
              : NothingHere(),
        ),
      ],
    );
  }
}
