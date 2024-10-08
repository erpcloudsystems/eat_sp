import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../widgets/map_view.dart';
import '../../../widgets/page_group.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/selling_page_model/address_page_model.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = AddressPageModel(context, data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            const Stack(
              alignment: Alignment.center,
              children: [
                Text('Address',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            //Text('Employee Id: ' + (data['employee'] ?? 'none')),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 4),
            //   child: Text(data['employee_name'] ?? 'none'),
            // ),
            //SizedBox(height: 4),
            const Divider(color: Colors.white, thickness: 1),
          ],
          items: model.card1Items,
        ),

        PageCard(
          color: color,
          items: model.card2Items,
          swapWidgets: [
            SwapWidget(
                2,
                Checkbox(
                    value:
                        (data['is_primary_address'] ?? 0) == 0 ? false : true,
                    onChanged: null),
                widgetNumber: 1)
          ],
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
            child: const Text(
              "Open in Maps",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),

        // if (data['conn'] != null || data['conn'].isNotEmpty)
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(BORDER_RADIUS),
        //       //border: Border.all(color: Colors.blueAccent),
        //     ),
        //     child: Center(child: Text('Connections', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
        //     padding: const EdgeInsets.all(8),
        //     margin: const EdgeInsets.all(8),
        //   ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.45,
        //   child: (data['conn'] != null && data['conn'].isNotEmpty)
        //       ? ListView.builder(physics: BouncingScrollPhysics(),
        //       padding: const EdgeInsets.symmetric(horizontal: 12),
        //       shrinkWrap: true,
        //       itemCount: data['conn'].length,
        //       itemBuilder: (_, index) {
        //         print(data['conn']);
        //         return ConnectionCard(
        //             imageUrl: data['conn'][index]['icon'] ?? tr('none'),
        //             docTypeId: data['conn'][index]['name'] ?? tr('none'),
        //             count: data['conn'][index]['count'].toString());
        //       })
        //       : NothingHere(),
        // ),
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
