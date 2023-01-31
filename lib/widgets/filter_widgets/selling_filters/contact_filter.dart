import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';
import '../../snack_bar.dart';

class ContactFilter extends StatefulWidget {
  const ContactFilter({Key? key}) : super(key: key);

  static const List<String> _contactTypeList = [
    'Passive',
    'Open',
    'Replied',
  ];

  @override
  State<ContactFilter> createState() => _ContactFilterState();
}

class _ContactFilterState extends State<ContactFilter> {
  Map<String, dynamic> _values = {};
  String? _dateTo;

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    //_dateTo = _values['filter4'];

    return Column(
      children: [
        CustomDropDown(
          'filter1',
          'Status'.tr(),
          items: ContactFilter._contactTypeList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomDropDown(
          'filter2',
          'Link Document Type'.tr(),
          items: ['Customer','Supplier'],
          onChanged: (String value) {
            setState(() {
              _values['filter2'] = value;
            });
          },
          onClear: () => _values.remove('filter2'),
          defaultValue: _values['filter2'],
          clear: true,
        ),


        CustomTextField(
          'filter3',
          'Link Name'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            if(_values['filter2']==null)
              return showSnackBar(
                  'Please select a Link Type to first',
                  context);
            if(_values['filter2']=='Supplier'){
              final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectSupplierScreen()));
              if (res != null) _values['filter3'] = res['name'];
              return _values['filter3'];
            }
            if(_values['filter2']=='Customer'){
              final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => selectCustomerScreen()));
              if (res != null) _values['filter3'] = res['name'];
              return _values['filter3'];
            }

          },
        ),

      ],
    );
  }
}
