import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../new_version/core/resources/strings_manager.dart';
import '../../../provider/user/user_provider.dart';
import '../../../service/service.dart';
import '../../../service/service_constants.dart';
import '../../../provider/module/module_provider.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/snack_bar.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';

class BomForm extends StatefulWidget {
  const BomForm({Key? key}) : super(key: key);

  @override
  State<BomForm> createState() => _BomFormState();
}

class _BomFormState extends State<BomForm> {
  final server = APIService();
  bool withOperations = false;
  Map<String, dynamic> data = {
    "doctype": DocTypesName.bom,
  };

  final _formKey = GlobalKey<FormState>();

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

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Bom');

    // To print the body we send to backend
    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    data['docstatus'] = 0;

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(BOM_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['bom'] != null) {
        context.read<ModuleProvider>().pushPage(res['message']['bom']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['bom'] != null) {
      provider.pushPage(res['message']['task']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<ModuleProvider>();

    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        setState(() {});
      });
    }

    if (data['with_operations'] != null) {
      withOperations = operationsSwitch(data['with_operations']);
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        data['doctype'] = DocTypesName.bom;

        data['bom'] = data['name'];

        data.remove('print_formats');
        data.remove('conn');
        data.remove('comments');
        data.remove('attachments');
        data.remove('docstatus');
        data.remove('name');
        data.remove('_pageData');
        data.remove('_pageId');
        data.remove('_availablePdfFormat');
        data.remove('_currentModule');
        data.remove('status');
        data.remove('taxes');
        data.remove('users');
        data.remove('actual_time');

        setState(() {});
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    context.read<ModuleProvider>().resetCreationForm();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack = await checkDialog(context, 'Are you sure to go back?');
        if (isGoBack != null) {
          if (isGoBack) {
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: DismissKeyboard(
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: CustomPageViewForm(
              submit: () => submit(),
              widgetGroup: [
                //_________________________________________First Group_____________________________________________________
                Group(
                  child: ListView(
                    children: [
                      const SizedBox(height: 4),

                      //_______________________________________Item_____________________________________________________
                      CustomTextFieldTest(
                        'item',
                        StringsManager.item.tr(),
                        initialValue: data['item'],
                        disableValidation: false,
                        clearButton: true,
                        onChanged: (value) => data['item'] = value,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          final ItemSelectModel res =
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => newItemsScreen()));
                          data['item'] = res.itemCode;
                          return res.itemName;
                        },
                      ),
                      //_______________________________________Project_____________________________________________________
                      CustomTextFieldTest(
                        'project',
                        StringsManager.project.tr(),
                        initialValue: data['project'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) =>
                            setState(() => data['project'] = value),
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => projectScreen(),
                            ),
                          );
                          data['project'] = res['name'];
                          return res['name'];
                        },
                      ),
                      //_______________________________________Is Active_____________________________________________________
                      CheckBoxWidget(
                        'is_active',
                        StringsManager.isActive.tr(),
                        initialValue: data['is_active'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              data['is_active'] = 1;
                            } else {
                              data['is_active'] = 0;
                            }
                          },
                        ),
                      ),
                      //_______________________________________Is Default_____________________________________________________
                      CheckBoxWidget(
                        'is_default',
                        StringsManager.isDefault.tr(),
                        initialValue: data['is_default'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              data['is_default'] = 1;
                            } else {
                              data['is_default'] = 0;
                            }
                          },
                        ),
                      ),
                      //_______________________________________Allow Alternative Item___________________________________________
                      CheckBoxWidget(
                        'allow_alternative_item',
                        StringsManager.allowAlternativeItem.tr(),
                        initialValue:
                            data['allow_alternative_item'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              data['allow_alternative_item'] = 1;
                            } else {
                              data['allow_alternative_item'] = 0;
                            }
                          },
                        ),
                      ),
                      //___________________________________Set rate of sub-assembly item based on BOM_____________________________
                      CheckBoxWidget(
                        'set_rate_of_sub_assembly_item_based_on_bom',
                        StringsManager.setRateOfSubAssemblyItem.tr(),
                        initialValue:
                            data['set_rate_of_sub_assembly_item_based_on_bom'] ==
                                    'Yes'
                                ? true
                                : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              data['set_rate_of_sub_assembly_item_based_on_bom'] =
                                  'Yes';
                            } else {
                              data['set_rate_of_sub_assembly_item_based_on_bom'] =
                                  'No';
                            }
                          },
                        ),
                      ),
                      //___________________________________Quantity_____________________________
                      CustomTextFieldTest(
                        'quantity',
                        StringsManager.quantity.tr(),
                        initialValue: '${data['quantity'] ?? '1'}',
                        hintText: 'ex:1.0',
                        clearButton: true,
                        validator: (value) =>
                            numberValidation(value, allowNull: false),
                        keyboardType: TextInputType.number,
                        onSave: (key, value) =>
                            data[key] = double.tryParse(value) ?? 1,
                      ),
                    ],
                  ),
                ),

                //__________________________________________Second Group_____________________________________________________
                Group(
                  child: ListView(
                    children: [
                      //_______________________________________Currency___________________________________________________
                      CustomTextFieldTest(
                          'currency', StringsManager.currency.tr(),
                          initialValue: data['currency'] ??
                              context.read<UserProvider>().defaultCurrency,
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => currencyListScreen()))),
                      //_______________________________________Rate Of Materials________________________________________________
                      CustomDropDown(
                        'rm_cost_as_per',
                        StringsManager.rateOfMaterialsBasedOn.tr(),
                        fontSize: 13.sp,
                        items: rateList,
                        defaultValue: data['rm_cost_as_per'] ?? rateList[0],
                        onChanged: (value) => setState(() {
                          data['rm_cost_as_per'] = value;
                        }),
                      ),
                      //_______________________________________With Operations_____________________________________________________
                      CheckBoxWidget(
                        'with_operations',
                        StringsManager.withOperations.tr(),
                        fontSize: 16,
                        initialValue:
                            data['with_operations'] == 1 ? true : false,
                        onChanged: (id, value) => setState(() {
                          data[id] = value ? 1 : 0;
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
                          defaultValue: data['transfer_material_against'] ??
                              workOrderOrJopCard[0],
                          onChanged: (value) => setState(() {
                            data['transfer_material_against'] = value;
                          }),
                        ),
                    ],
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
