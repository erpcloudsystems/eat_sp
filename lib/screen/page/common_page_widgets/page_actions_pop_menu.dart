import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'logs.dart';
import 'comments.dart';
import 'shared_with.dart';
import 'attachments.dart';
import 'assigned_to.dart';
import 'page_pop_item.dart';
import '../../../new_version/core/resources/strings_manager.dart';

class PageActionPopMenu extends StatelessWidget {
  const PageActionPopMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
              PopupMenuItem(
                  child: PagePopItem(
                sheetFunction: showCommentsSheet,
                buttonText: StringsManager.comments.tr(),
                dataKey: 'comments',
                buttonIcon: Icons.message,
              )),
              PopupMenuItem(
                  child: PagePopItem(
                sheetFunction: showAssignedTOSheet,
                buttonText: StringsManager.assignedTo.tr(),
                dataKey: 'assignments',
                buttonIcon: Icons.person,
              )),
              PopupMenuItem(
                  child: PagePopItem(
                sheetFunction: showSharedWithSheet,
                buttonText: StringsManager.sharedWith.tr(),
                dataKey: 'shared_with',
                buttonIcon: Icons.share,
              )),
              PopupMenuItem(
                  child: PagePopItem(
                sheetFunction: showAttachments,
                buttonText: StringsManager.attachments.tr(),
                dataKey: 'attachments',
                buttonIcon: Icons.attach_file,
              )),
              PopupMenuItem(
                  child: PagePopItem(
                sheetFunction: showLogsSheet,
                buttonText: StringsManager.logs.tr(),
                dataKey: 'logs',
                buttonIcon: Icons.history,
              )),
            ]);
  }
}
