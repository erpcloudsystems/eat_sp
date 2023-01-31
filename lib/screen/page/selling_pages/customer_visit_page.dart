import '../../../provider/module/module_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../../widgets/page_group.dart';

import '../../../core/constants.dart';
import '../../../models/page_models/buying_page_model/purchase_order_page_model.dart';
import '../../../models/page_models/hr_page_model/attendance_request_page_model.dart';
import '../../../models/page_models/hr_page_model/employee_advance_page_model.dart';
import '../../../models/page_models/hr_page_model/employee_checkin_page_model.dart';
import '../../../models/page_models/hr_page_model/leave_application_page_model.dart';
import '../../../models/page_models/selling_page_model/customer_visit_page_model.dart';
import '../../../service/service.dart';
import '../../../widgets/comments_button.dart';
import '../../../widgets/map_view.dart';
import '../../other/user_profile.dart';

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
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 4),
            //   child: Text(data['employee_name'] ?? 'none'),
            // ),
            // SizedBox(height: 4),
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
          child: CustomMapView(latitude: data['latitude'], longitude: data['longitude'],),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0,vertical: 5),
          child: ElevatedButton(onPressed: (){
            MapsLauncher.launchCoordinates(data['latitude'], data['longitude']);

          }, child: Text("Open in Maps",style: TextStyle(fontWeight: FontWeight.w600),),
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
