import 'package:NextApp/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../screen/filter_screen.dart';
import '../../form_widgets.dart';

class TaskFilterScreen extends StatefulWidget {
  const TaskFilterScreen({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Open',
    'Working',
    'Overdue',
    'Template',
    'Completed',
    'Cancelled',
    'Pending Review',
  ];

  @override
  State<TaskFilterScreen> createState() => _TaskFilterScreenState();
}

class _TaskFilterScreenState extends State<TaskFilterScreen> {
  Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    return Column(
      children: [
        CustomDropDown(
          'filter2',
          'Status'.tr(),
          items: TaskFilterScreen._statusList,
          onChanged: (String value) => _values['filter2'] = value,
          onClear: () => _values.remove('filter2'),
          defaultValue: _values['filter2'],
          clear: true,
        ),
        CustomDropDown(
          'filter3',
          'Priority'.tr(),
          items: ProjectPriorityList,
          onChanged: (String value) => _values['filter3'] = value,
          onClear: () => _values.remove('filter3'),
          defaultValue: _values['filter3'],
          clear: true,
        ),
        CustomTextField(
          'filter1',
          'Project'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter1'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter1'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => projectScreen(),
              ),
            );
            if (res != null) _values['filter1'] = res;
            return _values['filter1'];
          },
        ),
      ],
    );
  }
}
