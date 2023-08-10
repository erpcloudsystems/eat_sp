import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'timing_details_form.dart';
import '../../../list/otherLists.dart';
import '../../../../test/test_text_field.dart';
import '../../../../widgets/form_widgets.dart';
import '../../../../new_version/core/resources/strings_manager.dart';

class JobCardGroup3 extends StatelessWidget {
  const JobCardGroup3({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Group(
      child: ListView(
        children: [
          //_______________________________Workstation______________________________________
          CustomTextFieldTest('workstation', StringsManager.workstation.tr(),
              initialValue: data['workstation'],
              clearButton: true,
              onSave: (key, value) => data['workstation'] = value,
              onPressed: () async => await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => workstationListScreen()))),
          //________________________________Timing details___________________________________
          TimingDetailsForm(data: data),
        ],
      ),
    );
  }
}
