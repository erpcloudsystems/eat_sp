import 'package:NextApp/widgets/form_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/module/module_provider.dart';
import '../../screen/list/otherLists.dart';

class AddStateDialog extends StatefulWidget {
  const AddStateDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AddStateDialog> createState() => _AddStateDialogState();
}

class _AddStateDialogState extends State<AddStateDialog> {
  Map<String, dynamic> state = {};
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    state['doc_status'] = DocStatus[0];
    state['is_optional_state'] = DocStatus[0];
  }
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
                      state['state'] = value,
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
                      'allow_edit',
                      'Allow Edit',
                      disableValidation: false,
                      clearButton: true,
                      onSave: (key, value) =>
                      state['allow_edit'] = value,
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
                      'doc_status',
                      'Doc Status'.tr(),
                      enable: true,
                      items: DocStatus,
                      defaultValue: state['doc_status'],
                      onChanged: (value) => setState(() {
                        state['doc_status'] = value;
                      }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomDropDown(
                      'is_optional_state',
                      'Is Optional State'.tr(),
                      items: DocStatus,
                      defaultValue: state['is_optional_state'],
                      onChanged: (value) => setState(() {
                        state['is_optional_state'] = value;
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if(formKey.currentState!.validate()){
                              formKey.currentState!.save();
                              provider.setWorkflowStateList(state);
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
