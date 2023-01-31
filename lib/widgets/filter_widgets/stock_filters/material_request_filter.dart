import '../../../screen/filter_screen.dart';
import '../../../screen/form/stock_forms/stock_entry_form.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../screen/form/stock_forms/material_request_form.dart';
import '../../form_widgets.dart';

class MaterialRequestFilter extends StatefulWidget {
  const MaterialRequestFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Draft',
    'Submitted',
    'Stopped',
    'Cancelled',
    'Pending',
    'Partially Ordered',
    'Partially Received',
    'Ordered',
    'Issued',
    'Transferred',
    'Received',
  ];

  @override
  State<MaterialRequestFilter> createState() => _MaterialRequestFilterState();
}

class _MaterialRequestFilterState extends State<MaterialRequestFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter5'];
print('444444$_values');
    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: MaterialRequestFilter._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'] ,
          clear: true,
        ),
        CustomDropDown(
          'filter2',
          'Purpose'.tr(),
          items: purposeType,
          onChanged: (String value) => _values['filter2'] = value,
          onClear: () => _values.remove('filter2'),
          defaultValue: _values['filter2'],
          clear: true,
        ),
        CustomTextField('filter3', 'Warehouse'.tr(),
            onSave: (key, value) => _values[key] = value,
            initialValue: _values['filter3'],
            clearButton: true,

            onPressed: () async {
              final res = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => warehouseScreen()));
              if (res != null) _values['filter3'] = res;
              return res;
            }),
        DatePicker(
          'filter4',
          'From Date'.tr(),
          initialValue: _values['filter4'],
          onChanged: (value) {
            setState(() {
              _values['filter4'] = value;
              // remove date to if it's before from date
              if (_values['filter3'] != null &&
                  DateTime.parse(_values['filter3'])
                      .isBefore(DateTime.parse(_values['filter4']))) {
                _values.remove('filter3');
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
