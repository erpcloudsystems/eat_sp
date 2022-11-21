import 'package:next_app/screen/filter_screen.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class LoanApplicationFilter extends StatefulWidget {
  const LoanApplicationFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Open',
    'Approved',
    'Rejected',
  ];
 static const List<String> _applicantTypeList = [
    'Employee',
    'Customer',
  ];

  @override
  State<LoanApplicationFilter> createState() => _LoanApplicationFilterState();
}

class _LoanApplicationFilterState extends State<LoanApplicationFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter6'];

    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: LoanApplicationFilter._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomDropDown(
          'filter2',
          'Applicant Type'.tr(),
          items: LoanApplicationFilter._applicantTypeList,
          onChanged: (String value) => setState(() {
            _values['filter2'] = value;
          }),
          onClear: () => _values.remove('filter2'),
          defaultValue: _values['filter2'],
          clear: true,
        ),

        if(_values['filter2'] == LoanApplicationFilter._applicantTypeList[0])
        CustomTextField(
          'filter3',
          'Employee'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectEmployeeScreen()));
            if (res != null) _values['filter3'] = res['name'];
            return _values['filter3'];
          },
        ),

        if(_values['filter2'] == LoanApplicationFilter._applicantTypeList[1])
          CustomTextField(
            'filter3',
            'Customer'.tr(),
            clearButton: true,
            onClear: () => _values.remove('filter3'),
            onSave: (key, value) => _values[key] = value,
            initialValue: _values['filter3'],
            onPressed: () async {
              final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectCustomerScreen()));
              if (res != null) _values['filter3'] = res['name'];
              return _values['filter3'];
            },
          ),

        CustomTextField(
          'filter4',
          'Loan Type'.tr(),
          initialValue: _values['filter4'],
          onSave: (key, value) => _values[key] = value,
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => loanTypeListScreen()));
            if (res != null) _values['filter4'] = res['name'];
            return _values['filter4'];
          },
          clearButton: true,
          onClear: () => _values.remove('filter4'),
        ),





        DatePicker(
          'filter5',
          'From Date'.tr(),
          initialValue: _values['filter5'],
          onChanged: (value) {
            setState(() {
              _values['filter5'] = value;
              // remove date to if it's before from date
              if (_values['filter6'] != null && DateTime.parse(_values['filter6']).isBefore(DateTime.parse(_values['filter5']))) {
                _values.remove('filter6');
                _dateTo = '';
              }
            });
          },
          clear: true,
          onClear: () => setState(() {
            _values.remove('filter5');
          }),
        ),
        DatePicker(
          'filter6',
          'To Date'.tr(),
          firstDate: _values['filter5'] != null ? DateTime.parse(_values['filter5']) : null,
          initialValue: _dateTo,
          onChanged: (value) {
            _dateTo = value;
            setState(() => _values['filter6'] = value);
          },
          clear: true,
          onClear: () => setState(() {
            _values.remove('filter6');
          }),
        ),
      ],
    );
  }
}
