import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../form_widgets.dart';
import '../custom-button.dart';
import '../../service/service.dart';
import '../dialog/loading_dialog.dart';
import '../../test/test_text_field.dart';
import '../../screen/list/otherLists.dart';
import '../../provider/module/module_provider.dart';
import '../../provider/new_controller/home_provider.dart';

class ShareDocWidget extends StatefulWidget {
  const ShareDocWidget({super.key});

  @override
  State<ShareDocWidget> createState() => _ShareDocWidgetState();
}

class _ShareDocWidgetState extends State<ShareDocWidget> {
  Map<String, dynamic> shareData = {
    'read': 0,
    'write': 0,
    'share': 0,
    'submit': 0,
  };
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final moduleProvider = context.read<ModuleProvider>();
    final homeProvider = context.read<HomeProvider>();

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 120.0),
        child: Group(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${'Share'.tr()}  ${moduleProvider.pageId}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                CustomTextFieldTest(
                  'user',
                  'Share this document with'.tr(),
                  initialValue: shareData['user'] ?? '',
                  onChanged: (value) {
                    shareData['user'] = value;
                  },
                  onPressed: () async {
                    final res = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => userListScreen(),
                      ),
                    );
                    shareData['user'] = res;
                    return res;
                  },
                ),
                Row(
                  children: [
                    Flexible(
                      child: CheckBoxWidget(
                        'can_read',
                        'Can Read'.tr(),
                        initialValue: shareData['read'] == 0 ? false : true,
                        onChanged: (id, value) => setState(() {
                          shareData['read'] = value ? 1 : 0;
                        }),
                      ),
                    ),
                    Flexible(
                      child: CheckBoxWidget(
                        'can_write',
                        'Can Write'.tr(),
                        initialValue: shareData['write'] == 0 ? false : true,
                        onChanged: (id, value) {
                          setState(() {
                            shareData['write'] = value ? 1 : 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      child: CheckBoxWidget(
                        'can_submit',
                        'Can Submit'.tr(),
                        initialValue: shareData['submit'] == 0 ? false : true,
                        onChanged: (id, value) {
                          setState(() {
                            shareData['submit'] = value ? 1 : 0;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      child: CheckBoxWidget(
                        'can_share',
                        'Can Share'.tr(),
                        initialValue: shareData['share'] == 0 ? false : true,
                        onChanged: (id, value) {
                          setState(() {
                            shareData['share'] = value ? 1 : 0;
                          });
                        },
                      ),
                    ),
                  ],
                ),

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
                        text: 'Cancel',
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      CustomButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            shareData['docType'] =
                                moduleProvider.currentModule.title;
                            shareData['docId'] = moduleProvider.pageId;
                            showLoadingDialog(context, 'Sharing');
                            await handleRequest(
                                    () async => {
                                          await homeProvider.sharedDoc(
                                              data: shareData),
                                          await context
                                              .read<ModuleProvider>()
                                              .loadPage()
                                        },
                                    context)
                                .whenComplete(() {
                              setState(() {
                                moduleProvider.pageData['shared_with'] =
                                    moduleProvider.pageData['shared_with'];
                              });
                              // we do this permanently because of a bug that prevent the bottom
                              //sheet list from getting new data unless there is hot reload.
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
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
    );
  }
}
