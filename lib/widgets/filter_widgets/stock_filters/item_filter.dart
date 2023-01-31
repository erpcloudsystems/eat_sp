import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../form_widgets.dart';

class ItemFilter extends StatefulWidget {
  const ItemFilter({Key? key}) : super(key: key);

  @override
  State<ItemFilter> createState() => _ItemFilterState();
}

class _ItemFilterState extends State<ItemFilter> {
  Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;

    return Column(
      children: [
        CustomTextField(
          'filter1',
          'Item Group'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter1'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter1'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => itemGroupScreen()));
            if (res != null) _values['filter1'] = res;
            return _values['filter1'];
          },
        ),
        CustomTextField(
          'filter2',
          'Brand'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter2'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter2'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => userListScreen()));
            if (res != null) _values['filter2'] = res;
            return _values['filter2'];
          },
        ),
        CheckBoxWidget(
          'filter3',
          'Is Stock Item',
          initialValue: _values['filter3'] == 1 ? true : false,
          onChanged: (id, value) => setState(() => _values[id] = value ? 1 : 0),
          clear: true,
          onClear: () => _values.remove('filter3'),
        ),
        CustomTextField(
          'filter4',
          'UOM'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter4'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter4'],
          onPressed: () async {
            final res = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => uomListScreen()));
            if (res != null) _values['filter4'] = res;
            return _values['filter4'];
          },
        ),
      ],
    );
  }
}
