import '../../../widgets/nothing_here.dart';
import '../../../widgets/page_group.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/page_models/buying_page_model/supplier_page_model.dart';
import '../../../core/constants.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/comments_button.dart';

class SupplierPage extends StatelessWidget {
  SupplierPage({Key? key}) : super(key: key);

  Map<String, dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    data = context.read<ModuleProvider>().pageData;
    final Color? color = context.read<ModuleProvider>().color;

    final model = SupplierPageModel(data);
    print('data');
    print(data);

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          header: [
            Text(
                tr('Supplier Name') +
                    ': ${data['supplier_name'] ?? tr('none')}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(height: 4),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
                1,
                SizedBox(
                    height: 30,
                    child: Checkbox(
                        value: (data['disabled'] ?? 0) == 0 ? false : true,
                        onChanged: null)),
                widgetNumber: 2)
          ],
        ),
        PageCard(
          items: model.card2Items,
          // swapWidgets: [
          //   SwapWidget(
          //     3,
          //     SizedBox(
          //       height: 30,
          //       child: Checkbox(
          //         value: (data['disabled'] ?? 0) == 0 ? false : true,
          //         onChanged: null,
          //       ),
          //     ),
          //   )
          // ],
        ),
        CommentsButton(color: color),
        if (data['conn'] != null || data['conn'].isNotEmpty)
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
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
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
              : NothingHere(),
        ),
      ],
    );
  }
}
