import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class PaymentEntryFilter extends StatefulWidget {
  const PaymentEntryFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = ['Draft', 'Submitted', 'Cancelled'];

  @override
  State<PaymentEntryFilter> createState() => _PaymentEntryFilterState();
}

class _PaymentEntryFilterState extends State<PaymentEntryFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter7'];

    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: PaymentEntryFilter._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomDropDown(
          'filter2',
          'Payment Type'.tr(),
          items: paymentType,
          onChanged: (String value) => _values['filter2'] = value,
          onClear: () => _values.remove('filter2'),
          defaultValue: _values['filter2'],
          clear: true,
        ),
        CustomTextField(
          'filter3',
          'Mode Of Payment'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => modeOfPaymentScreen()));
            if (res != null) _values['filter3'] = res;
            return _values['filter3'];
          },
        ),
        CustomDropDown(
          'filter4',
          'Party Type'.tr(),
          items: KPaymentPartyList,
          onChanged: (String value) => setState(() {
            if (_values['filter4'] == value) return;
            _values['filter4'] = value;
            _values.remove('filter5');
          }),
          onClear: () => setState(() {
            _values.remove('filter4');
            _values.remove('filter5');
          }),
          defaultValue: _values['filter4'],
          clear: true,
        ),
        CustomTextField(
          'filter5',
          'Party'.tr(),
          clearButton: true,
          liestenToInitialValue: true,
          enabled: _values['filter4'] != null,
          onClear: () => _values.remove('filter5'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter5'],
          onPressed: () async {
            final res = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => _values['filter4'] == KPaymentPartyList[0] ? selectCustomerScreen() : supplierListScreen()));
            if (res != null) _values['filter5'] = res['name'];
            return _values['filter5'];
          },
        ),
        DatePicker(
          'filter6',
          'From Date'.tr(),
          initialValue: _values['filter6'],
          onChanged: (value) {
            setState(() {
              _values['filter6'] = value;
              // remove date to if it's before from date
              if (_values['filter7'] != null && DateTime.parse(_values['filter7']).isBefore(DateTime.parse(_values['filter6']))) {
                _values.remove('filter7');
                _dateTo = '';
              }
            });
          },
          clear: true,
          onClear: () => _values.remove('filter6'),
        ),
        DatePicker(
          'filter7',
          'To Date'.tr(),
          firstDate: _values['filter7'] != null ? DateTime.parse(_values['filter7']) : null,
          initialValue: _dateTo,
          onChanged: (value) {
            _dateTo = value;
            setState(() => _values['filter7'] = value);
          },
          clear: true,
          onClear: () => _values.remove('filter7'),
        ),
      ],
    );
  }
}
