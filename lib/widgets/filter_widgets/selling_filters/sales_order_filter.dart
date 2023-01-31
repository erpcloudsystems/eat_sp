import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class SalesOrderFilter extends StatefulWidget {
  const SalesOrderFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Draft',
    'On Hold',
    'To Deliver and Bill',
    'To Bill',
    'To Deliver',
    'Completed',
    'Cancelled',
    'Closed',
  ];

  static const List<String> _deliveryStatusList = [
    'Not Delivered',
    'Fully Delivered',
    'Partly Delivered',
    'Closed',
    'Not Applicable',
  ];

  static const List<String> _billingStatusList = [
    'Not Billed',
    'Fully Billed',
    'Partly Billed',
    'Closed',
  ];

  @override
  State<SalesOrderFilter> createState() => _SalesOrderFilterState();
}

class _SalesOrderFilterState extends State<SalesOrderFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;
  String? _deliveryDateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter6'];
    _deliveryDateTo = _values['filter8'];

    return Column(
      key: UniqueKey(),
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: SalesOrderFilter._statusList,
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
            final res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => selectCustomerScreen()));
            if (res != null) _values['filter2'] = res['name'];
            return _values['filter2'];
          },
        ),
        CustomDropDown(
          'filter3',
          'Delivery Status'.tr(),
          items: SalesOrderFilter._deliveryStatusList,
          onChanged: (String value) => _values['filter3'] = value,
          onClear: () => _values.remove('filter3'),
          defaultValue: _values['filter3'],
          clear: true,
        ),
        CustomDropDown(
          'filter4',
          'Billing Status'.tr(),
          items: SalesOrderFilter._billingStatusList,
          onChanged: (String value) => _values['filter4'] = value,
          onClear: () => _values.remove('filter4'),
          defaultValue: _values['filter4'],
          clear: true,
        ),
        DatePicker(
          'filter5',
          'From Date'.tr(),
          initialValue: _values['filter5'],
          onChanged: (value) {
            setState(() {
              _values['filter5'] = value;
              // remove date to if it's before from date
              if (_values['filter6'] != null &&
                  DateTime.parse(_values['filter6'])
                      .isBefore(DateTime.parse(_values['filter5']))) {
                _values.remove('filter6');
                _dateTo = '';
              }
            });
          },
          clear: true,
          onClear: () => _values.remove('filter5'),
        ),
        DatePicker(
          'filter6',
          'To Date'.tr(),
          firstDate: _values['filter5'] != null
              ? DateTime.parse(_values['filter5'])
              : null,
          initialValue: _dateTo,
          onChanged: (value) {
            _dateTo = value;
            setState(() => _values['filter6'] = value);
          },
          clear: true,
          onClear: () => _values.remove('filter6'),
        ),
        DatePicker(
          'filter7',
          'Delivery Date From'.tr(),
          initialValue: _values['filter7'],
          onChanged: (value) {
            setState(() {
              _values['filter7'] = value;
              // remove date to if it's before from date
              if (_values['filter8'] != null &&
                  DateTime.parse(_values['filter8'])
                      .isBefore(DateTime.parse(_values['filter7']))) {
                _values.remove('filter8');
                _deliveryDateTo = '';
              }
            });
          },
          clear: true,
          onClear: () {
            setState(() {
              _values.remove('filter7');
            });
          },
        ),
        DatePicker(
          'filter8',
          'Delivery Date To'.tr(),
          firstDate: _values['filter7'] != null
              ? DateTime.parse(_values['filter7'])
              : null,
          initialValue: _deliveryDateTo,
          onChanged: (value) {
            _deliveryDateTo = value;
            setState(() => _values['filter8'] = value);
          },
          clear: true,
          onClear: () => _values.remove('filter8'),
        ),
      ],
    );
  }
}
