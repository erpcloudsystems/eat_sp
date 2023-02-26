import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';
import '../../snack_bar.dart';

class CustomerVisitFilter extends StatefulWidget {
  const CustomerVisitFilter({Key? key}) : super(key: key);

  @override
  State<CustomerVisitFilter> createState() => _CustomerVisitFilterState();
}

class _CustomerVisitFilterState extends State<CustomerVisitFilter> {
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
          'Customer'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter1'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter1'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => selectCustomerScreen()));
            if (res != null) _values['filter1'] = res['name'];
            return _values['filter1'];
          },
        ),
        CustomTextField(
          'filter2',
          'Address'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter2'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter2'],
          onPressed: () async {
            if (_values['filter1'] == null)
              return showSnackBar('Please select a customer to first', context);
            final res = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    customerAddressScreen(_values['filter1'])));
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
          onClear: () => setState(() {
            _values.remove('filter4');
          }),
        ),
        CustomTextField(
          'filter5',
          'User'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter5'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter5'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => userListScreen()));
            if (res != null) _values['filter5'] = res;
            return _values['filter5'];
          },
        ),
      ],
    );
  }
}
