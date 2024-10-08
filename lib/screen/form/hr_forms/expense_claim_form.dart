import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/inherited_widgets/add_expenses_list.dart';
import '../../../models/list_models/hr_list_model/expense_table_model.dart';

class ExpenseClaimForm extends StatefulWidget {
  const ExpenseClaimForm({Key? key}) : super(key: key);

  @override
  _ExpenseClaimFormState createState() => _ExpenseClaimFormState();
}

class _ExpenseClaimFormState extends State<ExpenseClaimForm> {
  Map<String, dynamic> data = {
    "doctype": "Expense Claim",
    "posting_date": DateTime.now().toIso8601String(),
    "approval_status": "Draft",
  };

  Map<String, dynamic> selectedEmployeeData = {
    'name': 'noName',
  };
  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    data['expenses'] = [];
    InheritedExpenseForm.of(context).expense.forEach((element) {
      data['expenses'].add(element.toJson);
    });

    log('${InheritedExpenseForm.of(context).taxData['cost_center']}');
    data['taxes'][0].remove('charge_type');
    data['taxes'][0]['rate'] = double.tryParse(
        (InheritedExpenseForm.of(context).taxData['rate'] ?? 0.0).toString());
    data['taxes'][0]['cost_center'] =
        InheritedExpenseForm.of(context).taxData['cost_center'];
    data['taxes'][0]['total'] =
        InheritedExpenseForm.of(context).taxData['total'];
    data['taxes'][0]['tax_amount'] =
        InheritedExpenseForm.of(context).taxData['tax_amount'];

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : provider.duplicateMode
                ? 'Duplicating Expense Claim ${provider.pageId}'
                : 'Adding new Expense Claim');

    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(EXPENSE_CLAIM_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null &&
        res['message']['expense_claim_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['expense_claim_data_name']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  Future<void> _getEmployeeData(String employee) async {
    selectedEmployeeData = Map<String, dynamic>.from(
        await APIService().getPage(EMPLOYEE_PAGE, employee))['message'];

    data[
        'cost_center'] = Map<String, dynamic>.from(await APIService().genericGet(
            'method/eat_mobile.general.general_service?doctype=${APIService.COMPANY}'))[
        'message'][0]['round_off_cost_center'];
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();

    data['taxes'] = context.read<UserProvider>().defaultTax;

    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        InheritedExpenseForm.of(context).expense.clear();
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }

        for (var element in data['expenses']) {
          InheritedExpenseForm.of(context)
              .expense
              .add(ExpenseModel.fromJson(element));
        }

        InheritedExpenseForm.of(context).taxData['rate'] =
            data['taxes'][0]['rate'].toString();

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
        bool? isGoBack =
            await checkDialog(context, 'Are you sure to go back?'.tr());
        if (isGoBack != null) {
          if (isGoBack) {
            InheritedExpenseForm.of(context).expense.clear();
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: CustomPageViewForm(
            submit: () => submit(),
            widgetGroup: [
              ListView(
                children: [
                  Group(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        CustomDropDownFromField(
                            defaultValue: data['employee'],
                            docType: APIService.EMPLOYEE,
                            nameResponse: 'name',
                            title: 'Employee'.tr(),
                            keys: const {
                              'subTitle': 'employee_name',
                              'trailing': 'department',
                            },
                            onChange: (value) async {
                              if (value != null) {
                                await _getEmployeeData(value['name']);

                                setState(() {
                                  data['employee'] = value['name'];
                                  data['employee_name'] =
                                      value['employee_name'];
                                  data['department'] = value['department'];
                                  data['company'] = value['company'];

                                  data['expense_approver'] =
                                      value['expense_approver'];
                                });
                              }
                            }),
                        if (data['employee_name'] != null)
                          CustomTextFieldTest(
                            'employee_name',
                            'Employee Name'.tr(),
                            initialValue: data['employee_name'],
                            enabled: false,
                          ),
                        if (data['department'] != null)
                          CustomTextFieldTest(
                            'department',
                            'Department'.tr(),
                            initialValue: data['department'],
                            enabled: false,
                          ),
                        CustomDropDownFromField(
                            defaultValue: data['expense_approver'],
                            docType: 'User',
                            nameResponse: 'name',
                            title: 'Expense Approver'.tr(),
                            keys: const {
                              'subTitle': 'full_name',
                              'trailing': '',
                            },
                            onChange: (value) async {
                              setState(() {
                                data['expense_approver'] = value['name'];
                              });
                            }),
                        CheckBoxWidget('is_paid', 'Is Paid'.tr(),
                            initialValue: data['is_paid'] == 1 ? true : false,
                            onChanged: (id, value) => setState(() {
                                  data[id] = value ? 1 : 0;
                                })),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Group(
                      child: Column(
                    children: [
                      Row(children: [
                        Flexible(
                            child: DatePickerTest(
                          'posting_date',
                          'Posting Date'.tr(),
                          initialValue: data['posting_date'],
                          onChanged: (value) =>
                              setState(() => data['posting_date'] = value),
                        )),
                        const SizedBox(width: 10),
                      ]),
                      CustomDropDownFromField(
                          defaultValue: data['project'],
                          docType: APIService.PROJECT,
                          nameResponse: 'name',
                          isValidate: false,
                          title: 'Project'.tr(),
                          keys: const {
                            'subTitle': 'project_name',
                            'trailing': 'status',
                          },
                          onChange: (value) async {
                            setState(() {
                              data['project'] = value['name'];
                            });
                          }),
                      CustomDropDownFromField(
                          defaultValue: data['cost_center'],
                          docType: APIService.COST_CENTER,
                          nameResponse: 'name',
                          isValidate: false,
                          title: 'Cost Center'.tr(),
                          keys: const {
                            'subTitle': 'parent_cost_center',
                            'trailing': 'cost_center_name',
                          },
                          onChange: (value) async {
                            setState(() {
                              data['cost_center'] = value['name'];
                            });
                          }),
                    ],
                  )),
                ],
              ),
              const SelectedExpensesList(),
            ],
          ),
        ),
      ),
    );
  }
}
