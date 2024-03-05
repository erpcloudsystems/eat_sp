
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../list/otherLists.dart';
import '../../../../widgets/form_widgets.dart';
import '../../../../widgets/new_widgets/test_text_field.dart';
import '../../../../new_version/core/resources/strings_manager.dart';
import '../../../../models/list_models/stock_list_model/item_table_model.dart';

class Group1 extends StatefulWidget {
  const Group1({super.key, required this.data});
   final Map<String, dynamic> data;

  @override
  State<Group1> createState() => _Group1State();
}

class _Group1State extends State<Group1> {
  @override
  Widget build(BuildContext context) {
    return   Group(
                  child: ListView(
                    children: [
                      const SizedBox(height: 4),
                      //_______________________________________Item_____________________________________________________
                      CustomTextFieldTest(
                        'item',
                        StringsManager.item.tr(),
                        initialValue: widget.data['item'],
                        disableValidation: false,
                        clearButton: true,
                        onChanged: (value) => widget.data['item'] = value,
                        onSave: (key, value) => widget.data[key] = value,
                        onPressed: () async {
                          final ItemSelectModel res =
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => newItemsScreen()));
                          widget.data['item'] = res.itemCode;
                          return res.itemName;
                        },
                      ),
                      //_______________________________________Project_____________________________________________________
                      CustomTextFieldTest(
                        'project',
                        StringsManager.project.tr(),
                        initialValue: widget.data['project'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => widget.data[key] = value,
                        onChanged: (value) =>
                            setState(() => widget.data['project'] = value),
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => projectScreen(),
                            ),
                          );
                          widget.data['project'] = res['name'];
                          return res['name'];
                        },
                      ),
                      //_______________________________________Is Active_____________________________________________________
                      CheckBoxWidget(
                        'is_active',
                        StringsManager.isActive.tr(),
                        initialValue: widget.data['is_active'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              widget.data['is_active'] = 1;
                            } else {
                              widget.data['is_active'] = 0;
                            }
                          },
                        ),
                      ),
                      //_______________________________________Is Default_____________________________________________________
                      CheckBoxWidget(
                        'is_default',
                        StringsManager.isDefault.tr(),
                        initialValue: widget.data['is_default'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              widget.data['is_default'] = 1;
                            } else {
                              widget.data['is_default'] = 0;
                            }
                          },
                        ),
                      ),
                      //_______________________________________Allow Alternative Item___________________________________________
                      CheckBoxWidget(
                        'allow_alternative_item',
                        StringsManager.allowAlternativeItem.tr(),
                        initialValue:
                            widget.data['allow_alternative_item'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              widget.data['allow_alternative_item'] = 1;
                            } else {
                              widget.data['allow_alternative_item'] = 0;
                            }
                          },
                        ),
                      ),
                      //___________________________________Set rate of sub-assembly item based on BOM_____________________________
                      CheckBoxWidget(
                        'set_rate_of_sub_assembly_item_based_on_bom',
                        StringsManager.setRateOfSubAssemblyItem.tr(),
                        initialValue:
                            widget.data['set_rate_of_sub_assembly_item_based_on_bom'] ==
                                    'Yes'
                                ? true
                                : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              widget.data['set_rate_of_sub_assembly_item_based_on_bom'] =
                                  'Yes';
                            } else {
                              widget.data['set_rate_of_sub_assembly_item_based_on_bom'] =
                                  'No';
                            }
                          },
                        ),
                      ),
                      //___________________________________Quantity_____________________________
                      CustomTextFieldTest(
                        'quantity',
                        StringsManager.quantity.tr(),
                        initialValue: '${widget.data['quantity'] ?? '1'}',
                        hintText: 'ex:1.0',
                        clearButton: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: false),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            widget.data[key] = double.tryParse(value) ?? 1,
                      ),
                    ],
                  ),
                );
  }
}