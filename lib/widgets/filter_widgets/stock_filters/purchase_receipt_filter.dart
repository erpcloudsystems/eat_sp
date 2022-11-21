import 'package:next_app/screen/filter_screen.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class PurchaseReceiptFilter extends StatefulWidget {
  const PurchaseReceiptFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Draft',
    'To Bill',
    'Completed',
    'Return Issued',
    'Cancelled',
    'Closed',
  ];

  @override
  State<PurchaseReceiptFilter> createState() => _PurchaseReceiptFilterState();
}

class _PurchaseReceiptFilterState extends State<PurchaseReceiptFilter> {
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
          items: PurchaseReceiptFilter._statusList,
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
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectSupplierScreen()));
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
        CustomTextField(
          'filter4',
          'Warehouse'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter4'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter4'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => warehouseScreen()));
            print('777777 ${res.runtimeType}');
            if (res != null) _values['filter4'] = res;
            return _values['filter4'];
          },
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
          onClear: () => _values.remove('filter5'),
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
          onClear: () => _values.remove('filter6'),
        ),
      ],
    );
  }
}
