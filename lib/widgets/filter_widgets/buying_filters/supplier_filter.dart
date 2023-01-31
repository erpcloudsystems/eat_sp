import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class SupplierFilter extends StatefulWidget {
  const SupplierFilter({Key? key}) : super(key: key);

  @override
  State<SupplierFilter> createState() => _SupplierFilterState();
}

class _SupplierFilterState extends State<SupplierFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;

    return Column(
      children: [
        CustomTextField(
          'filter1',
          'Supplier Group'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter1'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter1'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => supplierGroupScreen()));
            if (res != null) _values['filter1'] = res;
            return _values['filter1'];
          },
        ),
        // CustomTextField(
        //   'filter2',
        //   'Country'.tr(),
        //   clearButton: true,
        //   onClear: () => _values.remove('filter2'),
        //   onSave: (key, value) => _values[key] = value,
        //   initialValue: _values['filter2'],
        //   onPressed: () async {
        //     final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => countryScreen()));
        //     if (res != null) _values['filter2'] = res;
        //     return _values['filter2'];
        //   },
        // ),
        CustomDropDown(
          'filter3',
          'Supplier Type'.tr(),
          items: supplierType,
          onChanged: (String value) => _values['filter3'] = value,
          onClear: () => _values.remove('filter3'),
          defaultValue: _values['filter3'],
          clear: true,
        ),
        // DatePicker(
        //   'filter4',
        //   'From Date'.tr(),
        //   initialValue: _values['filter4'],
        //   onChanged: (value) {
        //     setState(() {
        //       _values['filter4'] = value;
        //       // remove date to if it's before from date
        //       if (_values['filter5'] != null && DateTime.parse(_values['filter5']).isBefore(DateTime.parse(_values['filter4']))) {
        //         _values.remove('filter5');
        //         _dateTo = '';
        //       }
        //     });
        //   },
        //   clear: true,
        //   onClear: () => _values.remove('filter4'),
        // ),
        // DatePicker(
        //   'filter5',
        //   'To Date'.tr(),
        //   firstDate: _values['filter4'] != null ? DateTime.parse(_values['filter4']) : null,
        //   initialValue: _dateTo,
        //   onChanged: (value) {
        //     _dateTo = value;
        //     setState(() => _values['filter5'] = value);
        //   },
        //   clear: true,
        //   onClear: () => _values.remove('filter5'),
        // ),
      ],
    );
  }
}
