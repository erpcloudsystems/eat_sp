import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../list/otherLists.dart';
import '../../../widgets/form_widgets.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/strings_manager.dart';

class OperationDialog extends StatefulWidget {
  const OperationDialog({Key? key}) : super(key: key);

  @override
  State<OperationDialog> createState() => _OperationDialogState();
}

class _OperationDialogState extends State<OperationDialog> {
  Map<String, dynamic> operations = {};
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: SizedBox(
          height: 615.h,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    StringsManager.addOperation.tr(),
                    style: const TextStyle(color: Colors.black87, fontSize: 22),
                  ),
                ),
                Group(
                  child: Column(
                    children: [
                      //_____________________Operation_____________________________________
                      CustomTextField(
                        'operation',
                        StringsManager.operation.tr(),
                        disableValidation: false,
                        initialValue: operations['operation'],
                        clearButton: true,
                        onSave: (key, value) => operations['operation'] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => operationsListScreen()));
                          return res;
                        },
                      ),
                      //_____________________Workstation_____________________________________
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        'workstation',
                        StringsManager.workstation.tr(),
                        initialValue: operations['workstation'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) =>
                            operations['workstation'] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => workstationListScreen()));
                          return res;
                        },
                      ),
                      //_____________________Operation Time_____________________________________
                      const SizedBox(
                        height: 10,
                      ),
                      NumberTextField(
                        'time_in_mins',
                        StringsManager.operationTime.tr(),
                        initialValue: operations['time_in_mins'],
                        validator: (value) =>
                            numberValidation(value, allowNull: false),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            operations['time_in_mins'] = double.tryParse(value),
                        onChanged: (value) => setState(() {
                          operations['time_in_mins'] = double.tryParse(value);
                        }),
                      ),
                      //_____________________Hour Rate_____________________________________
                      const SizedBox(
                        height: 10,
                      ),
                      NumberTextField(
                        'hour_rate',
                        StringsManager.hourRate.tr(),
                        initialValue: operations['hour_rate'],
                        validator: (value) =>
                            numberValidation(value, allowNull: false),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            operations['hour_rate'] = double.tryParse(value),
                        onChanged: (value) => setState(() {
                          operations['hour_rate'] = double.tryParse(value);
                        }),
                      ),
                      //_____________________Operating Cost_____________________________________
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        'operating_cost',
                        StringsManager.operatingCost.tr(),
                        enabled: false,
                        initialValue: operations['hour_rate'] != null &&
                                operations['time_in_mins'] != null
                            ? (operations['hour_rate'] *
                                    operations['time_in_mins'])
                                .toString()
                            : '0.0',
                        onSave: (key, value) => operations['operating_cost'] =
                            double.tryParse(value),
                      ),
                      //_____________________Fixed Time_________________________________________
                      const SizedBox(
                        height: 10,
                      ),
                      CheckBoxWidget(
                        'fixed_time',
                        StringsManager.fixedTime.tr(),
                        fontSize: 16,
                        initialValue:
                            operations['fixed_time'] == 1 ? true : false,
                        onChanged: (id, value) =>
                            setState(() => operations[id] = value ? 1 : 0),
                      ),
                    ],
                  ),
                ),
                //_____________________Save Button_________________________________________
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          Provider.of<ModuleProvider>(context, listen: false)
                              .setBomOperations = operations;
                          Navigator.of(context).pop();
                        }
                        log(Provider.of<ModuleProvider>(context, listen: false)
                            .getBomOperations
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
                      child: const Text(
                        StringsManager.saveOperation,
                        style: TextStyle(fontSize: 18),
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
