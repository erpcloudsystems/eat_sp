import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../form_widgets.dart';
import '../custom-button.dart';
import '../../core/constants.dart';
import '../../service/service.dart';
import '../../screen/list/otherLists.dart';
import '../../service/service_constants.dart';
import '../../provider/user/user_provider.dart';
import '../../provider/module/module_provider.dart';

class AssignToDialog extends StatefulWidget {
  const AssignToDialog({Key? key}) : super(key: key);

  @override
  State<AssignToDialog> createState() => _AssignToDialogState();
}

class _AssignToDialogState extends State<AssignToDialog> {
  List<String> assignToList = [];
  Map<String, dynamic> data = {};
  bool assignToMe = false;
  final server = APIService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    data['reference_type'] = context.read<ModuleProvider>().currentModule.title;
    data['reference_name'] = context.read<ModuleProvider>().pageId;
    data['priority'] = AssignToPriorityList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        color: Colors.transparent,
        child: Group(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Add ToDo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    //_______________________________________Assign to_____________________________________________________
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Assign To',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => userListScreen(),
                              ),
                            );
                            setState(() {
                              assignToList.add(res);
                            });
                            return res;
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

                    Container(
                      width: double.infinity,
                      height: 150.h,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: APPBAR_COLOR,
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: assignToList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.black45,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  assignToList[index],
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      assignToList.removeAt(index);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    //---------------------------------------Assign to me ---------------------------
                    CheckBoxWidget('assign_to_me', 'Assign to me',
                        initialValue: assignToMe, onChanged: (id, value) {
                      if (!assignToMe) {
                        setState(() {
                          assignToList.add(context.read<UserProvider>().userId);
                          assignToMe = !assignToMe;
                        });
                      } else {
                        setState(() {
                          assignToList
                              .remove(context.read<UserProvider>().userId);
                          assignToMe = !assignToMe;
                        });
                      }
                    }),

                    /// Priority
                    CustomDropDown(
                      'priority',
                      'Priority'.tr(),
                      fontSize: 16,
                      items: AssignToPriorityList,
                      defaultValue: data['priority'] ?? AssignToPriorityList[0],
                      onChanged: (value) => setState(() {
                        data['priority'] = value;
                      }),
                    ),
                    SizedBox(height: 10.h),

                    /// Complete By
                    DatePicker(
                      'date',
                      'Complete By',
                      initialValue: data['date'],
                      onChanged: (value) => setState(
                        () => data['date'] = value,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    /// Description
                    CustomTextField(
                      'description',
                      'Description',
                      maxLines: null,
                      removeUnderLine: false,
                      disableValidation: false,
                      clearButton: true,
                      onSave: (key, value) => data['description'] = value,
                      onChanged: (value) => data['description'] = value,
                    ),
                    SizedBox(height: 10.h),
                    // Add Button
                    Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            color: Colors.red,
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            text: 'Back',
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() {
                                  data['assign_to'] = assignToList;
                                });
                                await handleRequest(
                                    () async => await server.postRequest(
                                          ASSIGN_TO,
                                          {'data': data},
                                        ),
                                    context);
                                Navigator.pop(context);
                              }
                            },
                            text: 'Add',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
