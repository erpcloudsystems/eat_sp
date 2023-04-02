import 'package:NextApp/widgets/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/module/module_provider.dart';
import '../../list/otherLists.dart';

class AddTimeSheetDialog extends StatefulWidget {
  const AddTimeSheetDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTimeSheetDialog> createState() => _AddTimeSheetDialogState();
}

class _AddTimeSheetDialogState extends State<AddTimeSheetDialog> {
  Map<String, dynamic> timeSheet = {};

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return Material(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 550,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Add Time Sheet',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                    ),
                  ),
                ),
                Group(
                  child: Column(
                    children: [
                      CustomTextField(
                        'activity_type',
                        'Activity Type',
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) =>
                            timeSheet['activity_type'] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => activityListScreen(),
                            ),
                          );
                          return res;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        'project',
                        'Select Project',
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => timeSheet['project'] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => projectScreen(),
                            ),
                          );
                          return res;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        'hours',
                        'Hours',
                        disableValidation: false,
                        clearButton: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: false),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            timeSheet['hours'] = double.tryParse(value),
                        onChanged: (value) =>
                            timeSheet['hours'] = double.tryParse(value),
                      ),
                      DatePicker(
                        'from_time',
                        'From Time',
                        initialValue: timeSheet['from_time'] ?? null,
                        onChanged: (value) {
                          timeSheet['from_time'] = value;
                        }
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                            Provider.of<ModuleProvider>(context,listen: false).setTimeSheet =
                                timeSheet;
                          Navigator.of(context).pop();
                        }
                        print(Provider.of<ModuleProvider>(context,listen: false)
                            .getTimeSheetData
                            .toString());
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        'Save Time sheet',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
