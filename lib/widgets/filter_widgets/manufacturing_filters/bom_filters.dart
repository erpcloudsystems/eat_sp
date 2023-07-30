import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../screen/filter_screen.dart';
import '../../../screen/list/otherLists.dart';
import '../../form_widgets.dart';

class BomFilterScreen extends StatefulWidget {
  const BomFilterScreen({Key? key}) : super(key: key);

  @override
  State<BomFilterScreen> createState() => _BomFilterScreenState();
}

class _BomFilterScreenState extends State<BomFilterScreen> {
  Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    return Column(
      children: [
        //_______________________________Currency___________________________________________
        CustomTextField(
          'filter3',
          StringsManager.currency.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter3'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter3'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => currencyListScreen(),
              ),
            );
            if (res != null) _values['filter3'] = res;
            return _values['filter3'];
          },
        ),
        //_______________________________________Is Active_____________________________________________________
        CheckBoxWidget(
          'is_active',
          StringsManager.isActive.tr(),
          initialValue: _values['filter1'] == 1 ? true : false,
          onChanged: (id, value) => setState(
            () {
              if (value == true) {
                _values['filter1'] = 1;
              } else {
                _values['filter1'] = 0;
              }
            },
          ),
        ),
        //_______________________________________Is Default_____________________________________________________
        CheckBoxWidget(
          'is_default',
          StringsManager.isDefault.tr(),
          initialValue: _values['filter2'] == 1 ? true : false,
          onChanged: (id, value) => setState(
            () {
              if (value == true) {
                _values['filter2'] = 1;
              } else {
                _values['filter2'] = 0;
              }
            },
          ),
        ),
      ],
    );
  }
}
