import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_time_sheet_dialog.dart';
import '../../list/otherLists.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/page_group.dart';
import '../../../test/test_text_field.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class TimesheetForm extends StatefulWidget {
  const TimesheetForm({Key? key}) : super(key: key);

  @override
  _TimesheetFormState createState() => _TimesheetFormState();
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

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(
                TIMESHEET_POST,
                {
                  'data': data,
                },
              ),
        context);

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
        data['doctype'] = "Timesheet";
        data['parent_project'] = data['name'];
        projectName = data['name'];
        customerName = data['customer'];

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
                //_________________________________________First Group_____________________________________________________
                Group(
                  child: ListView(
                    children: [
                      const SizedBox(height: 4),
                      //___________________________________Project_____________________________________________________
                      CustomTextFieldTest(
                        'parent_project',
                        'Project',
                        clearButton: true,
                        initialValue: data['parent_project'],
                        onSave: (key, value) {
                          data[key] = value;
                        },
                        onChanged: (value) => data['parent_project'] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => projectScreen(),
                            ),
                          );
                          data['parent_project'] = res['name'];
                          setState(() {
                            data['customer'] = res['customer'].toString();
                            projectName = res['name'].toString();
                          });

                          return res['name'];
                        },
                      ),
                      //_______________________________________Customer_____________________________________________________
                      CustomTextFieldTest(
                        'customer',
                        'Customer',
                        initialValue: data['customer'] ?? '',
                        disableValidation: true,
                        clearButton: true,
                        enabled: false,
                        onChanged: (value) => data['customer'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      //_______________________________________Employee___________________________________________________
                      CustomTextFieldTest(
                        'employee',
                        'Employee',
                        initialValue: data['employee'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => data['employee'] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => selectEmployeeScreen(),
                            ),
                          );
                          data['employee'] = res['name'];
                          return res['name'];
                        },
                      ),
                      //__________________________________________Second Group_____________________________________________________
                      Row(
                        children: [
                          //____________________________________Expected Start Date______________________________________________
                          Flexible(
                            child: DatePickerTest(
                              'start_date',
                              'Start Date',
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
                              'End Date',
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
                                const Text(
                                  "Add State",
                                  style: TextStyle(
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
                        'Note',
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
