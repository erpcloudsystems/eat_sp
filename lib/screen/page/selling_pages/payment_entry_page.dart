import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../widgets/page_group.dart';
import '../../../core/cloud_system_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/selling_page_model/payment_entry_page_model.dart';

class PaymentEntryPage extends StatelessWidget {
  const PaymentEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final model = PaymentEntryPageModel(data);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: PageCard(
            color: statusColor(data['status'] ?? 'none') != Colors.transparent
                ? statusColor(data['status'] ?? 'none')
                : null,
            header: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Text('Payment Entry'.tr(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  if (data['docstatus'] != null && data['amended_to'] == null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: context
                            .read<ModuleProvider>()
                            .submitDocumentWidget(),
                      ),
                    )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(context.read<ModuleProvider>().pageId,
                      style: const TextStyle(fontWeight: FontWeight.bold))),
              Divider(color: Colors.grey.shade400, thickness: 1),
            ],
            items: model.card1Items,
            swapWidgets: [
              SwapWidget(
                  data['payment_type'] == 'Internal Transfer' ? 1 : 3,
                  Row(
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
                      ]),
                  widgetNumber: 2)
            ],
          ),
        ),
      ],
    );
  }
}
