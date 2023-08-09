import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../models/list_models/manufacturing_list_model/work_order_model.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import '../../form_widgets.dart';

class JobCardFilterScreen extends StatefulWidget {
  const JobCardFilterScreen({Key? key}) : super(key: key);

  @override
  State<JobCardFilterScreen> createState() => _JobCardFilterScreenState();
}

class _JobCardFilterScreenState extends State<JobCardFilterScreen> {
  Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    return Column(
      children: [
        //_______________________________ Operation ___________________________________________
        CustomTextField(
          'filter2',
          StringsManager.operation.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter2'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter2'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => operationsListScreen(),
              ),
            );
            if (res != null) _values['filter2'] = res;
            return _values['filter2'];
          },
        ),
        //_______________________________________ Work Order _____________________________________________________
         CustomTextField(
          'filter3',
          StringsManager.workOrder.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
              final WorkOrderItemModel res = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => workOrderListScreen()));
             _values['filter3'] = res.name;
            return _values['filter3'];
          },
        ),
      ],
    );
  }
}
