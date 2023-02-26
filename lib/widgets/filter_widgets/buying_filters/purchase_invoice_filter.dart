import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class PurchaseInvoiceFilter extends StatefulWidget {
  const PurchaseInvoiceFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Draft',
    'Return',
    'Debit Note Issued',
    'Submitted',
    'Paid',
    'Partly Paid',
    'Unpaid',
    'Overdue',
    'Cancelled',
    'Internal Transfer',
  ];

  @override
  State<PurchaseInvoiceFilter> createState() => _PurchaseInvoiceFilterState();
}

class _PurchaseInvoiceFilterState extends State<PurchaseInvoiceFilter> {
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
          items: PurchaseInvoiceFilter._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomTextField(
          'filter2',
          'Supplier'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter2'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter2'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => selectSupplierScreen()));
            if (res != null) _values['filter2'] = res['name'];
            return _values['filter2'];
          },
        ),
        CheckBoxWidget(
          'filter3',
          'Is Return',
          initialValue: _values['filter3'] == 1 ? true : false,
          onChanged: (id, value) => setState(() => _values[id] = value ? 1 : 0),
          clear: true,
          onClear: () => _values.remove('filter3'),
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
          onClear: () => _values.remove('filter4'),
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
          onClear: () => _values.remove('filter5'),
        ),
      ],
    );
  }
}
