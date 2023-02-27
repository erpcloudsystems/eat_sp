import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

import '../../../models/page_models/hr_page_model/employee_checkin_page_model.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/comments_button.dart';
import '../../../widgets/map_view.dart';
import '../../../widgets/page_group.dart';

class EmployeeCheckinPage extends StatelessWidget {
  const EmployeeCheckinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = context.read<ModuleProvider>().pageData;

    final Color? color = context.read<ModuleProvider>().color;

    final model = EmployeeCheckinPageModel(context, data);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        PageCard(
          color: color,
          header: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text('Employee Checkin',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
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
                    value:
                        (data['skip_auto_attendance'] ?? 0) == 0 ? false : true,
                    onChanged: null),
                widgetNumber: 1)
          ],
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
          height: 50,
        )
      ],
    );
  }
}
