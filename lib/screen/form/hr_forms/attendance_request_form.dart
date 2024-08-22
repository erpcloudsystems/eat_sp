import 'dart:developer';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../service/gps_services.dart';
import '../../../widgets/form_widgets.dart';
import '../../../service/service_constants.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/dialog/loading_dialog.dart';

class AttendanceRequestForm extends StatefulWidget {
  const AttendanceRequestForm({super.key});

  @override
  _AttendanceRequestFormState createState() => _AttendanceRequestFormState();
}

class _AttendanceRequestFormState extends State<AttendanceRequestForm> {
  Map<String, dynamic> data = {
    "doctype": "Attendance Request",
    "reason": "Work From Home",
    'half_day': 0,
    "from_date": DateTime.now().toIso8601String(),
    "to_date": DateTime.now().toIso8601String(),
    "to_time": DateTime.now().toString(),
    "from_time": DateTime.now().toString(),
    "latitude": 0.0,
    "longitude": 0.0,
  };

  Map<String, dynamic> selectedEmployeeData = {
    'name': 'noName',
  };
  final _formKey = GlobalKey<FormState>();

  LatLng location = const LatLng(0.0, 0.0);
  GPSService gpsService = GPSService();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    if (location == const LatLng(0.0, 0.0)) {
      showSnackBar(KEnableGpsSnackBar, context);
      Future.delayed(const Duration(seconds: 1), () async {
        location = await gpsService.getCurrentLocation(context);
      });
      return;
    }

    data['latitude'] = location.latitude;
    data['longitude'] = location.longitude;

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeAmendingFunction(context, data);

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Attendance Request');

    final server = APIService();

    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(ATTENDANCE_REQUEST_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null &&
        res['message']['attendance_request_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['attendance_request_data_name']);
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
    Future.delayed(const Duration(seconds: 1),
        () async => location = await gpsService.getCurrentLocation(context));
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data['latitude'] = location.latitude;
        data['longitude'] = location.longitude;
        // if (provider.isEditing) {
        //   data['location'] = gpsService.getCurrentLocation(context);
        // }
        data = context.read<ModuleProvider>().updateData;
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }

        if (provider.isAmendingMode) {
          data.remove('amended_to');
          data['docstatus'] = 0;
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
                              data['employee_name'] = value['employee_name'];
                              data['company'] = value['company'];
                              data['department'] = value['department'];
                            });
                          }
                        }),
                    if (data['employee_name'] != null)
                      CustomTextFieldTest(
                        'employee_name',
                        'Employee Name',
                        initialValue: data['employee_name'],
                        disableValidation: true,
                        enabled: false,
                      ),
                    if (data['department'] != null)
                      CustomTextFieldTest(
                        'department',
                        'Department',
                        initialValue: data['department'],
                        disableValidation: true,
                        enabled: false,
                      ),
                    Row(children: [
                      Flexible(
                          child: DatePickerTest('from_date', 'From Date'.tr(),
                              initialValue: data['from_date'],
                              enable: false, onChanged: (value) {
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
                        enable: false,
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
                    Row(children: [
                      Flexible(
                        child: TimePickerTest(
                          'from_time',
                          'From Time',
                          initialValue: data['from_time'],
                          enable: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TimePickerTest(
                          'to_time',
                          'To Time',
                          initialValue: data['to_time'],
                          enable: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ]),
                    const SizedBox(height: 8),
                    CheckBoxWidget('half_day', 'Half Day',
                        initialValue: data['half_day'] == 1 ? true : false,
                        onChanged: (id, value) => setState(() {
                              data[id] = value ? 1 : 0;
                              data["half_day_date"] = DateTime.now().toString();
                            })),
                    if (data['half_day'] == 1)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                              child: DatePickerTest(
                            'half_day_date',
                            'Half Day Date'.tr(),
                            initialValue: data['half_day_date'],
                            onChanged: (value) =>
                                setState(() => data['half_day_date'] = value),
                            firstDate:
                                DateTime.tryParse(data['from_date'] ?? ''),
                            lastDate: DateTime.tryParse(data['to_date'] ?? ''),
                            clear: true,
                          )),
                        ],
                      ),
                    CustomDropDown('reason', 'Reason'.tr(),
                        items: attendanceRequestReason,
                        defaultValue:
                            data['reason'] ?? attendanceRequestReason[0],
                        onChanged: (value) => setState(() {
                              data['reason'] = value;
                            })),
                    CustomTextFieldTest(
                      'explanation',
                      'Explanation',
                      initialValue: data['explanation'],
                      disableValidation: true,
                      onSave: (key, value) => data[key] = value,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(Icons.warning_amber,
                              color: Colors.amber, size: 22),
                        ),
                        Flexible(
                            child: Text(
                          KLocationNotifySnackBar,
                          textAlign: TextAlign.start,
                        )),
                      ],
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
