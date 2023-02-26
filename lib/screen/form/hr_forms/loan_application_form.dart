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

    _formKey.currentState!.save();

    final server = APIService();
    final provider = context.read<ModuleProvider>();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Loan Application');

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(LOAN_APPLICATION_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null &&
        res['message']['loan_application_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['loan_application_data_name']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
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
              ? Text("Edit Loan Application".tr())
              : Text("Create Loan Application".tr()),
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
                      SizedBox(height: 8),
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
                        CustomTextField(
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
                        CustomTextField(
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
                        CustomTextField(
                          'applicant_name',
                          'Applicant Name'.tr(),
                          initialValue: data['applicant_name'],
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

                      CustomDropDown('status', 'Status'.tr(),
                          items: loanApplicationStatus,
                          defaultValue:
                              data['status'] ?? loanApplicationStatus[0],
                          onChanged: (value) => setState(() {
                                data['status'] = value;
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
                    SizedBox(height: 8),

                    // Loan Type
                    CustomTextField('loan_type', tr('Loan Type'),
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

                    CustomTextField(
                      'loan_amount',
                      'Loan Amount'.tr(),
                      initialValue: (data['loan_amount'] ?? "").toString(),
                      keyboardType: TextInputType.number,
                      disableError: true,
                      onChanged: (value) => data['loan_amount'] = value,
                      onSave: (key, value) => data[key] = value,
                      validator: (value) =>
                          numberValidationToast(value, 'Loan Amount'),
                    ),

                    // CheckBoxWidget('is_secured_loan', ' Is Secured Loan',
                    //     initialValue:
                    //         data['is_secured_loan'] == 1 ? true : false,
                    //     onChanged: (id, value) => setState(() {
                    //           data[id] = value ? 1 : 0;
                    //         })),

                    CustomTextField(
                      'rate_of_interest',
                      'Rate of Interest'.tr(),
                      initialValue:
                          (data['rate_of_interest'] ?? "- ").toString() + " %",
                      enabled: false,
                    ),

                    CustomTextField(
                      'description',
                      tr('Reason'),
                      onChanged: (value) => data['description'] = value,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      initialValue: data['description'],
                    ),

                    SizedBox(height: 8),
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
