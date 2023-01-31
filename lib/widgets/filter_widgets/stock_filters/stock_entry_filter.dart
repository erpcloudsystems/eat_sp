import '../../../screen/filter_screen.dart';
import '../../../screen/form/stock_forms/stock_entry_form.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class StockEntryFilter extends StatefulWidget {
  const StockEntryFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Draft',
    'Submitted',
    'Cancelled',
  ];

  @override
  State<StockEntryFilter> createState() => _StockEntryFilterState();
}

class _StockEntryFilterState extends State<StockEntryFilter> {
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
          items: StockEntryFilter._statusList,
          onChanged: (String value) =>
              _values['filter1'] = StockEntryFilter._statusList.indexOf(value),
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'] != null
              ? StockEntryFilter._statusList[_values['filter1']]
              : null,
          clear: true,
        ),
        CustomDropDown(
          'filter2',
          'Stock Entry Type'.tr(),
          items: stockEntryType,
          onChanged: (String value) => _values['filter2'] = value,
          onClear: () => _values.remove('filter2'),
          defaultValue: _values['filter2'],
          clear: true,
        ),
        DatePicker(
          'filter3',
          'From Date'.tr(),
          initialValue: _values['filter3'],
          onChanged: (value) {
            setState(() {
              _values['filter3'] = value;
              // remove date to if it's before from date
              if (_values['filter4'] != null &&
                  DateTime.parse(_values['filter4'])
                      .isBefore(DateTime.parse(_values['filter3']))) {
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
          firstDate: _values['filter3'] != null
              ? DateTime.parse(_values['filter3'])
              : null,
          initialValue: _dateTo,
          onChanged: (value) {
            _dateTo = value;
            setState(() => _values['filter4'] = value);
          },
          clear: true,
          onClear: () => _values.remove('filter4'),
        ),
        CustomTextField('filter5', 'From Warehouse'.tr(),
            onSave: (key, value) => _values[key] = value,
            initialValue: _values['filter5'],
            onPressed: () async {
              final res = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => warehouseScreen(_values['filter6'])));
              if (res != null) _values['filter5'] = res;
              return res;
            }),
        CustomTextField('filter6', 'To Warehouse'.tr(),
            initialValue: _values['filter6'],
            onSave: (key, value) => _values[key] = value,
            onPressed: () async {
              final res = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => warehouseScreen(_values['filter5'])));
              if (res != null) _values['filter6'] = res;
              return res;
            }),
      ],
    );
  }
}
