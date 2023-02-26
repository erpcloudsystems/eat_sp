import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class EmployeeFilter extends StatefulWidget {
  const EmployeeFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Active',
    'Inactive',
    'Suspended',
    'Left',
  ];

  @override
  State<EmployeeFilter> createState() => _EmployeeFilterState();
}

class _EmployeeFilterState extends State<EmployeeFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter5'];

    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: EmployeeFilter._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomTextField(
          'filter2',
          'Gender'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter2'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter2'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => genderListScreen()));
            if (res != null) _values['filter2'] = res;
            return _values['filter2'];
          },
        ),
        CustomTextField(
          'filter3',
          'Department'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => departmentListScreen()));
            if (res != null) _values['filter3'] = res;
            return _values['filter3'];
          },
        ),
        DatePicker(
          'filter4',
          'From Date'.tr(),
          initialValue: _values['filter4'],
          onChanged: (value) {
            setState(() {
              _values['filter4'] = value;
              // remove date to if it's before from date
              if (_values['filter5'] != null &&
                  DateTime.parse(_values['filter5'])
                      .isBefore(DateTime.parse(_values['filter4']))) {
                _values.remove('filter5');
                _dateTo = '';
              }
            });
          },
          clear: true,
          onClear: () => setState(() {
            _values.remove('filter4');
          }),
        ),
        DatePicker(
          'filter5',
          'To Date'.tr(),
          firstDate: _values['filter4'] != null
              ? DateTime.parse(_values['filter4'])
              : null,
          initialValue: _dateTo,
          onChanged: (value) {
            _dateTo = value;
            setState(() => _values['filter5'] = value);
          },
          clear: true,
          onClear: () => setState(() {
            _values.remove('filter5');
          }),
        ),
      ],
    );
  }
}
