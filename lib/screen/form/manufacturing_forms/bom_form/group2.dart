import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../new_version/core/resources/strings_manager.dart';
import '../../../../provider/module/module_provider.dart';
import '../../../../provider/user/user_provider.dart';

import '../../../../test/test_text_field.dart';
import '../../../../widgets/page_group.dart';
import '../../../list/otherLists.dart';
import '../../../../widgets/form_widgets.dart';
import '../../../../core/constants.dart';
import 'operation_dialog.dart';

class Group2 extends StatefulWidget {
  const Group2({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data;
  @override
  State<Group2> createState() => _Group2State();
}

class _Group2State extends State<Group2> {
  bool withOperations = false;

  /// This is a helper function to know the "with operations" status.
  bool operationsSwitch(int status) {
    switch (status) {
      case 0:
        return false;
      case 1:
        return true;
      default:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.data['with_operations'] != null) {
      withOperations = operationsSwitch(widget.data['with_operations']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ModuleProvider>();
    List? operations = widget.data['operations'];
    List operationsList = Provider.of<ModuleProvider>(context).getBomOperations;
    widget.data['operations'] = operationsList;
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      operations?.map((e) {
            provider.setBomOperations = e;
          }).toList() ??
          [];
    }
    return Group(
      child: ListView(
        children: [
          //_______________________________________Currency___________________________________________________
          CustomTextFieldTest('currency', StringsManager.currency.tr(),
              initialValue: widget.data['currency'] ??
                  context.read<UserProvider>().defaultCurrency,
              clearButton: true,
              onSave: (key, value) => widget.data[key] = value,
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => currencyListScreen()))),
          //_______________________________________Rate Of Materials________________________________________________
          CustomDropDown(
            'rm_cost_as_per',
            StringsManager.rateOfMaterialsBasedOn.tr(),
            fontSize: 13.sp,
            items: rateList,
            defaultValue: widget.data['rm_cost_as_per'] ?? rateList[0],
            onChanged: (value) => setState(() {
              widget.data['rm_cost_as_per'] = value;
            }),
          ),
          //_______________________________________With Operations_____________________________________________________
          CheckBoxWidget(
            'with_operations',
            StringsManager.withOperations.tr(),
            fontSize: 16,
            initialValue: widget.data['with_operations'] == 1 ? true : false,
            onChanged: (id, value) => setState(() {
              widget.data[id] = value ? 1 : 0;
              withOperations = value;
            }),
          ),
          //_______________________________________Transfer Material Against________________________________________________
          if (withOperations)
            CustomDropDown(
              'transfer_material_against',
              StringsManager.transferMaterialAgainst.tr(),
              fontSize: 16,
              items: workOrderOrJopCard,
              defaultValue: widget.data['transfer_material_against'] ??
                  workOrderOrJopCard[0],
              onChanged: (value) => setState(() {
                widget.data['transfer_material_against'] = value;
              }),
            ),
          //_______________________________________operations________________________________________________
          if (withOperations)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        StringsManager.addOperation.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          bottomSheetBuilder(
                            bottomSheetView: const OperationDialog(),
                            context: context,
                          );
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
                        child: const Icon(
                          Icons.add,
                        ),
                      )
                    ],
                  ),
                ),

                // Operations list
                if (operationsList.isNotEmpty)
                  SizedBox(
                    height: 190,
                    child: ListView.builder(
                      itemCount: operationsList.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: PageCard(
                                items: [
                                  {
                                    StringsManager.operation:
                                        operationsList[index]['operation'] ??
                                            'none',
                                    StringsManager.workstation:
                                        operationsList[index]['workstation'] ??
                                            'none',
                                    StringsManager.operationTime:
                                        operationsList[index]['time_in_mins']
                                            .toString(),
                                    StringsManager.operatingCost:
                                        operationsList[index]['operating_cost']
                                            .toString(),
                                  }
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(
                                  () => operationsList.removeAt(index)),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
