import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class LoanApplicationForm extends StatefulWidget {
  const LoanApplicationForm({Key? key}) : super(key: key);

  @override
  _LoanApplicationFormState createState() => _LoanApplicationFormState();
}

class _LoanApplicationFormState extends State<LoanApplicationForm> {
  Map<String, dynamic> data = {
    "doctype": "Loan Application",
    "posting_date": DateTime.now().toIso8601String(),
    "applicant_type": "Employee",
    "status": "Open",
    //"loan_amount": "",
  };

  Map<String, dynamic> selectedApplicantData = {
    'name': 'noName',
  };
  final _formKey = GlobalKey<FormState>();

  // any widgets below this condition will not be shown
  bool removeWhenUpdate = true;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Loan Application');

    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(LOAN_APPLICATION_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null &&
        res['message']['loan_application_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['loan_application_data_name']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();
    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }

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
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: CustomPageViewForm(
            submit: () => submit(),
            widgetGroup: [
              Group(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    CustomDropDown('applicant_type', 'Applicant Type'.tr(),
                        items: applicantTypeList,
                        defaultValue:
                            data['applicant_type'] ?? applicantTypeList[0],
                        onChanged: (value) => setState(() {
                              data['applicant'] = null;
                              data['applicant_name'] = null;
                              data['status'] = "Open";
                              // data['loan_type']="";
                              // data['loan_amount']=null;
                              // data['description']=null;
                              data['applicant_type'] = value;
                            })),
                    ////////Employee
                    if (data['applicant_type'] == applicantTypeList[0])
                      CustomTextFieldTest(
                        'applicant',
                        'Applicant'.tr(),
                        initialValue: data['applicant'],
                        onPressed: () async {
                          String? id;
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectEmployeeScreen()));
                          if (res != null) {
                            id = res['name'];
                            //await _getEmployeeData(res['name']);

                            setState(() {
                              data['applicant'] = res['name'];
                              data['applicant_name'] = res['employee_name'];
                            });
                          }
                          return id;
                        },
                      ),

                    ////////Customer
                    if (data['applicant_type'] == applicantTypeList[1])
                      CustomTextFieldTest(
                        'applicant',
                        'Applicant'.tr(),
                        initialValue: data['applicant'],
                        onPressed: () async {
                          String? id;

                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      selectCustomerScreen()));
                          if (res != null) {
                            id = res['name'];

                            setState(() {
                              data['applicant'] = res['name'];
                              data['applicant_name'] = res['customer_name'];
                            });
                          }

                          return id;
                        },
                      ),

                    if (data['applicant_name'] != null)
                      CustomTextFieldTest(
                        'applicant_name',
                        'Applicant Name'.tr(),
                        initialValue: data['applicant_name'],
                        enabled: false,
                      ),

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

                    CustomDropDown('status', 'Status'.tr(),
                        items: loanApplicationStatus,
                        defaultValue:
                            data['status'] ?? loanApplicationStatus[0],
                        onChanged: (value) => setState(() {
                              data['status'] = value;
                            })),

                    const SizedBox(height: 8),
                  ],
                ),
              ),

              ///
              /// group 2
              ///
              Group(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),

                    // Loan Type
                    CustomTextFieldTest('loan_type', tr('Loan Type'),
                        initialValue: data['loan_type'],
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => loanTypeListScreen()));
                          setState(() {
                            data['loan_type'] = res['name'];
                            data['is_term_loan'] = res['is_term_loan'];
                            data['rate_of_interest'] = res['rate_of_interest'];
                          });
                          return res['name'];
                        }),

                    CheckBoxWidget(
                      'is_term_loan',
                      'Is Term Loan'.tr(),
                      enable: false,
                      initialValue: data['is_term_loan'] == 1 ? true : false,
                    ),
                    CustomTextFieldTest(
                      'loan_amount',
                      'Loan Amount'.tr(),
                      initialValue: (data['loan_amount'] ?? '').toString(),
                      keyboardType: TextInputType.number,
                      disableError: true,
                      onChanged: (value) =>
                          data['loan_amount'] = int.parse(value),
                      onSave: (key, value) => data[key] = int.parse(value),
                      validator: (value) =>
                          numberValidationToast(value, 'Loan Amount'),
                    ),
                    if (data['is_term_loan'] == 1)
                      Flexible(
                        child: CustomDropDown(
                          'repayment_method',
                          'Method'.tr(),
                          items: termLoan,
                          defaultValue: data['repayment_method'] ?? termLoan[0],
                          onChanged: (value) => setState(
                            () {
                              data['repayment_method'] = value;
                            },
                          ),
                        ),
                      ),
                    if (data['repayment_method'] == termLoan[1])
                      CustomTextFieldTest(
                        'repayment_amount',
                        'Repayment Amount'.tr(),
                        disableValidation: false,
                        initialValue:
                            (data['repayment_amount'] ?? '').toString(),
                        keyboardType: TextInputType.number,
                        disableError: true,
                        onChanged: (value) =>
                            data['repayment_amount'] = int.parse(value),
                        onSave: (key, value) => data[key] = int.parse(value),
                      ),
                    if (data['repayment_method'] == termLoan[2])
                      CustomTextFieldTest(
                        'repayment_periods',
                        'Repayment Period per Month'.tr(),
                        initialValue:
                            (data['repayment_periods'] ?? '').toString(),
                        keyboardType: TextInputType.number,
                        disableValidation: false,
                        disableError: true,
                        onChanged: (value) =>
                            data['repayment_periods'] = int.parse(value),
                        onSave: (key, value) => data[key] = int.parse(value),
                      ),

                    // CheckBoxWidget('is_secured_loan', ' Is Secured Loan',
                    //     initialValue:
                    //         data['is_secured_loan'] == 1 ? true : false,
                    //     onChanged: (id, value) => setState(() {
                    //           data[id] = value ? 1 : 0;
                    //         })),

                    CustomTextFieldTest(
                      'rate_of_interest',
                      'Rate of Interest'.tr(),
                      initialValue: "${data['rate_of_interest'] ?? "- "} %",
                      enabled: true,
                    ),

                    CustomTextFieldTest(
                      'description',
                      tr('Reason'),
                      onChanged: (value) => data['description'] = value,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      initialValue: data['description'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
