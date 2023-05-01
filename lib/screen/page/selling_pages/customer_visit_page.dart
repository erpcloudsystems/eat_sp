import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/map_view.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/comments_button.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../widgets/create_from_page/create_from_page_button.dart';
import '../../../widgets/create_from_page/create_from_page_consts.dart';
import '../../../models/page_models/selling_page_model/customer_visit_page_model.dart';

class CustomerVisitPage extends StatelessWidget {
  const CustomerVisitPage({Key? key}) : super(key: key);


  
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = CustomerVisitPageModel(context, data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CreateFromPageButton(
                  doctype: DocTypesName.customerVisit,
                  data: data,
                  items: fromCustomerVisit,
                  disableCreate:
                      (data['docstatus'].toString() == "1") ? false : true,
                ),
                if (data['docstatus'] != null && data['amended_to'] == null)
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
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Customer Visit',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('Customer: ' + (data['customer'] ?? 'none')),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
        ),
        PageCard(
          color: color,
          items: model.card2Items,
        ),
        PageCard(
          color: color,
          items: model.card3Items,
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: CustomMapView(
            latitude: data['latitude'],
            longitude: data['longitude'],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5),
          child: ElevatedButton(
            onPressed: () {
              MapsLauncher.launchCoordinates(
                  data['latitude'], data['longitude']);
            },
            child: Text(
              "Open in Maps",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        CommentsButton(color: color),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
