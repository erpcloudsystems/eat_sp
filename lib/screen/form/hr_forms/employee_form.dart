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
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({Key? key}) : super(key: key);

  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  Map<String, dynamic> data = {
    "doctype": "Employee",
    //  "date_of_birth": DateTime.now().toIso8601String(),
    // "date_of_joining": DateTime.now().toIso8601String(),
  };

  Map<String, dynamic> selectedEmployeeData = {
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

    data['full_name'] = data['first_name'] + " " + data['last_name'];

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Adding new Employee');

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(EMPLOYEE_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null && res['message']['employee_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['employee_data_name']);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GenericPage()));
    }
  }

  Future<void> _getEmployeeData(String employee) async {
    selectedEmployeeData = Map<String, dynamic>.from(
        await APIService().getPage(EMPLOYEE_PAGE, employee))['message'];
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();
    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }
        // _getEmployeeData(data['name']).then((value) {
        //   data['company'] = selectedEmployeeData['defaultCompany'];
        // });
        data['company_email'] = data['emails']['company_email'];
        data['personal_email'] = data['emails']['personal_email'];
        data['prefered_email'] = data['emails']['prefered_email'];

        data['current_address'] = data['address']['current_address'];
        data['permanent_address'] = data['address']['permanent_address'];

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
        bool? isGoBack = await checkDialog(context, 'Discard your data?');

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
                    CustomTextFieldTest(
                      'first_name',
                      tr('First Name'),
                      clearButton: true,
                      onChanged: (value) => data['first_name'] = value,
                      onSave: (key, value) => data[key] = value,
                      initialValue: data['first_name'],
                    ),
                    CustomTextFieldTest(
                      'last_name',
                      tr('Last Name'),
                      clearButton: true,
                      disableValidation: true,
                      onChanged: (value) => data['last_name'] = value,
                      onSave: (key, value) => data[key] = value,
                      initialValue: data['last_name'],
                    ),
                    CustomDropDownFromField(
                        defaultValue: data['gender'],
                        docType: APIService.GENDER,
                        nameResponse: 'name',
                        title: tr('Gender'),
                        onChange: (value) {
                          setState(() {
                            data['gender'] = value['name'];
                          });
                        }),
                    Row(
                      children: [
                        Flexible(
                            child: DatePickerTest(
                          'date_of_birth',
                          'Date of Birth'.tr(),
                          initialValue: data['date_of_birth'],
                          onChanged: (value) =>
                              setState(() => data['date_of_birth'] = value),
                          firstDate: DateTime(DateTime.now().year - 100),
                        )),
                        const SizedBox(width: 10),
                      ],
                    ),
                    CustomDropDown(
                      'status',
                      'Status'.tr(),
                      items: employeeStatus,
                      onChanged: (value) => setState(() {
                        data['status'] = value;
                      }),
                      defaultValue: data['status'] ?? employeeStatus[0],
                    ),
                    const SizedBox(height: 4),
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
                    CustomDropDownFromField(
                        defaultValue: data['department'],
                        isValidate: false,
                        docType: APIService.DEPARTMENT,
                        nameResponse: 'name',
                        title: tr('Department'),
                        onChange: (value) {
                          setState(() {
                            data['department'] = value['name'];
                          });
                        }),
                    CustomDropDownFromField(
                        defaultValue: data['designation'],
                        isValidate: false,
                        docType: APIService.DESIGNATION,
                        nameResponse: 'name',
                        title: tr('Designation'),
                        onChange: (value) {
                          setState(() {
                            data['designation'] = value['name'];
                          });
                        }),
                    CustomDropDownFromField(
                        defaultValue: data['branch'],
                        isValidate: false,
                        docType: APIService.BRANCH,
                        nameResponse: 'name',
                        title: tr('Branch'),
                        onChange: (value) {
                          setState(() {
                            data['branch'] = value['name'];
                          });
                        }),
                    CustomDropDownFromField(
                        defaultValue: data['employment_type'],
                        isValidate: false,
                        docType: APIService.EMPLOYMENT_TYPE,
                        nameResponse: 'name',
                        title: tr('Employment Type'),
                        onChange: (value) {
                          setState(() {
                            data['employment_type'] = value['name'];
                          });
                        }),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest(
                        'date_of_joining',
                        'Date of Joining'.tr(),
                        disableValidation: false,
                        initialValue: data['date_of_joining'],
                        onChanged: (value) =>
                            setState(() => data['date_of_joining'] = value),
                      )),
                      const SizedBox(width: 10),
                    ]),
                    CustomDropDownFromField(
                        defaultValue: data['leave_approver'],
                        isValidate: false,
                        docType: APIService.LEAVE_APPROVER,
                        nameResponse: 'name',
                        title: tr('Leave Approver'),
                        onChange: (value) {
                          setState(() {
                            data['leave_approver'] = value['name'];
                          });
                        }),
                    CustomDropDownFromField(
                        defaultValue: data['expense_approver'],
                        isValidate: false,
                        docType: APIService.LEAVE_APPROVER,
                        nameResponse: 'name',
                        title: tr('Expense Approver'),
                        onChange: (value) {
                          setState(() {
                            data['expense_approver'] = value['name'];
                          });
                        }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              Group(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    CustomTextFieldTest('cell_number', tr('Phone Number'),
                        clearButton: true,
                        disableValidation: true,
                        initialValue: data['cell_number'],
                        keyboardType: TextInputType.phone,
                        validator: validateMobile,
                        onChanged: (value) => data['cell_number'] = value,
                        onSave: (key, value) => data[key] = value),
                    CustomTextFieldTest('company_email', tr('Company Email'),
                        clearButton: true,
                        disableValidation: true,
                        initialValue: data['company_email'],
                        keyboardType: TextInputType.emailAddress,
                        validator: mailValidation,
                        onChanged: (value) => data['company_email'] = value,
                        onSave: (key, value) => data[key] = value),
                    CustomTextFieldTest('personal_email', tr('Personal Email'),
                        clearButton: true,
                        disableValidation: true,
                        initialValue: data['personal_email'],
                        keyboardType: TextInputType.emailAddress,
                        validator: mailValidation,
                        onChanged: (value) => data['personal_email'] = value,
                        onSave: (key, value) => data[key] = value),
                    if (data['user_id'] != null)
                      CustomTextFieldTest(
                          'prefered_email', tr('Prefered Email'),
                          clearButton: true,
                          disableValidation: true,
                          enabled: false,
                          onSave: (key, value) => data[key] = value,
                          onChanged: (value) => data['prefered_email'] = value,
                          initialValue: data['prefered_email'] ??
                              selectedEmployeeData['prefered_email']),
                    CustomTextFieldTest(
                        'current_address', tr('Current Address'),
                        clearButton: true,
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => data['current_address'] = value,
                        initialValue: data['current_address']),
                    CustomTextFieldTest(
                        'permanent_address', tr('Permanent Address'),
                        clearButton: true,
                        disableValidation: true,
                        onChanged: (value) => data['permanent_address'] = value,
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['permanent_address']),
                    CustomDropDownFromField(
                        defaultValue: data['user_id'],
                        isValidate: false,
                        docType: APIService.LEAVE_APPROVER,
                        nameResponse: 'name',
                        title: tr('ERPNext User'),
                        onChange: (value) {
                          setState(() {
                            data['user_id'] = value['name'];
                            data['prefered_email'] = value['name'];
                          });
                        }),
                    CustomTextFieldTest(
                      'attendance_device_id',
                      'Attendance Device ID (Biometric/RF tag ID)'.tr(),
                      clearButton: true,
                      disableValidation: true,
                      initialValue: data['attendance_device_id'],
                      keyboardType: TextInputType.number,
                      disableError: true,
                      onChanged: (value) =>
                          data['attendance_device_id'] = value,
                      onSave: (key, value) => data[key] = value,
                      validator: (value) => numberValidationToast(
                          value, 'Attendance Device ID (Biometric/RF tag ID)'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              Group(
                  child: ListView(
                children: [
                  const SizedBox(height: 8),
                  CustomDropDownFromField(
                      defaultValue: data['holiday_list'],
                      isValidate: false,
                      docType: APIService.HOLIDAY_LIST,
                      nameResponse: 'name',
                      title: tr('Holiday List'),
                      onChange: (value) {
                        setState(() {
                          data['holiday_list'] = value['name'];
                        });
                      }),
                  CustomDropDownFromField(
                      defaultValue: data['default_shift'],
                      isValidate: false,
                      docType: APIService.DEFAULT_SHIFT,
                      nameResponse: 'name',
                      title: tr('Default Shift '),
                      onChange: (value) {
                        setState(() {
                          data['default_shift'] = value['name'];
                        });
                      }),
                  const SizedBox(height: 8),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
