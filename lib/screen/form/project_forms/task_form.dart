import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../service/service.dart';
import '../../../service/service_constants.dart';
import '../../../provider/module/module_provider.dart';
import '../../list/otherLists.dart';
import '../../../widgets/dialog/loading_dialog.dart';
import '../../../widgets/dismiss_keyboard.dart';
import '../../../widgets/form_widgets.dart';
import '../../../widgets/snack_bar.dart';
import '../../../core/constants.dart';
import '../../page/generic_page.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({Key? key}) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final server = APIService();
  Map<String, dynamic> data = {
    "doctype": "Task",
    "is_group": 0,
    "is_template": 0,
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
            : 'Creating Your Sales Invoice');

    for (var k in data.keys)
      print("➡️ $k: ${data[k]}"); // To print the body we send to backend

    final res = await handleRequest(
        () async => provider.isEditing
            ? await provider.updatePage(data)
            : await server.postRequest(TASK_POST, {'data': data}),
        context);

    Navigator.pop(context);

    if (provider.isEditing && res == false)
      return;
    else if (provider.isEditing && res == null)
      Navigator.pop(context);
    else if (context.read<ModuleProvider>().isCreateFromPage) {
      if (res != null && res['message']['task'] != null)
        context.read<ModuleProvider>().pushPage(res['message']['task']);
      Navigator.of(context)
          .push(MaterialPageRoute(
            builder: (_) => GenericPage(),
          ))
          .then((value) => Navigator.pop(context));
    } else if (res != null && res['message']['task'] != null) {
      provider.pushPage(res['message']['task']);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => GenericPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    //Editing Mode
    if (context.read<ModuleProvider>().isEditing)
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().updateData;
        setState(() {});
      });

    //DocFromPage Mode
    if (context.read<ModuleProvider>().isCreateFromPage) {
      Future.delayed(Duration.zero, () {
        data = context.read<ModuleProvider>().createFromPageData;
        data['doctype'] = "Task";
        print('${data['items']}');
        setState(() {});
      });
    }
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
                ? Text("Edit Task")
                : Text("Create Task"),
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
                        //_______________________________________Project_____________________________________________________
                        CustomTextField('project', 'Project'.tr(),
                            initialValue: data['project'],
                            disableValidation: true,
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => projectScreen()))),
                        //_______________________________________Issue_____________________________________________________
                        CustomTextField('issue', 'Issue',
                            initialValue: data['issue'],
                            disableValidation: true,
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => issueListScreen()))),
                        //_______________________________________Type_____________________________________________________
                        CustomTextField('type', 'Type',
                            initialValue: data['type'],
                            disableValidation: true,
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => typeListScreen()))),
                        //_______________________________________Department_____________________________________________________
                        CustomTextField('department', 'Department',
                            initialValue: data['department'],
                            disableValidation: true,
                            clearButton: true,
                            onSave: (key, value) => data[key] = value,
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => departmentListScreen()))),
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
                        //_______________________________________Is Group_____________________________________________________
                        CheckBoxWidget('is_group', 'Is Group',
                            initialValue: data['is_group'] == 1 ? true : false,
                            onChanged: (id, value) =>
                                setState(() => data[id] = value ? 1 : 0)),
                        //____________________________________Is Template_____________________________________________________
                        CheckBoxWidget('is_template', 'Is Template',
                            initialValue:
                                data['is_template'] == 1 ? true : false,
                            onChanged: (id, value) =>
                                setState(() => data[id] = value ? 1 : 0)),
                      ],
                    ),
                  ),

                  //__________________________________________Second Group_____________________________________________________
                  Group(
                    child: Column(
                      children: [
                        Row(children: [
                          //____________________________________Expected Start Date______________________________________________
                          Flexible(
                              child: DatePicker(
                            'exp_start_date',
                            'Expected Start Date',
                            initialValue: data['exp_start_date'] ?? null,
                            onChanged: (value) =>
                                setState(() => data['exp_start_date'] = value),
                          )),
                          SizedBox(width: 10),
                          //____________________________________Expected End Date______________________________________________
                          Flexible(
                              child: DatePicker(
                                  'exp_end_date', 'Expected End Date',
                                  onChanged: (value) => Future.delayed(
                                      Duration.zero,
                                      () => setState(
                                          () => data['exp_end_date'] = value)),
                                  initialValue: data['exp_end_date'] ?? null)),
                        ]),
                        Row(children: [
                          //____________________________________Expected Time______________________________________________
                          Flexible(
                            child: CustomTextField(
                              'expected_time',
                              'Expected Time',
                              initialValue: data['expected_time'],
                              disableValidation: false,
                              clearButton: true,
                              validator: (value) =>
                                  numberValidation(value, allowNull: false),
                              keyboardType: TextInputType.number,
                              onSave: (key, value) =>
                                  data[key] = double.tryParse(value),
                              onChanged: (value) => data['expected_time'] =
                                  double.tryParse(value),
                            ),
                          ),
                          SizedBox(width: 10),
                          //____________________________________Progress______________________________________________
                          Flexible(
                            child: CustomTextField(
                              'progress',
                              'Progress',
                              initialValue: data['progress'],
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
                        ]),
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
