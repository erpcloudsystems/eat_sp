import 'dart:developer';

import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../list/otherLists.dart';
import '../../page/generic_page.dart';
import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../test/test_text_field.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../test/custom_page_view_form.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/strings_manager.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final server = APIService();
  Map<String, dynamic> data = {
    "doctype": "Task",
    "is_group": 0,
    "is_template": 0,
    'expected_time': 0.0,
    'progress': 0.0,
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Task');

    // To print the body we send to backend
    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }
    data['docstatus'] = 0;

    await handleRequest(
            () async => provider.isEditing
                ? await provider.updatePage(data)
                : await server.postRequest(TASK_POST, {'data': data}),
            context)
        .then((res) {
      Navigator.pop(context);

      if (provider.isEditing && res == false) {
        return;
      } else if (provider.isEditing && res == null) {
        Navigator.pop(context);
      } else if (context.read<ModuleProvider>().isCreateFromPage) {
        if (res != null && res['message']['task'] != null) {
          context.read<ModuleProvider>().pushPage(res['message']['task']);
        }
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (_) => const GenericPage(),
            ))
            .then((value) => Navigator.pop(context));
      } else if (res != null && res['message']['task'] != null) {
        provider.pushPage(res['message']['task']);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const GenericPage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();

    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        setState(() {});
      });
    }

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;

        // Create from Project
        if (data['doctype'] == DocTypesName.project) {
          data['project'] = data['name'];
          data['department'] = data['department'];
          data['expected_start_date'] = data['exp_start_date'];
          data['expected_end_date'] = data['exp_end_date'];
          data['progress'] = 0.0;
          data['expected_time'] = 0.0;
        }

        // Create from Issue
        if (data['doctype'] == DocTypesName.issue) {
          data['issue'] = data['name'];
        }

        data['doctype'] = "Task";

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

                      //_______________________________________Subject_____________________________________________________
                      CustomTextFieldTest(
                        'subject',
                        'Subject'.tr(),
                        initialValue: data['subject'],
                        disableValidation: false,
                        clearButton: true,
                        onChanged: (value) => data['subject'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      //_______________________________________Project_____________________________________________________
                      CustomTextFieldTest(
                        'project',
                        StringsManager.project.tr(),
                        initialValue: data['project'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) {
                          setState(() {
                            data['project'] = value;
                          });
                        },
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => projectScreen(),
                            ),
                          );
                          data['project'] = res['name'];
                          return res['name'];
                        },
                      ),
                      //_______________________________________Parent Task_____________________________________________________
                      CustomTextFieldTest(
                        'parent_task',
                        'Parent Task'.tr(),
                        initialValue: data['parent_task'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => setState(() {
                          data['parent_task'] = value;
                        }),
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => parentTaskScreen(),
                            ),
                          );
                          data['parent_task'] = res;
                          return res;
                        },
                      ),
                      //_______________________________________Issue_____________________________________________________
                      CustomTextFieldTest('issue', 'Issue'.tr(),
                          initialValue: data['issue'],
                          disableValidation: true,
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onChanged: (value) => setState(() {
                                data['issue'] = value;
                              }),
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => issueListScreen(),
                              ),
                            );
                            data['issue'] = res;
                            return res;
                          }),
                      //_______________________________________Type_____________________________________________________
                      CustomTextFieldTest('type', 'Type'.tr(),
                          initialValue: data['type'],
                          disableValidation: true,
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onChanged: (value) => setState(() {
                                data['type'] = value;
                              }),
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => typeListScreen(),
                              ),
                            );
                            data['type'] = res;
                            return res;
                          }),
                      //_______________________________________Department_____________________________________________________
                      CustomTextFieldTest(
                        'department',
                        'Department'.tr(),
                        initialValue: data['department'],
                        disableValidation: true,
                        clearButton: true,
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
                    ],
                  ),
                ),

                //__________________________________________Second Group_____________________________________________________
                Group(
                  child: ListView(
                    children: [
                      //_______________________________________Priority___________________________________________________
                      CustomDropDownTest(
                        'priority',
                        'Priority'.tr(),
                        fontSize: 16,
                        items: ProjectPriorityList,
                        defaultValue:
                            data['priority'] ?? ProjectPriorityList[0],
                        onChanged: (value) => setState(() {
                          data['priority'] = value;
                        }),
                      ),
                      //_______________________________________Status_____________________________________________________
                      CustomDropDown(
                        'status',
                        'Status'.tr(),
                        fontSize: 16,
                        items: TaskStatusList,
                        defaultValue: data['status'] ?? TaskStatusList[0],
                        onChanged: (value) => setState(() {
                          data['status'] = value;
                        }),
                      ),
                      //_______________________________________Is Group_____________________________________________________
                      CheckBoxWidget(
                        'is_group',
                        'Is Group'.tr(),
                        fontSize: 16,
                        initialValue: data['is_group'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () => data[id] = value ? 1 : 0,
                        ),
                      ),
                      //____________________________________Is Template_____________________________________________________
                      CheckBoxWidget(
                        'is_template',
                        'Is Template'.tr(),
                        fontSize: 16,
                        initialValue: data['is_template'] == 1 ? true : false,
                        onChanged: (id, value) => setState(
                          () => data[id] = value ? 1 : 0,
                        ),
                      ),
                      Row(
                        children: [
                          //____________________________________Expected Start Date______________________________________________
                          Flexible(
                              child: DatePickerTest(
                            'exp_start_date',
                            'Start Date'.tr(),
                            initialValue: data['exp_start_date'],
                            onChanged: (value) =>
                                setState(() => data['exp_start_date'] = value),
                          )),
                          const SizedBox(width: 10),
                          //____________________________________Expected End Date______________________________________________
                          Flexible(
                            child: DatePickerTest(
                              'exp_end_date',
                              'End Date'.tr(),
                              onChanged: (value) => Future.delayed(
                                  Duration.zero,
                                  () => setState(
                                      () => data['exp_end_date'] = value)),
                              initialValue: data['exp_end_date'],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          //____________________________________Expected Time______________________________________________
                          Flexible(
                            child: CustomTextFieldTest(
                              'expected_time',
                              'Expected Time'.tr(),
                              initialValue: data['expected_time'].toString(),
                              disableValidation: false,
                              clearButton: true,
                              validator: (value) =>
                                  numberValidation(value, allowNull: false),
                              keyboardType: TextInputType.number,
                              onSave: (key, value) =>
                                  data[key] = double.tryParse(value),
                              onChanged: (value) => setState(() {
                                data['expected_time'] = double.tryParse(value);
                              }),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //____________________________________Progress______________________________________________
                          Flexible(
                            child: CustomTextFieldTest(
                              'progress',
                              'Progress'.tr(),
                              initialValue: data['progress'].toString(),
                              disableValidation: false,
                              clearButton: true,
                              validator: (value) =>
                                  numberValidation(value, allowNull: false),
                              keyboardType: TextInputType.number,
                              onSave: (key, value) =>
                                  data[key] = double.tryParse(value),
                              onChanged: (value) =>
                                  data['progress'] = double.tryParse(value),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //________________________________________Task Description_____________________________________________________
                Group(
                  child: CustomTextFieldTest(
                    'description',
                    'Description'.tr(),
                    minLines: 6,
                    maxLines: null,
                    removeUnderLine: true,
                    initialValue: data['description'],
                    disableValidation: false,
                    clearButton: true,
                    onSave: (key, value) => data[key] = value,
                    onChanged: (value) => data['description'] = value,
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
