import '../../../models/page_models/model_functions.dart';
import '../../../service/service.dart';
import '../../../service/service_constants.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';

import '../../list/otherLists.dart';
import '../../page/generic_page.dart';

class EmployeeAdvanceForm extends StatefulWidget {
  const EmployeeAdvanceForm({Key? key}) : super(key: key);

  @override
  _EmployeeAdvanceFormState createState() => _EmployeeAdvanceFormState();
}

class _EmployeeAdvanceFormState extends State<EmployeeAdvanceForm> {
  Map<String, dynamic> data = {
    "doctype": "Employee Advance",
    "posting_date": DateTime.now().toIso8601String(),
    "exchange_rate": 1,
    "status": "Draft",
  };

  Map<String, dynamic> selectedEmployeeData = {
    'name': 'noName',
  };
  final _formKey = GlobalKey<FormState>();

  // any widgets below this condition will not be shown
  bool removeWhenUpdate = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Employee Advance');

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(EMPLOYEE_ADVANCE_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null &&
        res['message']['employee_advance_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['employee_advance_data_name']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  Future<void> _getEmployeeData(String employee) async {
    selectedEmployeeData = Map<String, dynamic>.from(
        await APIService().getPage(EMPLOYEE_PAGE, employee))['message'];

    data['pending_amount'] = Map<String, dynamic>.from(
        await APIService().genericGet(GET_PENDING_AMOUNT, {
      "employee": selectedEmployeeData['name'],
      "posting_date": data['posting_date'].toString().split(".")[0],
    }))['message'];
    print('sdfsfds234${data['pending_amount']}');
  }

  @override
  void initState() {
    super.initState();

    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        for (var k in data.keys) print("➡️ $k: ${data[k]}");

        setState(() {});
      });
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
      child: Scaffold(
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Employee Advance".tr())
              : Text("Create Employee Advance".tr()),
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
                Group(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 4),
                      CustomTextField(
                        'employee',
                        'Employee',
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
                              data['currency'] = res['currency'];
                              data['advance_account'] = res['advance_account'];
                            });
                          }
                          return id;
                        },
                      ),
                      if (data['employee_name'] != null)
                        CustomTextField(
                          'employee_name',
                          'Employee Name',
                          initialValue: data['employee_name'],
                          enabled: false,
                        ),
                      if (data['department'] != null)
                        CustomTextField(
                          'department',
                          'Department',
                          initialValue: data['department'],
                          enabled: false,
                        ),
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
                      if (data['currency'] != null)
                        CustomTextField(
                          'currency',
                          'Currency',
                          initialValue: data['currency'],
                          enabled: false,
                        ),
                      ////// This is Hidden in docs
                      // if (data['exchange_rate'] != null)
                      //   CustomTextField(
                      //     'exchange_rate',
                      //     'Exchange Rate',
                      //     initialValue: data['exchange_rate'],
                      //     enabled: false,
                      //   ),
                      //
                      CheckBoxWidget('repay_unclaimed_amount_from_salary',
                          'Repay Unclaimed Amount from Salary',
                          initialValue:
                              data['repay_unclaimed_amount_from_salary'] == 1
                                  ? true
                                  : false,
                          onChanged: (id, value) => setState(() {
                                data[id] = value ? 1 : 0;
                              })),

                      SizedBox(height: 8),
                    ],
                  ),
                ),

                ///
                /// group 2
                ///
                Group(
                    child: Column(
                  children: [
                    //if (data['pending_amount'] != null)
                    CustomTextField(
                      'pending_amount',
                      'Pending Amount',
                      initialValue:
                          currency((data['pending_amount'] ?? 0.0).toDouble()),
                      enabled: false,
                    ),
                    NumberTextField(
                      'advance_amount',
                      'Advance Amount',
                      initialValue: data['advance_amount'],
                      keyboardType: TextInputType.number,
                      disableError: true,
                      onChanged: (value) => data['advance_amount'] = value,
                      onSave: (key, value) => data[key] = value,
                      validator: (value) =>
                          numberValidationToast(value, 'Advance Amount'),
                    ),
                    CustomTextField(
                      'purpose',
                      tr('Purpose'),
                      onChanged: (value) => data['purpose'] = value,
                      onSave: (key, value) => data[key] = value,
                      initialValue: data['purpose'],
                    ),

                    if (data['status'] != null)
                      CustomTextField(
                        'status',
                        'Status',
                        initialValue: data['status'],
                        enabled: false,
                      ),

                    CustomTextField('advance_account', tr('Advance Account'),
                        initialValue: data['advance_account'],
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          var res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => accountListScreen()));
                          return res['parent_account'];
                        }),

                    CustomTextField('company', tr('Company'),
                        initialValue: data['company'],
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => companyListScreen()));
                          print('eee3333 $res');

                          return res['name'];
                        }),

                    CustomTextField('mode_of_payment', tr('Mode of Payment'),
                        initialValue: data['mode_of_payment'],
                        clearButton: true,
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => modeOfPaymentScreen()))),
                  ],
                )),

                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
