import '../../../../new_version/core/extensions/date_tine_extension.dart';
import '../../../../new_version/core/resources/app_values.dart';
import '../../../../provider/module/module_provider.dart';
import '../../../../widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../new_version/core/resources/strings_manager.dart';
import '../../../list/otherLists.dart';

class TimingDetailsDialog extends StatelessWidget {
  TimingDetailsDialog({
    Key? key,
  }) : super(key: key);

  final Map<String, dynamic> timeLogs = {};
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: Text(
              StringsManager.addTimeLog.tr(),
              style: const TextStyle(color: Colors.black87, fontSize: 22),
            ),
          ),
          Group(
            child: Column(
              children: [
                //________________________________Employee____________________________
                CustomTextField(
                  'employee',
                  StringsManager.employee.tr(),
                  initialValue: timeLogs['employee'],
                  onPressed: () async {
                    final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => selectEmployeeScreen()));
                    if (res != null) {
                      timeLogs['employee'] = res['name'];
                    }
                    return res['employee_name'];
                  },
                ),
                //________________________________From Time____________________________________
                DatePicker('from_time', StringsManager.fromDate.tr(),
                    initialValue: timeLogs['from_time'],
                    onChanged: (value) =>
                        timeLogs['from_time'] = value.formateToReadableDate()),
                TimePicker(
                  'from',
                  StringsManager.fromTime.tr(),
                  onChanged: (value) {
                    String mergedTime = timeLogs['from_time'] + 'T$value';
                    timeLogs['from_time'] = mergedTime;
                  },
                ),
                //________________________________To Time____________________________________
                DatePicker('to_time', StringsManager.toDate.tr(),
                    initialValue: timeLogs['to_time'],
                    onChanged: (value) =>
                        timeLogs['to_time'] = value.formateToReadableDate()),
                TimePicker(
                  'to',
                  StringsManager.toTime.tr(),
                  onChanged: (value) {
                    String mergedTime = timeLogs['to_time'] + 'T$value';
                    timeLogs['to_time'] = mergedTime;
                  },
                ),
                //________________________________Completed Quantity____________________________________
                CustomTextField(
                  'completed_qty',
                  StringsManager.completedQuantity.tr(),
                  disableValidation: false,
                  initialValue: timeLogs['for_quantity'],
                  validator: (value) =>
                      numberValidation(value, allowNull: false),
                  keyboardType: TextInputType.number,
                  onSave: (key, value) =>
                      timeLogs['completed_qty'] = int.tryParse(value),
                  onChanged: (value) =>
                      timeLogs['completed_qty'] = int.tryParse(value),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    Provider.of<ModuleProvider>(context, listen: false)
                        .setTimeSheet = timeLogs;
                    Navigator.of(context).pop();
                  }
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(DoublesManager.d_8)))),
                child: Text(
                  StringsManager.saveTimeLog.tr(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
