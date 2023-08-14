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
              onPressed: () async {
                final res = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => workstationListScreen()));
                if (res != null) data['workstation'] = res;
                return res;
              }),
          //________________________________ Remarks ___________________________________
          CustomTextFieldTest(
            'remarks',
            StringsManager.remarks.tr(),
            minLines: 3,
            maxLines: null,
            removeUnderLine: true,
            initialValue: data['remarks'],
            disableValidation: true,
            clearButton: true,
            onSave: (key, value) => data[key] = value,
            onChanged: (value) => data['remarks'] = value,
          ),
          //________________________________Timing details___________________________________
          TimingDetailsForm(data: data),
        ],
      ),
    );
  }
}
