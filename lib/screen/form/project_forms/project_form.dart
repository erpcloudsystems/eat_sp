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
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm({Key? key}) : super(key: key);

  @override
  _ProjectFormState createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final server = APIService();
  Map<String, dynamic> data = {
    "doctype": "Project",
    'is_active': "Yes",
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }
    _formKey.currentState!.save();
    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Project');

// To print the body we send to backend
    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(
                PROJECT_POST,
                {'data': data},
              ),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false) {
      return;
    } else if (provider.isEditing && res == null) {
      Navigator.pop(context);
    } else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['project'] != null) {
        context.read<ModuleProvider>().pushPage(res['message']['project']);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['project'] != null) {
      provider.pushPage(res['message']['project']);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const GenericPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final provider = context.read<ModuleProvider>();

    //Editing Mode & Duplication Mode
    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;

        for (var k in data.keys) {
          log('$k: ${data[k]}');
        }
        setState(() {});
      });
    }

    //DocFromPage Mode
    if (provider.isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = provider.createFromPageData;
        data['doctype'] = "Project";
        print('$data');
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
              submit: () {
                _formKey.currentState!.save();
                submit();
              },
              widgetGroup: [
                //_________________________________________First Group_____________________________________________________
                Group(
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      //_______________________________________Project Name_____________________________________________________
                      CustomTextFieldTest(
                        'project_name',
                        'Project Name',
                        initialValue: data['project_name'],
                        disableValidation: false,
                        clearButton: true,
                        onChanged: (value) => data['project_name'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      //_______________________________________Project Type_____________________________________________________
                      CustomTextFieldTest(
                        'project_type',
                        'Project Type'.tr(),
                        initialValue: data['project_type'],
                        disableValidation: true,
                        clearButton: true,
                        onChanged: (value) => setState(() {
                          data['project_type'] = value;
                        }),
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => projectTypeListScreen(),
                            ),
                          );
                          data['project_type'] = res;
                          return res;
                        },
                      ),
                      //_______________________________________Customer_____________________________________________________
                      CustomTextFieldTest(
                        'customer',
                        'Customer',
                        initialValue: data['customer'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onChanged: (value) => setState(() {
                          data['customer'] = value;
                        }),
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => selectCustomerScreen(),
                            ),
                          );
                          data['customer'] = res['name'];
                          return res['name'];
                        },
                      ),
                      //_______________________________________Department_____________________________________________________
                      CustomTextFieldTest(
                        'department',
                        'Department'.tr(),
                        initialValue: data['department'],
                        disableValidation: true,
                        clearButton: true,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => departmentListScreen(),
                            ),
                          );
                          print(res);
                          print(data['department']);
                          data['department'] = res;
                          print(data['department']);
                          return res;
                        },
                        onSave: (key, value) => setState(() {
                          data[key] = value;
                        }),
                        onChanged: (value) => setState(() {
                          data['department'] = value;
                          print(data['department']);
                        }),
                      ),
                      //_______________________________________From Template_____________________________________________________
                      CustomTextFieldTest(
                        'project_template',
                        'Project Template'.tr(),
                        initialValue: data['project_template'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          var res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => projectTemplateListScreen(),
                            ),
                          );
                          data['project_template'] = res;
                          return res;
                        },
                        onChanged: (value) => setState(() {
                          data['project_template'] = value;
                        }),
                      ),
                    ],
                  ),
                ),

                //__________________________________________Second Group_____________________________________________________
                Group(
                  child: ListView(
                    children: [
                      //_______________________________________Priority___________________________________________________
                      CustomDropDown(
                        'priority',
                        'Priority',
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
                        items: ProjectStatusList,
                        defaultValue: data['status'] ?? ProjectStatusList[0],
                        onChanged: (value) => setState(() {
                          data['status'] = value;
                        }),
                      ),
                      //_______________________________________Task Completion_____________________________________________________
                      CustomDropDown(
                        'percent_complete_method',
                        'Task Completion'.tr(),
                        items: TaskCompletionList,
                        defaultValue: data['percent_complete_method'] ??
                            TaskCompletionList[0],
                        onChanged: (value) => setState(() {
                          data['percent_complete_method'] = value;
                        }),
                      ),
                      //_______________________________________Is Group_____________________________________________________
                      CheckBoxWidget(
                        'is_active',
                        'Is Active',
                        initialValue: data['is_active'] == 'Yes' ? true : false,
                        onChanged: (id, value) => setState(
                          () {
                            if (value == true) {
                              data['is_active'] = 'Yes';
                            } else {
                              data['is_active'] = 'No';
                            }
                          },
                        ),
                      ),
                      Row(
                        children: [
                          //____________________________________Expected Start Date______________________________________________
                          Flexible(
                              child: DatePickerTest(
                            'expected_start_date',
                            'Expected Start Date',
                            initialValue: data['expected_start_date'],
                            onChanged: (value) => setState(
                                () => data['expected_start_date'] = value),
                          )),
                          const SizedBox(width: 10),
                          //____________________________________Expected End Date______________________________________________
                          Flexible(
                              child: DatePickerTest(
                                  'expected_end_date', 'Expected End Date',
                                  onChanged: (value) => Future.delayed(
                                      Duration.zero,
                                      () => setState(() =>
                                          data['expected_end_date'] = value)),
                                  initialValue: data['expected_end_date'])),
                        ],
                      ),
                    ],
                  ),
                ),
                //________________________________________Task Description_____________________________________________________
                Group(
                  child: CustomTextFieldTest(
                    'notes',
                    'Description',
                    minLines: 6,
                    maxLines: null,
                    removeUnderLine: true,
                    initialValue: data['notes'],
                    disableValidation: false,
                    clearButton: true,
                    onSave: (key, value) => data[key] = value,
                    onChanged: (value) => setState(() {
                      data['notes'] = value;
                    }),
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
