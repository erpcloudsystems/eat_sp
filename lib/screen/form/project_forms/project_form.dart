import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../new_version/core/utils/custom_drop_down_form_feild.dart';
import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
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
                        'Project Name'.tr(),
                        initialValue: data['project_name'],
                        disableValidation: false,
                        clearButton: true,
                        onChanged: (value) => data['project_name'] = value,
                        onSave: (key, value) => data[key] = value,
                      ),
                      //_______________________________________Project Type_____________________________________________________
                      CustomDropDownFromField(
                          defaultValue: data['project_type'],
                          isValidate: false,
                          docType: APIService.PROJECT_TYPE,
                          nameResponse: 'name',
                          keys: const {
                            "suTitle": 'project_type',
                            "trailing": 'description',
                          },
                          title: 'Project Type'.tr(),
                          onChange: (value) {
                            setState(() {
                              data['project_type'] = value['name'];
                            });
                          }),
                      //_______________________________________Customer_____________________________________________________
                      CustomDropDownFromField(
                          defaultValue: data['customer'],
                          isValidate: false,
                          docType: APIService.CUSTOMER,
                          nameResponse: 'name',
                          keys: const {
                            "subTitle": 'customer_name',
                            "trailing": 'territory',
                          },
                          title: 'Customer'.tr(),
                          onChange: (value) {
                            setState(() {
                              data['customer'] = value['name'];
                            });
                          }),
                      //_______________________________________Department_____________________________________________________
                      CustomDropDownFromField(
                          defaultValue: data['department'],
                          isValidate: false,
                          docType: APIService.DEPARTMENT,
                          nameResponse: 'name',
                          keys: const {
                            "subTitle": 'department_name',
                            "trailing": 'company',
                          },
                          title: 'Department'.tr(),
                          onChange: (value) {
                            setState(() {
                              data['department'] = value['name'];
                            });
                          }),
                      //_______________________________________From Template_____________________________________________________
                      CustomDropDownFromField(
                          defaultValue: data['project_template'],
                          isValidate: false,
                          docType: APIService.PROJECT_TEMPLATE,
                          nameResponse: 'name',
                          title: 'Project Template'.tr(),
                          onChange: (value) {
                            setState(() {
                              data['project_template'] = value['name'];
                            });
                          }),
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
                        'Is Active'.tr(),
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
                            'Start Date'.tr(),
                            initialValue: data['expected_start_date'],
                            onChanged: (value) => setState(
                                () => data['expected_start_date'] = value),
                          )),
                          const SizedBox(width: 10),
                          //____________________________________Expected End Date______________________________________________
                          Flexible(
                              child: DatePickerTest(
                                  'expected_end_date', 'End Date'.tr(),
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
                    'Description'.tr(),
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
