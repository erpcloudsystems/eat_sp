import 'package:next_app/screen/filter_screen.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class LeaveApplicationFilter extends StatefulWidget {
  const LeaveApplicationFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Open',
    'Approved',
    'Rejected',
    'Cancelled',
  ];

  @override
  State<LeaveApplicationFilter> createState() => _LeaveApplicationFilterState();
}

class _LeaveApplicationFilterState extends State<LeaveApplicationFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter7'];

    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: LeaveApplicationFilter._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomTextField(
          'filter2',
          'Employee'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter2'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter2'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectEmployeeScreen()));
            if (res != null) _values['filter2'] = res['name'];
            return _values['filter2'];
          },
        ),
        DatePicker(
          'filter3',
          'Leave Date'.tr(),
          initialValue: _values['filter3'],
          onChanged: (value) {
            setState(() {
              _values['filter3'] = value;
            });
          },
          clear: true,
          onClear: () => _values.remove('filter3'),
        ),
        CustomTextField(
          'filter4',
          'Department'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter4'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter4'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => departmentListScreen()));
            if (res != null) _values['filter4'] = res;
            return _values['filter4'];
          },
        ),
        CustomTextField(
          'filter5',
          'Leave Type'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter5'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter5'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => leaveTypeListScreen()));
            if (res != null) _values['filter5'] = res;
            return _values['filter5'];
          },
        ),
        DatePicker(
          'filter6',
          'From Date'.tr(),
          initialValue: _values['filter6'],
          onChanged: (value) {
            setState(() {
              _values['filter6'] = value;
              //remove date to if it's before from date
              if (_values['filter7'] != null && DateTime.parse(_values['filter7']).isBefore(DateTime.parse(_values['filter6']))) {
                _values.remove('filter7');
                _dateTo = '';
              }
            });
          },
          clear: true,
          onClear: () => setState(() {
            _values.remove('filter6');
          }),
        ),
        DatePicker(
          'filter7',
          'To Date'.tr(),
          firstDate: _values['filter6'] != null ? DateTime.parse(_values['filter6']) : null,
          initialValue: _dateTo,
          onChanged: (value) {
            _dateTo = value;
            setState(() => _values['filter7'] = value);
          },
          clear: true,
          onClear: ()  => setState(() {
    _values.remove('filter7');
    }),
        ),
      ],
    );
  }
}
