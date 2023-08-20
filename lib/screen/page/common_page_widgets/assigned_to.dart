import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'common_utils.dart';
import 'common_page_sheet_body.dart';
import '../../../provider/module/module_provider.dart';
import '../../../models/page_models/model_functions.dart';
import '../../../widgets/assign_widget/assgin_dialog.dart';
import '../../../new_version/core/resources/app_values.dart';
import '../../../new_version/core/utils/animated_dialog.dart';
import '../../../new_version/core/resources/strings_manager.dart';

showAssignedTOSheet(BuildContext context) {
  return CommonPageUtils.commonBottomSheet(
      context: context,
      builderWidget: CommonPageSheetBody(
        scaffoldContext: context,
        databaseKey: 'assignments',
        appBarHeader: StringsManager.assignments,
        isThereBottomWidget: true,
        bottomWidget: BottomPageAddButton(
            onPressed: () => AnimatedDialog.showAnimatedDialog(
                  context,
                  const AssignToDialog(),
                )),
        bubbleWidgetFun: (_, index) => AssignedBubble(
          context.read<ModuleProvider>().pageData['assignments'][index],
        ),
      ));
}

class AssignedBubble extends StatelessWidget {
  final Map<String, dynamic> assignObject;

  const AssignedBubble(this.assignObject, {Key? key}) : super(key: key);

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
            radius: DoublesManager.d_24,
            child: Text(
              assignObject['assigned_to']!.toString()[0],
              style: const TextStyle(
                fontSize: DoublesManager.d_24,
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
                        assignObject['assigned_to']!.toString(),
                        style: const TextStyle(
                          fontSize: DoublesManager.d_14,
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                        ),
                      ),
                      //________________________ Right Text ______________________________
                      Text(
                          DateFormat("d/M/y  h:mm a").format(DateTime.parse(
                              assignObject['assignment_date']!.toString())),
                          style: const TextStyle(
                              fontSize: DoublesManager.d_12,
                              height: 1.6,
                              color: Colors.black54)),
                    ],
                  ),
                ),
                //________________________________ Subtitle ______________________________
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(
                        left: DoublesManager.d_4,
                        right: DoublesManager.d_4,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        formatDescription(
                            assignObject['description'].toString()),
                        softWrap: true,
                        style: const TextStyle(
                          height: 1.5,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                          text: 'Priority: ',
                          style: TextStyle(
                              fontSize: DoublesManager.d_14,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                              color: Colors.black,
                              letterSpacing: 1),
                        ),
                        TextSpan(
                          text: assignObject['priority'],
                          style: const TextStyle(
                              height: 1.5,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ]),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
