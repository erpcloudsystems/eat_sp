import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  _IssueFormState createState() => _IssueFormState();
}

class _IssueFormState extends State<IssueForm> {
  final server = APIService();
  Map<String, dynamic> data = {
    "doctype": "Issue",
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
    for (var k in data.keys) log("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(
                ISSUE_POST,
                {'data': data},
              ),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['issue'] != null)
        context.read<ModuleProvider>().pushPage(res['message']['issue']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['issue'] != null) {
      provider.pushPage(res['message']['issue']);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GenericPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    final provider = context.read<ModuleProvider>();

    //Editing Mode & Duplication Mode
    if (provider.isEditing || provider.duplicateMode)
      Future.delayed(Duration.zero, () {
        data = provider.updateData;

        for (var k in data.keys) {
          log('$k: ${data[k]}');
        }
        setState(() {});
      });

    //DocFromPage Mode
    if (provider.isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = provider.createFromPageData;
        data['doctype'] = "Issue";
        log('${data['items']}');
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
          appBar: AppBar(
            title: (context.read<ModuleProvider>().isEditing)
                ? Text("Edit Issue")
                : Text("Create Issue"),
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
                  //_________________________________________First Group_____________________________________________________
                  Group(
                    child: Column(
                      children: [
                        SizedBox(height: 4),
                        //_______________________________________Subject_____________________________________________________
                        CustomTextField(
                          'subject',
                          'Subject',
                          initialValue: data['subject'],
                          disableValidation: false,
                          clearButton: true,
                          onChanged: (value) => data['subject'] = value,
                          onSave: (key, value) => data[key] = value,
                        ),
                        //_______________________________________Issue Type_____________________________________________________
                        CustomTextField(
                          'issue_type',
                          'Issue Type'.tr(),
                          initialValue: data['issue_type'],
                          disableValidation: true,
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => issueTypeListScreen(),
                            ),
                          ),
                        ),
                        //___________________________________Project_____________________________________________________
                        CustomTextField(
                          'project',
                          'Project',
                          clearButton: true,
                          initialValue: data['project'],
                          onSave: (key, value) {
                            data[key] = value;
                          },
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => projectScreen(),
                              ),
                            );
                            return res['name'];
                          },
                        ),
                        //_______________________________________Department_____________________________________________________
                        CustomTextField(
                          'department',
                          'Department',
                          initialValue: data['department'],
                          disableValidation: true,
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => departmentListScreen(),
                            ),
                          ),
                        ),
                        //_______________________________________Priority___________________________________________________
                        CustomDropDown(
                          'priority',
                          'Priority',
                          items: IssuePriorityList,
                          defaultValue:
                              data['priority'] ?? IssuePriorityList[0],
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
                      ],
                    ),
                  ),
                  //________________________________________Task Description_____________________________________________________
                  Group(
                      child: CustomTextField(
                    'description',
                    'Description',
                    minLines: 1,
                    maxLines: null,
                    removeUnderLine: true,
                    initialValue: data['description'],
                    disableValidation: false,
                    clearButton: true,
                    onSave: (key, value) => data[key] = value,
                    onChanged: (value) => data['description'] = value,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
