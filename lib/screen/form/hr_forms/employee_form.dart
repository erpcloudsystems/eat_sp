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
                    CustomTextFieldTest(
                      'gender',
                      tr('Gender'),
                      clearButton: true,
                      initialValue: data['gender'],
                      onSave: (key, value) => setState(() {
                        data['gender'] = value;
                      }),
                      onChanged: (value) => setState(() {
                        data['gender'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => genderListScreen(),
                          ),
                        );
                        data['gender'] = res;
                        return res;
                      },
                    ),
                    Row(children: [
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
                    ]),
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
                    CustomTextFieldTest(
                      'department',
                      tr('Department'),
                      initialValue: data['department'],
                      clearButton: true,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['department'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => departmentListScreen(),
                          ),
                        );
                        data['department'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'designation',
                      tr('Designation'),
                      initialValue: data['designation'],
                      clearButton: true,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['designation'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => designationListScreen(),
                          ),
                        );
                        data['designation'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'branch',
                      tr('Branch'),
                      initialValue: data['branch'],
                      clearButton: true,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['branch'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => branchListScreen(),
                          ),
                        );
                        data['branch'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'employment_type',
                      tr('Employment Type'),
                      initialValue: data['employment_type'],
                      clearButton: true,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => data['employment_type'] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => employmentTypeListScreen(),
                          ),
                        );
                        data['employment_type'] = res;
                        return res;
                      },
                    ),
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
                    CustomTextFieldTest(
                      'leave_approver',
                      tr('Leave Approver'),
                      initialValue: data['leave_approver'],
                      clearButton: true,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onChanged: (value) => setState(() {
                        data['leave_approver'] = value;
                      }),
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => leaveApproverScreen(),
                          ),
                        );
                        data['leave_approver'] = res;
                        return res;
                      },
                    ),
                    CustomTextFieldTest(
                      'expense_approver',
                      tr('Expense Approver'),
                      initialValue: data['expense_approver'],
                      clearButton: true,
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => leaveApproverScreen(),
                          ),
                        );
                        data['expense_approver'] = res;

                        return res;
                      },
                    ),
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
                    CustomTextFieldTest('user_id', tr('ERPNext User'),
                        clearButton: true,
                        disableValidation: true,
                        initialValue: data['user_id'],
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => setState(() {
                              data['user_id'] = value;
                            }),
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => leaveApproverScreen(),
                            ),
                          );
                          if (res != null) {
                            setState(() {
                              data['user_id'] = res;
                              data['prefered_email'] = res;
                            });
                          }
                          return res;
                        }),
                    // CustomTextField('attendance_device_id', tr('Attendance Device ID (Biometric/RF tag ID)'),
                    //     initialValue: data['attendance_device_id'],
                    //     keyboardType: TextInputType.phone,
                    //     validator: validateMobile,
                    //     onSave: (key, value) => data[key] = value),
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
                  CustomTextFieldTest(
                    'holiday_list',
                    tr('Holiday List'),
                    clearButton: true,
                    disableValidation: true,
                    initialValue: data['holiday_list'],
                    onSave: (key, value) => data[key] = value,
                    onChanged: (value) => setState(() {
                      data['holiday_list'] = value;
                    }),
                    onPressed: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => holidayListScreen(),
                        ),
                      );
                      data['holiday_list'] = res;
                      return res;
                    },
                  ),
                  CustomTextFieldTest(
                    'default_shift',
                    tr('Default Shift '),
                    clearButton: true,
                    disableValidation: true,
                    initialValue: data['default_shift'],
                    onSave: (key, value) => data[key] = value,
                    onChanged: (value) => setState(() {
                      data['default_shift'] = value;
                    }),
                    onPressed: () async {
                      final res = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => shiftTypeListScreen(),
                        ),
                      );
                      data['default_shift'] = res;
                      return res;
                    },
                  ),
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
