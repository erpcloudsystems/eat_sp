import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/resources/strings_manager.dart';
import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import 'add_time_sheet_dialog.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class TimesheetForm extends StatefulWidget {
  const TimesheetForm({Key? key}) : super(key: key);

  @override
  State<TimesheetForm> createState() => _TimesheetFormState();
}

class _TimesheetFormState extends State<TimesheetForm> {
  final server = APIService();
  Map<String, dynamic> data = {
    "doctype": "Timesheet",
  };

  String? customerName;
  String? projectName;
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
            : 'Creating Your Timesheet');

    // To print the body we send to backend
    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    await handleRequest(
            () async => provider.isEditing
                ? await provider.updatePage(data)
                : await server.postRequest(
                    TIMESHEET_POST,
                    {
                      'data': data,
                    },
                  ),
            context)
        .then((res) {
      Navigator.pop(context);

      if (provider.isEditing && res == false) {
        return;
      } else if (provider.isEditing && res == null) {
        Navigator.pop(context);
      } else if (context.read<ModuleProvider>().isCreateFromPage) {
        if (res != null && res['message']['timesheet'] != null) {
          context.read<ModuleProvider>().pushPage(res['message']['timesheet']);
        }
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (_) => const GenericPage(),
            ))
            .then((value) => Navigator.pop(context));
      } else if (res != null && res['message']['timesheet'] != null) {
        provider.pushPage(res['message']['timesheet']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const GenericPage()));
      }
    });
  }

  @override
  void initState() {
    final provider = context.read<ModuleProvider>();
    super.initState();

    //Editing Mode & Duplicate &  Amending
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        for (var k in data.keys) {
          log("➡️ $k: ${data[k]}");
        }
        data['start_date'] = data['start_date'];
        data['end_date'] = data['end_date'];
        customerName = data['customer'];
        projectName = data['parent_project'];

        setState(() {});
      });
    }
    Provider.of<ModuleProvider>(context, listen: false).clearTimeSheet = [];

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        if (data['doctype'] == DocTypesName.project) {
          data['parent_project'] = data['name'];
          projectName = data['name'];
          customerName = data['customer'];
        }

        if (data['doctype'] == DocTypesName.task) {
          data['parent_project'] = data['project'];
          data['start_date'] = data['exp_start_date'];
          data['end_date'] = data['exp_end_date'];
          data['note'] = data['description'];
        }

        data['doctype'] = "Timesheet";

        data.remove('print_formats');
        data.remove('conn');
        data.remove('comments');
        data.remove('attachments');
        data.remove('docstatus');
        data.remove('name');
        data.remove('_pageData');
        data.remove('_pageId');
        data.remove('_availablePdfFormat');
        data.remove('_currentModule');
        data.remove('status');
        data.remove('taxes');
        data.remove('users');
        data.remove('actual_time');

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
    final provider = context.read<ModuleProvider>();
    List? timeLogs = data['time_logs'];
    List timeSheetData = Provider.of<ModuleProvider>(context).getTimeSheetData;
    data['time_logs'] = timeSheetData;
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      timeLogs?.map((e) {
            provider.setTimeSheet = e;
          }).toList() ??
          [];
    }
    return WillPopScope(
      onWillPop: () async {
        bool? isGoBack =
            await checkDialog(context, 'Are you sure to go back?'.tr());
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
                //_________________________________________First Group_____________________________________________________
                Group(
                  child: ListView(
                    children: [
                      const SizedBox(height: 4),
                      //___________________________________Project_____________________________________________________
                      CustomDropDownFromField(
                          defaultValue: data['parent_project'],
                          docType: APIService.PROJECT,
                          nameResponse: 'name',
                          keys: const {
                            "subTitle": 'project_name',
                            "trailing": 'status',
                          },
                          title: 'Project'.tr(),
                          onChange: (value) {
                            data['parent_project'] = value['name'];
                            setState(() {
                              data['customer'] = value['customer'].toString();
                              projectName = value['name'].toString();
                            });
                          }),
                      //_______________________________________Customer_____________________________________________________
                      CustomTextFieldTest(
                        'customer',
                        'Customer'.tr(),
                        initialValue: data['customer'] ?? '',
                        disableValidation: true,
                        clearButton: true,
                        enabled: false,
                        onChanged: (value) => data['customer'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      //_______________________________________Employee___________________________________________________
                      CustomDropDownFromField(
                          defaultValue: data['employee'],
                          docType: APIService.EMPLOYEE,
                          nameResponse: 'name',
                          isValidate: false,
                          keys: const {
                            "subTitle": 'employee_name',
                            "trailing": 'department',
                          },
                          title: 'Employee'.tr(),
                          onChange: (value) {
                            setState(() {
                              data['employee'] = value['name'];
                            });
                          }),
                      //__________________________________________Second Group_____________________________________________________
                      Row(
                        children: [
                          //____________________________________Expected Start Date______________________________________________
                          Flexible(
                            child: DatePickerTest(
                              'start_date',
                              'Start Date'.tr(),
                              initialValue: data['start_date'],
                              onChanged: (value) => setState(
                                () => data['start_date'] = value,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          //____________________________________Expected End Date______________________________________________
                          Flexible(
                            child: DatePickerTest(
                              'end_date',
                              'End Date'.tr(),
                              onChanged: (value) => Future.delayed(
                                Duration.zero,
                                () => setState(
                                  () => data['end_date'] = value,
                                ),
                              ),
                              initialValue: data['end_date'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ListView(
                  children: [
                    //-------------------------------------------Time logs--------------------------------
                    Group(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time Sheets".tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    bottomSheetBuilder(
                                      bottomSheetView: AddTimeSheetDialog(
                                        projectName: projectName ?? '',
                                      ),
                                      context: context,
                                    );
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                  ),
                                )
                              ],
                            ),
                          ),

                          /// Time Logs list
                          if (timeSheetData.isNotEmpty)
                            SizedBox(
                              height: 190,
                              child: ListView.builder(
                                itemCount: timeSheetData.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: PageCard(
                                          items: [
                                            {
                                              "Activity": timeSheetData[index]
                                                      ['activity_type'] ??
                                                  'none',
                                              "Project": projectName.toString(),
                                              "Hours": timeSheetData[index]
                                                      ['hours']
                                                  .toString(),
                                            }
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            timeSheetData.removeAt(index);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    //________________________________________Task Description_____________________________________________________
                    Group(
                      child: CustomTextFieldTest(
                        'note',
                        'Description'.tr(),
                        minLines: 6,
                        maxLines: null,
                        removeUnderLine: true,
                        initialValue: data['note'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => data['note'] = value,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
