import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/hr_page_model/employee_page_model.dart';

class EmployeePage extends StatelessWidget {
  EmployeePage({Key? key}) : super(key: key);

  Map<String, dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    data = context.read<ModuleProvider>().pageData;

    final model = EmployeePageModel(data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          header: [
            Text(
              '${tr('')} ${data['employee_name'] ?? tr('none')}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 4),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
        ),
        PageCard(
          items: model.card2Items,
        ),
        PageCard(
          items: model.card3Items,
          swapWidgets: [
            SwapWidget(
                1,
                PageExpandableCardItem(
                  title: 'Emails',
                  items: model.emailsItems,
                  width: 300,
                ),
                widgetNumber: 1),
            SwapWidget(
                2,
                PageExpandableCardItem(
                  title: 'Address',
                  items: model.addressItems,
                  width: 300,
                ),
                widgetNumber: 1),
          ],
        ),
        if (data['conn'] != null || data['conn'].isNotEmpty)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
              //border: Border.all(color: Colors.blueAccent),
            ),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            child: const Center(
                child: Text('Connections',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))),
          ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: (data['conn'] != null && data['conn'].isNotEmpty)
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: data['conn'].length,
                  itemBuilder: (_, index) {
                    print(data['conn']);
                    return ConnectionCard(
                        imageUrl: data['conn'][index]['icon'] ?? tr('none'),
                        docTypeId: data['conn'][index]['name'] ?? tr('none'),
                        count: data['conn'][index]['count'].toString());
                  })
              : const NothingHere(),
        ),
      ],
    );
  }
}
