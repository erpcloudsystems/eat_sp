import 'package:next_app/screen/filter_screen.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class SalesInvoiceFilter extends StatefulWidget {
  const SalesInvoiceFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Draft',
    'Return',
    'Credit Note Issued',
    'Submitted',
    'Paid',
    'Partly Paid',
    'Unpaid',
    'Unpaid and Discounted',
    'Partly Paid and Discounted',
    'Overdue and Discounted',
    'Overdue',
    'Cancelled',
    'Internal Transfer',
  ];

  @override
  State<SalesInvoiceFilter> createState() => _SalesInvoiceFilterState();
}

class _SalesInvoiceFilterState extends State<SalesInvoiceFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter4'];

    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: SalesInvoiceFilter._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomTextField(
          'filter2',
          'Customer'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter2'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter2'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectCustomerScreen()));
            if (res != null) _values['filter2'] = res['name'];
            return _values['filter2'];
          },
        ),
        DatePicker(
          'filter3',
          'From Date'.tr(),
          initialValue: _values['filter3'],
          onChanged: (value) {
            setState(() {
              _values['filter3'] = value;
              // remove date to if it's before from date
              if (_values['filter4'] != null && DateTime.parse(_values['filter4']).isBefore(DateTime.parse(_values['filter3']))) {
                _values.remove('filter4');
                _dateTo = '';
              }
            });
          },
          clear: true,
          onClear: () => _values.remove('filter3'),
        ),
        DatePicker(
          'filter4',
          'To Date'.tr(),
          firstDate: _values['filter3'] != null ? DateTime.parse(_values['filter3']) : null,
          initialValue: _dateTo,
          onChanged: (value) {
            _dateTo = value;
            setState(() => _values['filter4'] = value);
          },
          clear: true,
          onClear: () => _values.remove('filter4'),
        ),
      ],
    );
  }
}
