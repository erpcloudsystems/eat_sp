import 'package:NextApp/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../screen/filter_screen.dart';
import '../../form_widgets.dart';

class ProjectFilterScreen extends StatefulWidget {
  const ProjectFilterScreen({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Open',
    'Completed',
    'Cancelled',
  ];

  @override
  State<ProjectFilterScreen> createState() => _ProjectFilterScreenState();
}

class _ProjectFilterScreenState extends State<ProjectFilterScreen> {
  Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    return Column(
      children: [
        CustomDropDown(
          'filter2',
          'Status'.tr(),
          items: ProjectFilterScreen._statusList,
          onChanged: (String value) => _values['filter2'] = value,
          onClear: () => _values.remove('filter2'),
          defaultValue: _values['filter2'],
          clear: true,
        ),
        CustomDropDown(
          'filter1',
          'Priority'.tr(),
          items: ProjectPriorityList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomTextField(
          'filter3',
          'Project Type'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => projectTypeListScreen(),
              ),
            );
            if (res != null) _values['filter3'] = res;
            return _values['filter3'];
          },
        ),
        CustomTextField(
          'filter6',
          'Department'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter6'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter6'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => departmentListScreen(),
              ),
            );
            if (res != null) _values['filter6'] = res;
            return _values['filter6'];
          },
        ),
      ],
    );
  }
}