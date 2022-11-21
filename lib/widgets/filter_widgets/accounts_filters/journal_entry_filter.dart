import 'package:next_app/screen/filter_screen.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class JournalEntryFilter extends StatefulWidget {
  const JournalEntryFilter({Key? key}) : super(key: key);

  static const List<String> _entryTypeList = [
   'Journal Entry',
   'Inter Company Journal Entry',
   'Bank Entry',
    'Cash Entry',
    'Credit Card Entry',
    'Debit Note',
    'Credit Note',
    'Contra Entry',
    'Excise Entry',
    'Write Off Entry',
    'Opening Entry',
    'Depreciation Entry',
    'Exchange Rate Revaluation',
    'Deferred Revenue',
    'Deferred Expense',
  ];

  @override
  State<JournalEntryFilter> createState() => _JournalEntryFilterState();
}

class _JournalEntryFilterState extends State<JournalEntryFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    _dateTo = _values['filter3'];

    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Entry Type'.tr(),
          items: JournalEntryFilter._entryTypeList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),

        DatePicker(
          'filter2',
          'From Date'.tr(),
          initialValue: _values['filter2'],
          onChanged: (value) {
            setState(() {
              _values['filter2'] = value;
              // remove date to if it's before from date
              if (_values['filter3'] != null && DateTime.parse(_values['filter3']).isBefore(DateTime.parse(_values['filter2']))) {
                _values.remove('filter3');
                _dateTo = '';
              }
            });
          },
          clear: true,
          onClear: () => setState(() {
            _values.remove('filter2');
          }),
        ),
        DatePicker(
          'filter3',
          'To Date'.tr(),
          firstDate: _values['filter2'] != null ? DateTime.parse(_values['filter2']) : null,
          initialValue: _dateTo,
          onChanged: (value) {
            _dateTo = value;
            setState(() => _values['filter3'] = value);
          },
          clear: true,
          onClear: () => setState(() {
            _values.remove('filter3');
          }),
        ),
      ],
    );
  }
}
