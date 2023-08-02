import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../list/otherLists.dart';
import '../../../../widgets/form_widgets.dart';
import '../../../../test/test_text_field.dart';
import '../../../../new_version/core/resources/strings_manager.dart';
import 'timing_details_form.dart';

class JobCardGroup3 extends StatelessWidget {
  const JobCardGroup3({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Group(
      child: ListView(
        children: [
          //_______________________________________Workstation_____________________________________________________
          CustomTextFieldTest('workstation', StringsManager.workstation.tr(),
              initialValue: data['workstation'],
              clearButton: true,
              onSave: (key, value) => data['workstation'] = value,
              onPressed: () async => await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => workstationListScreen()))),
          //_______________________________________Employee_____________________________________________________
          CustomTextFieldTest(
            'employee',
            StringsManager.employee.tr(),
            initialValue: data['employee'],
            onPressed: () async {
              String? id;
              final res = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => selectEmployeeScreen()));
              if (res != null) {
                id = res['name'];
              }
              return id;
            },
          ),
          //_______________________________________Timing details_____________________________________________________
          TimingDetailsForm(data: data),
        ],
      ),
    );
  }
}
