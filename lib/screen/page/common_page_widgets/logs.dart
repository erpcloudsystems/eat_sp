import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

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
  final String logs;

  const LogsBubble(this.logs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> parts = logs.split('\n');
    String part1 = parts[0];
    String part2 = parts[1];

    return Container(
      padding: const EdgeInsets.fromLTRB(
        DoublesManager.d_12,
        DoublesManager.d_8,
        DoublesManager.d_12,
        DoublesManager.d_8,
      ),
      margin: const EdgeInsets.symmetric(vertical: DoublesManager.d_8),
      height: DoublesManager.d_100.h,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            part1,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
          Text(
            part2,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
