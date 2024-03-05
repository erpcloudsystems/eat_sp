import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/new_widgets/custom_page_view_form.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import '../../list/otherLists.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';

class IssueForm extends StatefulWidget {
  const IssueForm({Key? key}) : super(key: key);

  @override
  State<IssueForm> createState() => _IssueFormState();
}

class _IssueFormState extends State<IssueForm> {
  final server = APIService();
  Map<String, dynamic> data = {
    "doctype": "Issue",
    'priority': IssuePriorityList[0],
  };

  final _formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    final provider = context.read<ModuleProvider>();
    if (!_formKey.currentState!.validate()) {
      showSnackBar(KFillRequiredSnackBar, context);
      return;
    }

    Provider.of<ModuleProvider>(context, listen: false)
        .initializeDuplicationMode(data);

    _formKey.currentState!.save();

    showLoadingDialog(
        context,
        provider.isEditing
            ? 'Updating ${provider.pageId}'
            : 'Creating Your Issue');
    // To print the body we send to backend
    for (var k in data.keys) {
      log("➡️ $k: ${data[k]}");
    }

    await handleRequest(
            () async => provider.isEditing
                ? await provider.updatePage(data)
                : await server.postRequest(
                    ISSUE_POST,
                    {'data': data},
                  ),
            context)
        .then((res) {
      Navigator.pop(context);

      if (provider.isEditing && res == false) {
        return;
      } else if (provider.isEditing && res == null) {
        Navigator.pop(context);
      } else if (context.read<ModuleProvider>().isCreateFromPage) {
        if (res != null && res['message']['issue'] != null) {
          context.read<ModuleProvider>().pushPage(res['message']['issue']);
        }
        Navigator.of(context)
            .push(MaterialPageRoute(
              builder: (_) => const GenericPage(),
            ))
            .then((value) => Navigator.pop(context));
      } else if (res != null && res['message']['issue'] != null) {
        provider.pushPage(res['message']['issue']);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const GenericPage(),
          ),
        );
      }
    });
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
        data = context.read<ModuleProvider>().createFromPageData;
        data['doctype'] = "Issue";
        data['project'] = data['name'];

        data.remove('print_formats');
        data.remove('project_name');
        data.remove('notes');
        data.remove('conn');
        data.remove('comments');
        data.remove('attachments');
        data.remove('docstatus');
        data.remove('name');
        data.remove('_pageData');
        data.remove('_pageId');
        data.remove('_availablePdfFormat');
        data.remove('_currentModule');
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
                  child: Column(
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
                      //_______________________________________Issue Type_____________________________________________________
                      CustomTextFieldTest(
                        'issue_type',
                        'Issue Type'.tr(),
                        initialValue: data['issue_type'],
                        disableValidation: true,
                        clearButton: true,
                        onSave: (key, value) => data[key] = value,
                        onPressed: () async {
                          final res = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => issueTypeListScreen(),
                            ),
                          );
                          data['issue_type'] = res;
                          return res;
                        },
                      ),
                      //___________________________________Project_____________________________________________________
                      CustomTextFieldTest(
                        'project',
                        'Project'.tr(),
                        clearButton: true,
                        initialValue: data['project'],
                        onSave: (key, value) {
                          data[key] = value;
                        },
                        onChanged: (value) => setState(() {
                          data['project'] = value;
                        }),
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
                    ],
                  ),
                ),
                //________________________________________Task Description_____________________________________________________
                Group(
                  child: ListView(
                    children: [
                      //_______________________________________Priority___________________________________________________
                      CustomDropDown(
                        'priority',
                        'Priority'.tr(),
                        items: IssuePriorityList,
                        defaultValue: data['priority'] ?? IssuePriorityList[0],
                        onChanged: (value) => setState(() {
                          data['priority'] = value;
                        }),
                      ),
                      //_______________________________________Status_____________________________________________________
                      CustomDropDown(
                        'status',
                        'Status'.tr(),
                        items: IssueStatusList,
                        defaultValue: data['status'] ?? IssueStatusList[0],
                        onChanged: (value) => setState(() {
                          data['status'] = value;
                        }),
                      ),

                      //_______________________________________ Description ________________________________________________
                      CustomTextFieldTest(
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
