import '../../../models/page_models/selling_page_model/sales_order_model.dart';
import '../../../service/service.dart';
import '../../../service/service_constants.dart';
import '../../../provider/module/module_provider.dart';
import '../../../provider/user/user_provider.dart';
import '../../list/otherLists.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/inherited_widgets/select_items_list.dart';
import '../../../widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../../core/constants.dart';

import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/buying_page_model/purchase_order_page_model.dart';
import '../../../models/page_models/hr_page_model/leave_application_page_model.dart';
import '../../../models/page_models/model_functions.dart';
import '../../../service/gps_services.dart';
import '../../page/generic_page.dart';

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

  LatLng location = LatLng(0.0, 0.0);
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


    if(location == LatLng(0.0, 0.0)

    ) {
      showSnackBar(
          KEnableGpsSnackBar,
          context)  ;
      Future.delayed(Duration(seconds: 1), () async{

        location = await gpsService.getCurrentLocation(context);

      });
      return;
    }

    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Employee Checkin');

    final server = APIService();

    if (!context.read<ModuleProvider>().isEditing){
      data['latitude'] = location.latitude;
      data['longitude'] = location.longitude;
      data['location'] = gpsService.placemarks[0].subAdministrativeArea;
    }

    data['time'] = data['date_only'] + " " + data['time_only'];

    data.removeWhere((key, value) => key == "time_only");
    data.removeWhere((key, value) => key == "date_only");

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(EMPLOYEE_CHECKIN_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null &&
        res['message']['employee_checkin_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['employee_checkin_data_name']);
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
    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;

        data['latitude'] = 0.0;
        data['longitude'] = 0.0;

        data['time_only'] = data['time'].toString().split(" ")[1];
        data['date_only'] = data['time'].toString().split(" ")[0];
        setState(() {});
      });
  }

  @override
  void didChangeDependencies()  {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async{
      location = await gpsService.getCurrentLocation(context);
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
      child: DismissKeyboard(
        child: Scaffold(
          appBar: AppBar(
            title: (context.read<ModuleProvider>().isEditing)
                ? Text("Edit Employee Checkin")
                : Text("Create Employee Checkin"),
            actions: [
              Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                    onPressed: submit,
                    icon: Icon(
                      Icons.check,
                      color: FORM_SUBMIT_BTN_COLOR,
                    ),
                  ))
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            
            
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Group(
                    child: Column(
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
                                data['name'] = res['name'];
                                data['employee'] = res['name'];
                                data['employee_name'] = res['employee_name'];
                              });
                            }
                            return id;
                          },
                        ),
                        Row(children: [
                          Flexible(
                              child: DatePicker(
                            'date_only',
                            'Date',
                            onChanged: (value) {
                              //value shap: (2022-09-25T00:00:00.000)
                              setState(() {
                                data['date_only'] = value.split("T")[0];
                              });
                            },
                            initialValue: data['time'], //"2022-09-21 10:01:26",
                          )),
                          SizedBox(width: 10),
                          Flexible(
                              child: TimePicker(
                            'time',
                            'Time'.tr(),
                            initialValue: data['time'],
                            onChanged: (value) {
                              //value on that shap: (10:01:00)
                              setState(() {
                                data['time_only'] = value;
                              });
                            },
                          )),
                        ]),
                        // if (data['employee_name'] != null)
                        //   CustomTextField(
                        //     'employee_name',
                        //     'Employee Name',
                        //     initialValue: data['employee_name'],
                        //     enabled: false,
                        //   ),
                        //
                        CustomDropDown('log_type', 'Log Type'.tr(),
                            items: logType,
                            defaultValue: data['status'] ?? logType[0],
                            onChanged: (value) => setState(() {
                                  data['log_type'] = value;
                                })),
                        Divider(color: Colors.grey, height: 1, thickness: 0.7),
                        if (data['leaver_approver'] != null)
                          CustomTextField(
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

                        SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(Icons.warning_amber,color: Colors.amber,size: 22),
                            ),
                            Flexible(
                                child: Text(KLocationNotifySnackBar,textAlign: TextAlign.start,)),
                          ],
                        ),

                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
