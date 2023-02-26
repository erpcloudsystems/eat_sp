import '../../../provider/module/module_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/page_models/selling_page_model/sales_order_model.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../widgets/dialog/page_details_dialog.dart';
import '../../../widgets/nothing_here.dart';
import '../../../widgets/page_group.dart';

import '../../../core/constants.dart';
import '../../../models/page_models/buying_page_model/purchase_order_page_model.dart';
import '../../../models/page_models/hr_page_model/attendance_request_page_model.dart';
import '../../../models/page_models/hr_page_model/employee_advance_page_model.dart';
import '../../../models/page_models/hr_page_model/employee_checkin_page_model.dart';
import '../../../models/page_models/hr_page_model/leave_application_page_model.dart';
import '../../../models/page_models/selling_page_model/address_page_model.dart';
import '../../../models/page_models/selling_page_model/contact_page_model.dart';
import '../../../models/page_models/selling_page_model/customer_visit_page_model.dart';
import '../../../service/service.dart';
import '../../../widgets/comments_button.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = ContactPageModel(context, data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Contact',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            // Text('Employee Id: ' + (data['employee'] ?? 'none')),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 4),
            //   child: Text(data['employee_name'] ?? 'none'),
            // ),
            // SizedBox(height: 4),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
                3,
                Checkbox(
                    value:
                        (data['is_primary_contact'] ?? 0) == 0 ? false : true,
                    onChanged: null),
                widgetNumber: 2)
          ],
        ),
        if (data['links'] != null)
          PageCard(
            color: color,
            items: model.card2Items,
          ),
        CommentsButton(color: color),
        SizedBox(
          height: 25,
        )
      ],
    );
  }
}
