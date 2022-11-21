import 'package:next_app/screen/filter_screen.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';
import '../../snack_bar.dart';

class AddressFilter extends StatefulWidget {
  const AddressFilter({Key? key}) : super(key: key);

  static const List<String> _addressTypeList = [
    'Billing',
    'Shipping',
    'Office',
    'Personal',
    'Plant',
    'Postal',
    'Shop',
    'Subsidiary',
    'Warehouse',
    'Current',
    'Permanent',
    'Other',
  ];

  @override
  State<AddressFilter> createState() => _AddressFilterState();
}

class _AddressFilterState extends State<AddressFilter> {
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
          'Address Type '.tr(),
          items: AddressFilter._addressTypeList,
          onChanged: (String value) => _values['filter1'] = value,
          onClear: () => _values.remove('filter1'),
          defaultValue: _values['filter1'],
          clear: true,
        ),
        CustomDropDown(
          'filter2',
          'Link Document Type'.tr(),
          fontSize: 11,
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
