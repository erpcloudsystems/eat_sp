import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../service/gps_services.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

const List<String> logType = [
  'IN',
  'OUT',
];

class EmployeeCheckinFrom extends StatefulWidget {
  const EmployeeCheckinFrom({Key? key}) : super(key: key);

  @override
  _EmployeeCheckinFromState createState() => _EmployeeCheckinFromState();
}

class _EmployeeCheckinFromState extends State<EmployeeCheckinFrom> {
  Map<String, dynamic> data = {
    "doctype": "Employee Checkin",
    "time": DateTime.now().toString().split(".")[0],
    "skip_auto_attendance": 0,
    "log_type": "IN",
    "time_only": DateTime.now().toIso8601String().split("T")[1],
    "date_only": DateTime.now().toIso8601String().split("T")[0],
    "latitude": 0.0,
    "longitude": 0.0,
  };

  LatLng location = const LatLng(0.0, 0.0);
  GPSService gpsService = GPSService();

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

    if (location == const LatLng(0.0, 0.0)) {
      showSnackBar(KEnableGpsSnackBar, context);
      Future.delayed(const Duration(seconds: 1), () async {
        location = await gpsService.getCurrentLocation(context);
      });
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Employee Checkin');

    final server = APIService();

    if (!context.read<ModuleProvider>().isEditing) {
      data['latitude'] = location.longitude;
      data['longitude'] = location.latitude;
      data['location'] = gpsService.placeman[0].subAdministrativeArea;
    }

    data['time'] = data['date_only'] + " " + data['time_only'];

    data.removeWhere((key, value) => key == "time_only");
    data.removeWhere((key, value) => key == "date_only");

    for (var k in data.keys) {
      print("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(EMPLOYEE_CHECKIN_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (res != null &&
        res['message']['employee_checkin_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['employee_checkin_data_name']);
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
        data = provider.updateData;

        data['latitude'] = 0.0;
        data['longitude'] = 0.0;

        data['time_only'] = data['time'].toString().split(" ")[1];
        data['date_only'] = data['time'].toString().split(" ")[0];
        setState(() {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      location = await gpsService.getCurrentLocation(context);
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
            return Future.value(true);
          } else {
            return Future.value(false);
          }
        }
        return Future.value(false);
      },
      child: DismissKeyboard(
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
                          keys: const {
                            'subTitle': 'employee_name',
                            'trailing': 'department',
                          },
                          nameResponse: 'name',
                          title: 'Employee'.tr(),
                          onChange: (value) async {
                            if (value != null) {
                              await _getEmployeeData(value['name']);
                              setState(() {
                                data['name'] = value['name'];
                                data['employee'] = value['name'];
                                data['employee_name'] = value['employee_name'];
                              });
                            }
                          }),
                      Row(children: [
                        Flexible(
                            child: DatePickerTest(
                          'date_only',
                          'Date',
                          enable: false,
                          onChanged: (value) {
                            setState(() {
                              data['date_only'] = value.split("T")[0];
                            });
                          },
                          initialValue: data['time'], //"2022-09-21 10:01:26",
                        )),
                        const SizedBox(width: 10),
                        Flexible(
                            child: TimePickerTest(
                          'time',
                          'Time'.tr(),
                          enable: false,
                          initialValue: data['time'],
                          onChanged: (value) {
                            setState(() {
                              data['time_only'] = value;
                            });
                          },
                        )),
                      ]),
                      CustomDropDown(
                        'log_type',
                        'Log Type'.tr(),
                        items: logType,
                        defaultValue: data['log_type'] ?? logType[0],
                        onChanged: (value) => setState(
                          () {
                            data['log_type'] = value;
                          },
                        ),
                      ),
                      const Divider(
                          color: Colors.grey, height: 1, thickness: 0.7),
                      if (data['leaver_approver'] != null)
                        CustomTextFieldTest(
                          'device_id',
                          'Location / Device ID',
                          initialValue: data['device_id'],
                          disableValidation: true,
                          onSave: (key, value) => data[key] = value,
                        ),
                      CheckBoxWidget(
                          'skip_auto_attendance', 'Skip Auto Attendance',
                          initialValue:
                              data['skip_auto_attendance'] == 1 ? true : false,
                          onChanged: (id, value) =>
                              setState(() => data[id] = value ? 1 : 0)),
                      const SizedBox(height: 8),
                       Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
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
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
