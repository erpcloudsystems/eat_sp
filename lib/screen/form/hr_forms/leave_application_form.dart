import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../test/custom_page_view_form.dart';
import '../../../test/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class LeaveApplicationForm extends StatefulWidget {
  const LeaveApplicationForm({Key? key}) : super(key: key);

  @override
  _LeaveApplicationFormState createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  Map<String, dynamic> data = {
    "doctype": "Leave Application",
    "posting_date": DateTime.now().toIso8601String(),
    'status': 'Open',
    'half_day': 0,
  };

  Map<String, dynamic> selectedEmployeeData = {
    'name': 'noName',
  };
  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    data['docstatus'] = 0;
    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Leave Application');

    final server = APIService();

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(LEAVE_APPLICATION_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null &&
        res['message']['leave_application_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['leave_application_name']);
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

    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }

        if (provider.isAmendingMode) {
          data.remove('amended_to');
          data['docstatus'] = 0;
          // data.remove('docstatus');
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
                    const SizedBox(height: 4),
                    CustomTextFieldTest(
                      'employee',
                      'Employee',
                      initialValue: data['employee'],
                      onPressed: () async {
                        String? id;
                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => selectEmployeeScreen()));
                        if (res != null) {
                          id = res['name'];
                          await _getEmployeeData(res['name']);

                          setState(() {
                            data['name'] = res['name'];
                            data['employee'] = res['name'];
                            data['employee_name'] = res['employee_name'];
                            data['department'] = res['department'];
                            data['leaver_approver'] =
                                selectedEmployeeData['leave_approver'];
                            data['leave_approver_name'] =
                                selectedEmployeeData['leave_approver_name'];
                          });
                        }
                        return id;
                      },
                    ),
                    if (data['employee_name'] != null)
                      CustomTextFieldTest(
                        'employee_name',
                        'Employee Name',
                        initialValue: data['employee_name'],
                        enabled: false,
                      ),
                    if (data['department'] != null)
                      CustomTextFieldTest(
                        'department',
                        'Department',
                        initialValue: data['department'],
                        enabled: false,
                      ),
                    CustomTextFieldTest(
                      'leave_type',
                      'Leave Type',
                      initialValue: data['leave_type'],
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => leaveTypeListScreen()));
                        if (res != null) data['leave_type'] = res;
                        return res;
                      },
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
                      // Flexible(
                      //     child: DatePicker(
                      //       'schedule_date',
                      //       'Required By Date',
                      //       onChanged: (value)  => setState(() => data['schedule_date'] = value),
                      //       initialValue: data['schedule_date'] ??
                      //           ((selectedSupplierData['name'].toString() !=
                      //               'noName')?
                      //           DateTime.now()
                      //               .add(Duration(
                      //               days: int.parse(selectedSupplierData["credit_days"].toString())))
                      //               .toIso8601String():null),
                      //     )),
                    ]),

                    CustomDropDown(
                      'status',
                      'Status    '.tr(),
                      items: leaveApplicationStatus,
                      defaultValue: data['status'] ?? leaveApplicationStatus[0],
                      onChanged: (value) => setState(
                        () {
                          data['status'] = value;
                        },
                      ),
                    ),
                    const Divider(
                        color: Colors.grey, height: 1, thickness: 0.7),
                    if (data['leaver_approver'] != null)
                      CustomTextFieldTest(
                        'leaver_approver',
                        'Leave Approver',
                        initialValue: data['leaver_approver'],
                        disableValidation: false,
                        clearButton: false,
                        enabled: false,
                      ),
                    if (data['leave_approver_name'] != null)
                      CustomTextFieldTest(
                        'leave_approver_name',
                        'Leave Approver Name',
                        initialValue: data['leave_approver_name'],
                        disableValidation: false,
                        clearButton: false,
                        enabled: false,
                      ),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest('from_date', 'From Date'.tr(),
                              initialValue: data['from_date'],
                              onChanged: (value) {
                        setState(() => data['from_date'] = value);
                        if (data['half_day_date'] != null) {
                          data.remove('half_day_date');
                        }
                        if (data['from_date'] == data['to_date']) {
                          data['half_day_date'] = data['from_date'];
                        }
                      })),
                      const SizedBox(width: 10),
                      Flexible(
                          child: DatePickerTest(
                        'to_date',
                        'To Date'.tr(),
                        initialValue: data['to_date'],
                        onChanged: (value) {
                          setState(() => data['to_date'] = value);
                          if (data['half_day_date'] != null) {
                            data.remove('half_day_date');
                          }
                          if (data['from_date'] == data['to_date']) {
                            data['half_day_date'] = data['from_date'];
                          }
                          data['total_leave_days'] =
                              ((DateTime.tryParse(data['to_date'])!
                                              .difference(DateTime.tryParse(
                                                  data['from_date'])!)
                                              .inDays +
                                          1) +
                                      ((data['half_day'] == 0) ? 0 : -0.5))
                                  .toString();
                        },
                      )),
                      const SizedBox(width: 10),
                    ]),
                    const SizedBox(height: 8),

                    // CustomTextField(
                    //   'leave_balance',
                    //   'Leave Balance Before Application',
                    //   initialValue:
                    //       (data['leave_balance'].toString() != 'null')
                    //           ? data['leave_balance'].toString()
                    //           : tr('0'),
                    //   enabled: false,
                    // ),
                    CheckBoxWidget('half_day', 'Half Day',
                        initialValue: data['half_day'] == 1 ? true : false,
                        onChanged: (id, value) => setState(() {
                              data[id] = value ? 1 : 0;
                            })),
                    if (data['from_date'] != null && data['to_date'] != null)
                      CustomTextFieldTest(
                        'total_leave_days',
                        'Total Leave Days',
                        initialValue: ((DateTime.tryParse(data['to_date'])!
                                        .difference(DateTime.tryParse(
                                            data['from_date'])!)
                                        .inDays +
                                    1) +
                                ((data['half_day'] == 0) ? 0 : -0.5))
                            .toString(),

                        // data['from_date'].difference(data['to_date']).inHours,
                        enabled: false,
                      ),
                    if (data['half_day'] == 1)
                      Row(
                        children: [
                          Flexible(
                              child: DatePickerTest(
                            'half_day_date',
                            'Half Day Date'.tr(),
                            initialValue: (data['from_date'] == data['to_date'])
                                ? data['from_date']
                                : data['half_day_date'],
                            onChanged: (value) =>
                                setState(() => data['half_day_date'] = value),
                            firstDate:
                                DateTime.tryParse(data['from_date'] ?? ''),
                            lastDate: DateTime.tryParse(data['to_date'] ?? ''),
                            clear: true,
                          )),
                        ],
                      ),

                    CustomTextFieldTest(
                      'description',
                      'Reason',
                      initialValue: data['description'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                    ),

                    const SizedBox(height: 8),
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
