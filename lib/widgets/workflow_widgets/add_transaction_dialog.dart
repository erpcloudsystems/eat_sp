import 'package:NextApp/widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/module/module_provider.dart';
import '../../screen/list/otherLists.dart';

class AddTransitionsDialog extends StatefulWidget {
  const AddTransitionsDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTransitionsDialog> createState() => _AddTransitionsDialogState();
}

class _AddTransitionsDialogState extends State<AddTransitionsDialog> {
  Map<String, dynamic> transitions = {};
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ModuleProvider>(context);
    return Material(
      child: SizedBox(
        height: 450,
        child: Form(
          key: formKey,
          child: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Add State',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                  ),
                ),
              ),
              Group(
                child: Column(
                  children: [
                    CustomTextField(
                      'state',
                      'State',
                      disableValidation: false,
                      clearButton: true,
                      onSave: (key, value) =>
                      transitions['state'] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => statesListScreen(),
                          ),
                        );
                        return res;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      'action',
                      'Action',
                      disableValidation: false,
                      clearButton: true,
                      onSave: (key, value) =>
                      transitions['action'] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => workflowActionListScreen(),
                          ),
                        );
                        return res;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      'next_state',
                      'Next State',
                      disableValidation: false,
                      clearButton: true,
                      onSave: (key, value) =>
                      transitions['next_state'] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => statesListScreen(),
                          ),
                        );
                        return res;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      'allowed',
                      'Allowed',
                      disableValidation: false,
                      clearButton: true,
                      onSave: (key, value) =>
                      transitions['allowed'] = value,
                      onPressed: () async {
                        final res = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => roleListScreen(),
                          ),
                        );
                        return res;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDropDown(
                      'allow_self_approval',
                      'Allow Self Approval'.tr(),
                      enable: true,
                      items: DocStatus,
                      defaultValue: transitions['allow_self_approval'] ??DocStatus[0],
                      onChanged: (value) => setState(() {
                        transitions['allow_self_approval'] = value;
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if(formKey.currentState!.validate()){
                              formKey.currentState!.save();
                              provider.setWorkflowTransitionsList(transitions);
                              Navigator.pop(context);
                            }
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
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
