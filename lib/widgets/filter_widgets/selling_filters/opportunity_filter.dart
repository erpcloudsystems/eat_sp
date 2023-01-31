import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class OpportunityFilter extends StatefulWidget {
  const OpportunityFilter({Key? key}) : super(key: key);

  static const List<String> _statusList = [
    'Open',
    'Quotation',
    'Converted',
    'Lost',
    'Replied',
    'Closed',
  ];

  @override
  State<OpportunityFilter> createState() => _OpportunityFilterState();
}

class _OpportunityFilterState extends State<OpportunityFilter> {
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
          items: OpportunityFilter._statusList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomDropDown(
          'filter2',
          'Opportunity From'.tr(),
          items: KQuotationToList,
          onChanged: (String value) => setState(() {
            if (_values['filter2'] == value) return;
            _values['filter2'] = value;
            _values.remove('filter3');
          }),
          onClear: () => setState(() {
            _values.remove('filter2');
            _values.remove('filter3');
          }),
          defaultValue: _values['filter2'],
          clear: true,
        ),
        CustomTextField(
          'filter3',
          'Party'.tr(),
          clearButton: true,
          liestenToInitialValue: true,
          enabled: _values['filter2'] != null,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            final res = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => _values['filter2'] == KQuotationToList[0] ? selectLeadScreen() : selectCustomerScreen()));
            if (res != null) _values['filter3'] = res['name'];
            return _values['filter3'];
          },
        ),
        CustomTextField(
          'filter4',
          'Opportunity Type'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter4'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter4'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => opportunityTypeScreen()));
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
