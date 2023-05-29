import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../provider/user/user_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/inherited_widgets/add_expenses_list.dart';
import '../../../models/list_models/hr_list_model/expense_table_model.dart';
import '../../../models/page_models/hr_page_model/expense_claim_page_model.dart';

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

    for (var k in data.keys) log("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(EXPENSE_CLAIM_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null && res['message']['expense_claim_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['expense_claim_data_name']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  Future<void> _getEmployeeData(String employee) async {
    selectedEmployeeData = Map<String, dynamic>.from(
        await APIService().getPage(EMPLOYEE_PAGE, employee))['message'];

    data['cost_center'] = Map<String, dynamic>.from(await APIService()
        .genericGet('method/ecs_mobile.general.general_service?doctype=' +
            APIService.COMPANY))['message'][0]['round_off_cost_center'];
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();

    data['taxes'] = context.read<UserProvider>().defaultTax;

    if (provider.isEditing || provider.duplicateMode)
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        for (var k in data.keys) log("➡️ $k: ${data[k]}");

        final expenses = ExpenseClaimPageModel(context, data).expenses;
        expenses.forEach((element) => InheritedExpenseForm.of(context)
            .expense
            .add(ExpenseModel.fromJson(element)));
        InheritedExpenseForm.of(context).taxData['rate'] =
            data['taxes'][0]['rate'].toString();

        setState(() {});
      });
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
            InheritedExpenseForm.of(context).expense.clear();
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Expense Claim".tr())
              : Text("Create Expense Claim".tr()),
          actions: [
            Material(
                color: Colors.transparent,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: IconButton(
                  onPressed: submit,
                  icon: Icon(Icons.check, color: FORM_SUBMIT_BTN_COLOR),
                ))
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 8),
                Group(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        'employee',
                        'Employee'.tr(),
                        initialValue: data['employee'],
                        onPressed: () async {
                          String? id;
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectEmployeeScreen()));
                          if (res != null) {
                            id = res['name'];
                            await _getEmployeeData(res['name']);

                            setState(() {
                              data['employee'] = res['name'];
                              data['employee_name'] = res['employee_name'];
                              data['department'] = res['department'];
                              data['company'] = res['company'];
                              // data['currency'] = res['currency'];
                              // data['advance_account'] = res['advance_account'];
                            });
                          }
                          return id;
                        },
                      ),
                      if (data['employee_name'] != null)
                        CustomTextField(
                          'employee_name',
                          'Employee Name'.tr(),
                          initialValue: data['employee_name'],
                          enabled: false,
                        ),
                      if (data['department'] != null)
                        CustomTextField(
                          'department',
                          'Department'.tr(),
                          initialValue: data['department'],
                          enabled: false,
                        ),
                      CustomTextField(
                          'expense_approver', 'Expense Approver'.tr(),
                          initialValue: data['expense_approver'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            var res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => userListScreen()));
                            return res;
                          }),
                      CheckBoxWidget('is_paid', 'Is Paid'.tr(),
                          initialValue: data['is_paid'] == 1 ? true : false,
                          onChanged: (id, value) => setState(() {
                                data[id] = value ? 1 : 0;
                              })),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                Group(
                    child: Column(
                  children: [
                    Row(children: [
                      Flexible(
                          child: DatePicker(
                        'posting_date',
                        'Posting Date'.tr(),
                        initialValue: data['posting_date'],
                        onChanged: (value) =>
                            setState(() => data['posting_date'] = value),
                      )),
                      SizedBox(width: 10),
                    ]),
                    // Mansy told me to delete From Page & Create @17/10/2022
                    // CustomTextField('company', tr('Company'),
                    //     initialValue: data['company'],
                    //     onSave: (key, value) => data[key] = value,
                    //     onPressed: () async {
                    //       final res = await Navigator.of(context).push(
                    //           MaterialPageRoute(
                    //               builder: (_) => companyListScreen()));
                    //
                    //       return res['name'];
                    //     }),
                    CustomTextField('payable_account', tr('Payable Account'),
                        initialValue: data['payable_account'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => accountListScreen(
                                      filters: {"filter1": "Payable"})));
                          return res['name'];
                        }),
                    CustomTextField('project', 'Project'.tr(),
                        initialValue: data['project'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => projectScreen()))),
                    CustomTextField('cost_center', 'Cost Center',
                        disableValidation: true,
                        clearButton: true,
                        initialValue: data['cost_center'] ?? '',
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => costCenterScreen()))),
                  ],
                )),
                SelectedExpensesList(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
