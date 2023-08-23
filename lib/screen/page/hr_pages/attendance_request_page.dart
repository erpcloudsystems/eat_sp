import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../widgets/map_view.dart';
import '../../../widgets/page_group.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/hr_page_model/attendance_request_page_model.dart';

class AttendanceRequestPage extends StatelessWidget {
  const AttendanceRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = AttendanceRequestPageModel(context, data);

    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Attendance Request',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
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
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(context.read<ModuleProvider>().pageId,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
            Text('Employee Id: ' + (data['employee'] ?? 'none')),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(data['employee_name'] ?? 'none'),
            ),
            SizedBox(height: 4),
            Divider(color: Colors.grey.shade400, thickness: 1),
          ],
          items: model.card1Items,
          swapWidgets: [
            SwapWidget(
                3,
                Checkbox(
                    value: (data['half_day'] ?? 0) == 0 ? false : true,
                    onChanged: null),
                widgetNumber: 1)
          ],
        ),
        PageCard(
          color: color,
          items: model.card2Items,
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: CustomMapView(
            latitude: double.parse(data['latitude'] ?? '0.0'),
            longitude: double.parse(data['longitude'] ?? '0.0'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 5),
          child: ElevatedButton(
            onPressed: () {
              MapsLauncher.launchCoordinates(
                  double.parse(data['latitude'] ?? 0.0),
                  double.parse(data['longitude'] ?? 0.0));
            },
            child: Text(
              "Open in Maps",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
