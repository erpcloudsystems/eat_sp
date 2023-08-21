import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'comments.dart';
import 'assigned_to.dart';
import 'shared_with.dart';
import 'page_common_button.dart';
import '../../../new_version/core/resources/strings_manager.dart';

class PageSharedButtons extends StatelessWidget {
  const PageSharedButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: 2.8,
      children: [
        PageCommonButton(
          sheetFunction: showCommentsSheet,
          buttonText: StringsManager.comments.tr(),
          dataKey: 'comments',
          buttonIcon: Icons.message,
        ),
        PageCommonButton(
          sheetFunction: showAssignedTOSheet,
          buttonText: StringsManager.assignedTo.tr(),
          dataKey: 'assignments',
          buttonIcon: Icons.person,
        ),
        // TODO: sheetFunction & database Key
        PageCommonButton(
          sheetFunction: showCommentsSheet,
          buttonText: '${StringsManager.logs.tr()}         ',
          dataKey: 'comments',
          buttonIcon: Icons.history,
        ),
        PageCommonButton(
          sheetFunction: showSharedWithSheet,
          buttonText: StringsManager.sharedWith.tr(),
          dataKey: 'shared_with',
          buttonIcon: Icons.share,
        ),
      ],
    );
  }
}
