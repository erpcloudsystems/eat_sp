import '../../../provider/module/module_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/page_group.dart';

import '../../../models/page_models/selling_page_model/contact_page_model.dart';
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
            const Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Contact',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
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
            // Text('Employee Id: ' + (data['employee'] ?? 'none')),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 4),
            //   child: Text(data['employee_name'] ?? 'none'),
            // ),
            // SizedBox(height: 4),
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
            ),
          ],
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
                3,
                Checkbox(
                    value: data['is_primary'] == 0 ? false : true,
                    onChanged: null),
                widgetNumber: 2),
            SwapWidget(
              2,
              Checkbox(
                  value: data['is_primary_phone'] == 0 ? false : true,
                  onChanged: null),
              widgetNumber: 2,
            )
          ],
        ),
        if (data['links'] != null)
          PageCard(
            color: color,
            items: model.card2Items,
          ),
        CommentsButton(color: color),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }
}
