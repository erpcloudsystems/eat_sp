import 'package:NextApp/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../screen/filter_screen.dart';
import '../../form_widgets.dart';

class WorkflowFilterScreen extends StatefulWidget {
  const WorkflowFilterScreen({Key? key}) : super(key: key);

  @override
  State<WorkflowFilterScreen> createState() => _WorkflowFilterScreenState();
}

class _WorkflowFilterScreenState extends State<WorkflowFilterScreen> {
  Map<String, dynamic> _values = {};

  @override
  Widget build(BuildContext context) {
    _values = FilterScreen.of(context).values;
    return Column(
      children: [
        CustomTextField(
          'filter1',
          'Document Type'.tr(),
          clearButton: true,
          onClear: () => _values.remove('filter1'),
          onSave: (key, value) => _values[key] = value,
          initialValue: _values['filter1'],
          onPressed: () async {
            final res = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => documentTypeListScreen(),
              ),
            );
            if (res != null) _values['filter1'] = res;
            return _values['filter1'];
          },
        ),
      ],
    );
  }
}
