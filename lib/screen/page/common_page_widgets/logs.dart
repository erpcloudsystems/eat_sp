import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import 'common_utils.dart';
import 'common_page_sheet_body.dart';
import '../../../provider/module/module_provider.dart';
import '../../../new_version/core/resources/app_values.dart';
import '../../../new_version/core/resources/strings_manager.dart';

showLogsSheet(BuildContext context) {
  return CommonPageUtils.commonBottomSheet(
      context: context,
      builderWidget: CommonPageSheetBody(
        scaffoldContext: context,
        databaseKey: 'logs',
        appBarHeader: StringsManager.logs.tr(),
        bubbleWidgetFun: (_, index) => LogsBubble(
          context.read<ModuleProvider>().pageData['logs'][index],
        ),
      ));
}

class LogsBubble extends StatelessWidget {
  const LogsBubble(this.log, {Key? key}) : super(key: key);

  final Map<String, dynamic> log;

  @override
  Widget build(BuildContext context) {
    final ({String timeLine, String time, String? detailedTime}) logObject = (
      timeLine: log['timeline'],
      time: log['time'],
      detailedTime: log['detailed_Time'],
    );
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
      child: LogsBubbleTextWidget(logObject: logObject),
    );
  }
}

class LogsBubbleTextWidget extends StatelessWidget {
  const LogsBubbleTextWidget({super.key, required this.logObject});

  final ({String timeLine, String time, String? detailedTime}) logObject;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: logObject.timeLine,
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          WidgetSpan(
            baseline: TextBaseline.alphabetic,
            alignment: PlaceholderAlignment.baseline,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Tooltip(
                message: logObject.detailedTime ?? 'Waiting for time',
                child: Text(
                  logObject.time,
                  style: const TextStyle(
                      fontSize: 13,
                      color: APP_MAIN_COLOR,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
