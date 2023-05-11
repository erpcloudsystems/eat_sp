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

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(EMPLOYEE_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null && res['message']['employee_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['employee_data_name']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
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
    if (provider.isEditing || provider.duplicateMode)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        for (var k in data.keys) log("➡️ $k: ${data[k]}");
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
        appBar: AppBar(
          title: (context.read<ModuleProvider>().isEditing)
              ? Text("Edit Employee".tr())
              : Text("Create Employee".tr()),
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
                      CustomTextField(
                        'first_name',
                        tr('First Name'),
                        clearButton: true,
                        onChanged: (value) => data['first_name'] = value,
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['first_name'],
                      ),
                      CustomTextField(
                        'last_name',
                        tr('Last Name'),
                        clearButton: true,
                        disableValidation: true,
                        onChanged: (value) => data['last_name'] = value,
                        onSave: (key, value) => data[key] = value,
                        initialValue: data['last_name'],
                      ),
                      CustomTextField('gender', tr('Gender'),
                          clearButton: true,
                          initialValue: data['gender'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => genderListScreen()))),
                      Row(children: [
                        Flexible(
                            child: DatePicker(
                          'date_of_birth',
                          'Date of Birth'.tr(),
                          initialValue: data['date_of_birth'],
                          onChanged: (value) =>
                              setState(() => data['date_of_birth'] = value),
                          firstDate: DateTime(DateTime.now().year - 100),
                        )),
                        SizedBox(width: 10),
                      ]),
                      CustomDropDown('status', 'Status'.tr(),
                          items: employeeStatus,
                          defaultValue: data['order_type'] ?? employeeStatus[0],
                          onChanged: (value) => data['order_type'] = value),
                      SizedBox(height: 4),
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
                      CustomTextField('department', tr('Department'),
                          initialValue: data['department'],
                          clearButton: true,
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => departmentListScreen()))),
                      CustomTextField('designation', tr('Designation'),
                          initialValue: data['designation'],
                          clearButton: true,
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => designationListScreen()))),
                      CustomTextField('branch', tr('Branch'),
                          initialValue: data['branch'],
                          clearButton: true,
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => branchListScreen()))),
                      CustomTextField('employment_type', tr('Employment Type'),
                          initialValue: data['employment_type'],
                          clearButton: true,
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => employmentTypeListScreen()))),
                      Row(children: [
                        Flexible(
                            child: DatePicker(
                          'date_of_joining',
                          'Date of Joining'.tr(),
                          disableValidation: false,
                          initialValue: data['date_of_joining'],
                          onChanged: (value) =>
                              setState(() => data['date_of_joining'] = value),
                        )),
                        SizedBox(width: 10),
                      ]),
                      CustomTextField('leave_approver', tr('Leave Approver'),
                          initialValue: data['leave_approver'],
                          clearButton: true,
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => leaveApproverScreen()))),
                      CustomTextField(
                          'expense_approver', tr('Expense Approver'),
                          initialValue: data['expense_approver'],
                          clearButton: true,
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => leaveApproverScreen()))),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                Group(
                  child: Column(
                    children: [
                      SizedBox(height: 8),
                      CustomTextField('cell_number', tr('Phone Number'),
                          clearButton: true,
                          disableValidation: true,
                          initialValue: data['cell_number'],
                          keyboardType: TextInputType.phone,
                          validator: validateMobile,
                          onSave: (key, value) => data[key] = value),
                      CustomTextField('company_email', tr('Company Email'),
                          clearButton: true,
                          disableValidation: true,
                          initialValue: data['company_email'],
                          keyboardType: TextInputType.emailAddress,
                          validator: mailValidation,
                          onSave: (key, value) => data[key] = value),
                      CustomTextField('personal_email', tr('Personal Email'),
                          clearButton: true,
                          disableValidation: true,
                          initialValue: data['personal_email'],
                          keyboardType: TextInputType.emailAddress,
                          validator: mailValidation,
                          onSave: (key, value) => data[key] = value),
                      if (data['user_id'] != null)
                        CustomTextField('prefered_email', tr('Prefered Email'),
                            clearButton: true,
                            disableValidation: true,
                            enabled: false,
                            onSave: (key, value) => data[key] = value,
                            initialValue: data['prefered_email'] ??
                                selectedEmployeeData['prefered_email']),
                      CustomTextField('current_address', tr('Current Address'),
                          clearButton: true,
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['current_address']),
                      CustomTextField(
                          'permanent_address', tr('Permanent Address'),
                          clearButton: true,
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                          initialValue: data['permanent_address']),
                      CustomTextField('user_id', tr('ERPNext User'),
                          clearButton: true,
                          disableValidation: true,
                          initialValue: data['user_id'],
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => leaveApproverScreen()));
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
                      CustomTextField(
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
                        validator: (value) => numberValidationToast(value,
                            'Attendance Device ID (Biometric/RF tag ID)'),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                Group(
                    child: Column(
                  children: [
                    SizedBox(height: 8),
                    CustomTextField('holiday_list', tr('Holiday List'),
                        clearButton: true,
                        disableValidation: true,
                        initialValue: data['holiday_list'],
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => holidayListScreen()))),
                    CustomTextField('default_shift', tr('Default Shift '),
                        clearButton: true,
                        disableValidation: true,
                        initialValue: data['default_shift'],
                        onSave: (key, value) => data[key] = value,
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => shiftTypeListScreen()))),
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
