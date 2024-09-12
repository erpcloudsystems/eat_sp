import 'package:easy_localization/easy_localization.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../provider/new_controller/home_provider.dart';
import '../../../widgets/map_view.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/nothing_here.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/selling_page_model/customer_page_model.dart';

class CustomerPage extends StatelessWidget {
  CustomerPage({super.key});

  Map<String, dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    data = context.read<ModuleProvider>().pageData;

    final model = CustomerPageModel(data);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          header: [
            Text(
              '${tr('Customer Name')}: ${data['customer_name'] ?? tr('none')}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
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
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return ElevatedButton(
                  onPressed: homeProvider.customerLocationLoading
                      ? null
                      : () async {
                          await homeProvider.updateCustomerLocation(
                            customerName: data['customer_name'],
                          );
                        },
                  child: homeProvider.customerLocationLoading
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      :  Text('Update customer location'.tr()),
                );
              },
            ),
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
                    onChanged: null,
                  ),
                ),
                widgetNumber: 2)
          ],
        ),
        PageCard(items: model.card2Items, swapWidgets: [
          SwapWidget(
              4,
              SizedBox(
                  height: 30,
                  child: Checkbox(
                    value: ((data["credit_limits"] == null ||
                                    data["credit_limits"].isEmpty)
                                ? 0
                                : data["credit_limits"][0]
                                        ['bypass_credit_limit_check'] ??
                                    0) ==
                            0
                        ? false
                        : true,
                    onChanged: null,
                  )))
        ]),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: CustomMapView(
            latitude: data['latitude'] ?? 0.0,
            longitude: data['longitude'] ?? 0.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5),
          child: ElevatedButton(
            onPressed: () {
              MapsLauncher.launchCoordinates(
                  data['latitude'], data['longitude']);
            },
            child: const Text(
              "Open in Maps",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
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
