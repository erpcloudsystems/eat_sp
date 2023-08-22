import 'package:NextApp/core/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../new_version/core/utils/animated_dialog.dart';
import '../../../widgets/genric_page_widget/share_doc_widget.dart';
import 'common_utils.dart';
import 'common_page_sheet_body.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/app_values.dart';
import '../../../new_version/core/resources/strings_manager.dart';

showSharedWithSheet(BuildContext context) {
  return CommonPageUtils.commonBottomSheet(
      context: context,
      builderWidget: CommonPageSheetBody(
        scaffoldContext: context,
        databaseKey: 'shared_with',
        appBarHeader: StringsManager.sharedWith,
        isThereBottomWidget: true,
        bottomWidget: BottomPageAddButton(
            onPressed: () => AnimatedDialog.showAnimatedDialog(
                context, const ShareDocWidget())),
        bubbleWidgetFun: (_, index) => SharedWithBubble(
          context.read<ModuleProvider>().pageData['shared_with'][index],
        ),
      ));
}

class SharedWithBubble extends StatelessWidget {
  final Map<String, dynamic> sharedObject;

  const SharedWithBubble(this.sharedObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        DoublesManager.d_12,
        DoublesManager.d_8,
        DoublesManager.d_12,
        DoublesManager.d_8,
      ),
      margin: const EdgeInsets.symmetric(vertical: DoublesManager.d_8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DoublesManager.d_14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //____________________ First Letter Circle ______________________________
          CircleAvatar(
            radius: DoublesManager.d_20,
            child: Text(
              sharedObject['user']!.toString()[0],
              style: TextStyle(
                fontSize: DoublesManager.d_20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: DoublesManager.d_10),
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DoublesManager.d_3,
                    vertical: DoublesManager.d_0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //____________________ Name Or Header ______________________________
                      Text(
                        sharedObject['user']!.toString(),
                        style: TextStyle(
                          fontSize: DoublesManager.d_14.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                        ),
                      ),
                      //________________________ Date ______________________________
                      Text(
                          DateFormat("d/M/y  h:mm a").format(DateTime.parse(
                              sharedObject['sharing_date']!.toString())),
                          style: TextStyle(
                              fontSize: DoublesManager.d_12.sp,
                              height: 1.6,
                              color: Colors.black54)),
                    ],
                  ),
                ),
                SizedBox(height: 25.h),
                //________________________________ Check Boxes ______________________________
                Row(
                  children: [
                    SharedCheckBox(
                      sharedObject: sharedObject,
                      databaseKey: 'Read',
                    ),
                    SharedCheckBox(
                      sharedObject: sharedObject,
                      databaseKey: 'Write',
                    ),
                  ],
                ),
                Row(
                  children: [
                    SharedCheckBox(
                      sharedObject: sharedObject,
                      databaseKey: 'Share',
                    ),
                    SharedCheckBox(
                      sharedObject: sharedObject,
                      databaseKey: 'Submit',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SharedCheckBox extends StatelessWidget {
  final Map<String, dynamic> sharedObject;
  final String databaseKey;
  const SharedCheckBox({
    super.key,
    required this.sharedObject,
    required this.databaseKey,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(
      children: [
        SizedBox(
          height: 30,
          child: Checkbox(
              fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return APP_MAIN_COLOR;
                }
                return Colors.grey;
              }),
              value: (sharedObject[databaseKey] ?? 0) == 0 ? false : true,
              onChanged: null),
        ),
        Text(
          databaseKey,
          style: TextStyle(
            fontSize: DoublesManager.d_14.sp,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ),
      ],
    ));
  }
}
