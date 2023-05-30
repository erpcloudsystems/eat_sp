import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../list/otherLists.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';
import '../../../service/service.dart';
import '../../../widgets/snack_bar.dart';
import '../../../widgets/page_group.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../service/service_constants.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../provider/module/module_provider.dart';
import '../../../widgets/workflow_widgets/add_state_dialog.dart';
import '../../../widgets/workflow_widgets/row_button_add_widget.dart';
import '../../../widgets/workflow_widgets/add_transaction_dialog.dart';

class WorkflowForm extends StatefulWidget {
  const WorkflowForm({Key? key}) : super(key: key);

  @override
  State<WorkflowForm> createState() => _WorkflowFormState();
}

class _WorkflowFormState extends State<WorkflowForm> {
  final service = APIService();
  Map<String, dynamic> data = {
    'doctype': "Workflow",
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
            : 'Creating Your Workflow');

    // To print the body we send to backend
    for (var k in data.keys) log("➡️ $k: ${data[k]}");

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await service.postRequest(
                WORKFLOW_POST,
                {'data': data},
              ),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['workflow'] != null)
        context.read<ModuleProvider>().pushPage(res['message']['workflow']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['workflow'] != null) {
      provider.pushPage(res['message']['workflow']);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => GenericPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    final provider = context.read<ModuleProvider>();
    super.initState();

    provider.workflowStates.clear();
    provider.workflowTransitions.clear();

    //Editing mode & Duplicate mode
    if (provider.isEditing || provider.duplicateMode) {
      Future.delayed(Duration.zero, () {
        data = provider.updateData;
        provider.workflowStates = data['states'];
        provider.workflowTransitions = data['transitions'];
        setState(() {});
      });
    }

    data['states'] = provider.workflowStates;
    data['transitions'] = provider.workflowTransitions;
    if (provider.isCreateFromPage)
      Future.delayed(Duration.zero, () {
        data = provider.createFromPageData;
        data['doctype'] = "Workflow";
        setState(() {});
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
          appBar: AppBar(
            title: (context.read<ModuleProvider>().isEditing)
                ? Text("Edit Workflow")
                : Text("Create Workflow"),
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
                  ///First Group
                  Group(
                    child: Column(
                      children: [
                        SizedBox(height: 4),
                        //_______________________________________Workflow Name_____________________________________________________
                        CustomTextField(
                          'workflow_name',
                          'Workflow Name',
                          initialValue: data['workflow_name'],
                          disableValidation: false,
                          clearButton: true,
                          onChanged: (value) => data['workflow_name'] = value,
                          onSave: (key, value) => data[key] = value,
                        ),

                        //_______________________________________Doc Type_____________________________________________________
                        CustomTextField(
                          'document_type',
                          'Document Type'.tr(),
                          initialValue: data['document_type'],
                          disableValidation: true,
                          clearButton: true,
                          onSave: (key, value) => data[key] = value,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => documentTypeListScreen(),
                            ),
                          ),
                        ),
                        //---------------------------------------IS Active----------------------------------------------------
                        CheckBoxWidget(
                          'is_active',
                          'Is Active',
                          initialValue: data['is_active'] == 1 ? true : false,
                          onChanged: (id, value) => setState(
                            () {
                              data[id] = value ? 1 : 0;
                            },
                          ),
                        ),
                        //---------------------------------------Don't Override Status----------------------------------------
                        CheckBoxWidget(
                          'override_status',
                          'Override Status',
                          initialValue:
                              data['override_status'] == 1 ? true : false,
                          onChanged: (id, value) => setState(
                            () {
                              data[id] = value ? 1 : 0;
                            },
                          ),
                        ),
                        //---------------------------------------Send Email Alert----------------------
                        CheckBoxWidget(
                          'send_email_alert',
                          'Send Email Alert',
                          initialValue:
                              data['send_email_alert'] == 1 ? true : false,
                          onChanged: (id, value) => setState(
                            () {
                              data[id] = value ? 1 : 0;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Second Group
                  Consumer<ModuleProvider>(
                    builder: (context, builder, child) {
                      return Column(
                        children: [
                          Group(
                            child: Column(
                              children: [
                                RowButtonAddWidget(
                                  title: "Add State",
                                  onPressed: () {
                                    bottomSheetBuilder(
                                      bottomSheetView: AddStateDialog(),
                                      context: context,
                                    );
                                  },
                                ),
                                if (builder.workflowStates.isNotEmpty)
                                  SizedBox(
                                    height: builder.workflowStates.length * 100,
                                    child: ListView.builder(
                                      itemCount: builder.workflowStates.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: PageCard(
                                                items: [
                                                  {
                                                    "State":
                                                        builder.workflowStates[
                                                            index]['state'],
                                                    "Allow Edit": builder
                                                            .workflowStates[
                                                        index]['allow_edit'],
                                                    "Doc Status": builder
                                                            .workflowStates[
                                                        index]['doc_status'],
                                                  }
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  builder.workflowStates
                                                      .removeAt(index);
                                                });
                                              },
                                              icon: Icon(
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
                          Group(
                            child: Column(
                              children: [
                                RowButtonAddWidget(
                                  title: "Add Transaction",
                                  onPressed: () {
                                    bottomSheetBuilder(
                                      bottomSheetView: AddTransitionsDialog(),
                                      context: context,
                                    );
                                  },
                                ),
                                if (builder.workflowTransitions.isNotEmpty)
                                  SizedBox(
                                    height: builder.workflowTransitions.length *
                                        100,
                                    child: ListView.builder(
                                      itemCount:
                                          builder.workflowTransitions.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: PageCard(
                                                items: [
                                                  {
                                                    "State": builder
                                                            .workflowTransitions[
                                                        index]['state'],
                                                    "Action": builder
                                                            .workflowTransitions[
                                                        index]['action'],
                                                    "Next State": builder
                                                            .workflowTransitions[
                                                        index]['next_state'],
                                                  }
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  builder.workflowTransitions
                                                      .removeAt(index);
                                                });
                                              },
                                              icon: Icon(
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
                          )
                        ],
                      );
                    },
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
