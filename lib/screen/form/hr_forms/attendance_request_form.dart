import 'package:next_app/models/page_models/selling_page_model/sales_order_model.dart';
import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/screen/list/otherLists.dart';
import 'package:next_app/widgets/dialog/loading_dialog.dart';
import 'package:next_app/widgets/form_widgets.dart';
import 'package:next_app/widgets/inherited_widgets/select_items_list.dart';
import 'package:next_app/widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';


import '../../../models/list_models/stock_list_model/item_table_model.dart';
import '../../../models/page_models/buying_page_model/purchase_order_page_model.dart';
import '../../../models/page_models/hr_page_model/leave_application_page_model.dart';
import '../../../models/page_models/model_functions.dart';
import '../../page/generic_page.dart';

class AttendanceRequestForm extends StatefulWidget {
  const AttendanceRequestForm({Key? key}) : super(key: key);

  @override
  _AttendanceRequestFormState createState() => _AttendanceRequestFormState();
}

class _AttendanceRequestFormState extends State<AttendanceRequestForm> {
  Map<String, dynamic> data = {
    "doctype": "Attendance Request",
    "reason": "Work From Home",
    'half_day': 0,
  };

  Map<String, dynamic> selectedEmployeeData = {
    'name': 'noName',
  };
  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar('Fill required fields', context);
      return;
    }

    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Attendance Request');

    final server = APIService();

    for (var k in data.keys) print("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(ATTENDANCE_REQUEST_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (res != null &&
        res['message']['attendance_request_data_name'] != null) {
      context
          .read<ModuleProvider>()
          .pushPage(res['message']['attendance_request_data_name']);
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
              ? Text("Edit Attendance Request")
              : Text("Create Attendance Request"),
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
                              data['company'] = res['company'];
                              data['department'] = res['department'];
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
                          disableValidation: true,
                          enabled: false,
                        ),
                      if (data['department'] != null)
                        CustomTextField(
                          'department',
                          'Department',
                          initialValue: data['department'],
                          disableValidation: true,
                          enabled: false,
                        ),
                      CustomTextField('company', tr('Company'),
                          initialValue: data['company'],
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () async{
                        final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => companyListScreen()));
                        return res['name'];
                          }

                      ),

                      Row(children: [
                        Flexible(
                            child: DatePicker('from_date', 'From Date'.tr(),
                                initialValue: data['from_date'],
                                onChanged: (value) {
                          setState(() => data['from_date'] = value);
                          if (data['half_day_date'] != null){
                            data.remove('half_day_date');
                          }
                          if (data['from_date'] == data['to_date']) {
                            data['half_day_date'] = data['from_date'];
                          }
                        })),
                        SizedBox(width: 10),
                        Flexible(
                            child: DatePicker(
                          'to_date',
                          'To Date'.tr(),
                          initialValue: data['to_date'],
                          onChanged: (value) {
                            setState(() => data['to_date'] = value);
                            if (data['half_day_date'] != null){
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
                        SizedBox(width: 10),
                      ]),
                      SizedBox(height: 8),

                      CheckBoxWidget('half_day', 'Half Day',
                          initialValue: data['half_day'] == 1 ? true : false,
                          onChanged: (id, value) => setState(() {
                                data[id] = value ? 1 : 0;
                              })),
                      if (data['half_day'] == 1)
                        Row(
                          children: [
                            Flexible(
                                child: DatePicker(
                              'half_day_date',
                              'Half Day Date'.tr(),
                              initialValue:
                                  (data['from_date'] == data['to_date'])
                                      ? data['from_date']
                                      : data['half_day_date'],
                              onChanged: (value) =>
                                  setState(() => data['half_day_date'] = value),
                              firstDate:
                                  DateTime.tryParse(data['from_date'] ?? ''),
                              lastDate:
                                  DateTime.tryParse(data['to_date'] ?? ''),
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

                      CustomTextField(
                        'explanation',
                        'Explanation',
                        initialValue: data['explanation'],
                        disableValidation: true,
                        onSave: (key, value) => data[key] = value,
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
    );
  }
}
