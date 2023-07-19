import 'package:NextApp/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../screen/filter_screen.dart';
import '../../form_widgets.dart';

class IssueFilterScreen extends StatefulWidget {
  const IssueFilterScreen({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Open',
    'Replied',
    'On Hold',
    'Resolved',
    'Closed',
  ];

  @override
  State<IssueFilterScreen> createState() => _IssueFilterScreenState();
}

class _IssueFilterScreenState extends State<IssueFilterScreen> {
  Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: IssueFilterScreen._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomDropDown(
          'filter2',
          'Priority'.tr(),
          items: ProjectPriorityList,
          onChanged: (String value) => _values['filter2'] = value,
          onClear: () => _values.remove('filter2'),
          defaultValue: _values['filter2'],
          clear: true,
        ),
        CustomTextField(
          'filter3',
          'Project'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => projectScreen(),
              ),
            );
            if (res != null) _values['filter3'] = res['name'];
            return _values['filter3'];
          },
        ),
        CustomTextField(
          'filter6',
          'Customer'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter6'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter6'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => selectCustomerScreen(),
              ),
            );
            if (res != null) _values['filter6'] = res['name'];
            return _values['filter6'];
          },
        ),
      ],
    );
  }
}
