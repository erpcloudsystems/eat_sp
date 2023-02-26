import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class EmployeeCheckinFilter extends StatefulWidget {
  const EmployeeCheckinFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'IN',
    'OUT',
  ];

  @override
  State<EmployeeCheckinFilter> createState() => _EmployeeCheckinFilterState();
}

class _EmployeeCheckinFilterState extends State<EmployeeCheckinFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo, _timeFrom, _timeTo;
  String? _DateTimeFrom, _DateTimeTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter4'];

    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Log Type'.tr(),
          items: EmployeeCheckinFilter._statusList,
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
            final res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => selectEmployeeScreen()));
            if (res != null) _values['filter2'] = res['name'];
            return _values['filter2'];
          },
        ),
        Row(children: [
          Flexible(
            child: DatePicker(
              'filter3',
              'From Date'.tr(),
              initialValue: _values['filter3'],
              onChanged: (value) {
                setState(() {
                  if (_timeFrom == null) {
                    _values['filter3'] = value;
                  } else {
                    _values['filter3'] =
                        (value.toString().split("T")[0]) + "T" + _timeFrom!;
                  }
                  //remove date to if it's before from date
                  if (_values['filter4'] != null &&
                      DateTime.parse(_values['filter4'])
                          .isBefore(DateTime.parse(_values['filter3']))) {
                    _values.remove('filter4');
                    _dateTo = '';
                  }
                });
              },
              clear: true,
              onClear: () => setState(() {
                _values.remove('filter3');
              }),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
              child: TimePicker(
            'time',
            'Time'.tr(),
            initialValue: _values['filter3'],
            onChanged: (value) {
              setState(() {
                _timeFrom = value;
                if (_values['filter3'] != null) {
                  _values['filter3'] =
                      (_values['filter3'].toString().split("T")[0]) +
                          "T" +
                          _timeFrom!;
                } else {
                  _values['filter3'] =
                      (DateTime.now().toIso8601String().split("T")[0]) +
                          "T" +
                          _timeFrom!;
                }
              });
            },
            clear: true,
            onClear: () => setState(() {
              _values.remove('filter3');
            }),
          )),
        ]),
        Row(children: [
          Flexible(
            child: DatePicker(
              'filter4',
              'To Date'.tr(),
              firstDate: _values['filter3'] != null
                  ? DateTime.parse(_values['filter3'])
                  : null,
              initialValue: _values['filter4'],
              onChanged: (value) {
                setState(() {
                  if (_timeTo == null) {
                    _values['filter4'] = value;
                  } else {
                    _values['filter4'] =
                        (value.toString().split("T")[0]) + "T" + _timeTo!;
                  }
                });
              },
              clear: true,
              onClear: () => setState(() {
                _values.remove('filter4');
              }),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
              child: TimePicker(
            'time',
            'Time'.tr(),
            initialValue: _values['filter4'],
            onChanged: (value) {
              setState(() {
                _timeTo = value;
                if (_values['filter4'] != null) {
                  _values['filter4'] =
                      (_values['filter4'].toString().split("T")[0]) +
                          "T" +
                          _timeTo!;
                } else {
                  _values['filter4'] =
                      (DateTime.now().toIso8601String().split("T")[0]) +
                          "T" +
                          _timeTo!;
                }
              });
            },
            clear: true,
            onClear: () => setState(() {
              _values.remove('filter4');
            }),
          )),
        ]),
      ],
    );
  }
}
