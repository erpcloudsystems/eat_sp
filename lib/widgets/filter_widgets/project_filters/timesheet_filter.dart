import 'package:NextApp/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../screen/filter_screen.dart';
import '../../form_widgets.dart';

class TimesheetFilterScreen extends StatefulWidget {
  const TimesheetFilterScreen({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Draft',
    'Cancelled',
    'Submitted',
  ];

  @override
  State<TimesheetFilterScreen> createState() => _TimesheetFilterScreenState();
}

class _TimesheetFilterScreenState extends State<TimesheetFilterScreen> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter4'];
    return Column(
      children: [
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
        CustomTextField(
          'filter2',
          'Customer'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter2'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter2'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => selectCustomerScreen(),
              ),
            );
            if (res != null) _values['filter2'] = res['name'];
            return _values['filter2'];
          },
        ),
        CustomTextField(
          'filter3',
          'Employee'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => selectEmployeeScreen(),
              ),
            );
            if (res != null) _values['filter3'] = res['name'];
            return _values['filter3'];
          },
        ),
      ],
    );
  }
}
