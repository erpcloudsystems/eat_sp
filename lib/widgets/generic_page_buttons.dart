import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:NextApp/new_version/modules/printer/controller/cubit/printer_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_menu/expandable_menu.dart';
import 'package:badges/badges.dart' as badges;
import 'package:NextApp/core/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'genric_page_widget/assgin_dialog.dart';
import '../provider/module/module_provider.dart';
import 'genric_page_widget/share_doc_widget.dart';
import '../new_version/core/resources/app_values.dart';
import '../new_version/core/utils/animated_dialog.dart';
import '../screen/page/common_page_widgets/attachments.dart';

/// This is the Buttons in the [AppBar] of any page.
class GenericPageButtons extends StatelessWidget {
  const GenericPageButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Padding(
        padding: const EdgeInsets.only(
          top: DoublesManager.d_8,
          bottom: DoublesManager.d_8,
          right: DoublesManager.d_5,
        ),
        child: ExpandableMenu(
          backgroundColor: const Color(0xFF4B5042).withOpacity(.8),
          itemContainerColor: Colors.transparent,
          height: DoublesManager.d_30,
          width: DoublesManager.d_50,
          items: const [
            AssignPageButton(),
            SizedBox(width: DoublesManager.d_20),
            EditPageButton(),
            SizedBox(width: DoublesManager.d_20),
            DownloadPdfButton(),
            SizedBox(width: DoublesManager.d_20),
            PrintPageButton(),
            SizedBox(width: DoublesManager.d_20),
            AttachmentPageButton(),
            SizedBox(width: DoublesManager.d_20),
            DuplicatePageButton(),
          ],
        ),
      ),
    );
  }
}

class AssignPageButton extends StatelessWidget {
  const AssignPageButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        color: APPBAR_COLOR,
        onPressed: () {
          AnimatedDialog.showAnimatedDialog(
            context,
            const AssignToDialog(),
          );
        },
        icon: const Icon(
          Icons.add,
          color: Colors.black,
          size: 35,
        ),
        padding: const EdgeInsets.only(bottom: DoublesManager.d_10),
        tooltip: 'Assign',
        iconSize: DoublesManager.d_25,
        splashRadius: DoublesManager.d_20,
      );
}

class EditPageButton extends StatelessWidget {
  const EditPageButton({super.key});

  void editPage(BuildContext context) {
    // notifying the provider to enable edit mood for the next form
    context.read<ModuleProvider>().editThisPage();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            context.read<ModuleProvider>().currentModule.createForm!));
  }

  @override
  Widget build(BuildContext context) {
    final moduleProvider = context.read<ModuleProvider>();
    final bool isEditable = moduleProvider.pageSubmitStatus == 0 &&
        moduleProvider.currentModule.createForm != null;
    return isEditable
        ? IconButton(
            onPressed: () => editPage(context),
            splashRadius: DoublesManager.d_20,
            icon: const Icon(Icons.edit, color: Colors.black),
            tooltip: 'Edit',
          )
        : const SizedBox();
  }
}

class DownloadPdfButton extends StatelessWidget {
  const DownloadPdfButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: APPBAR_COLOR,
      child: InkWell(
        onTap: context.select<ModuleProvider, bool>(
                (value) => value.availablePdfFormat)
            ? () => context.read<ModuleProvider>().downloadPdf(context)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                StringsManager.download.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Icon(
                Icons.download,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrintPageButton extends StatelessWidget {
  const PrintPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final moduleProvider = context.read<ModuleProvider>();
    return Card(
      color: APPBAR_COLOR,
      child: InkWell(
        onTap: context.select<ModuleProvider, bool>(
                (value) => value.availablePdfFormat)
            ? () => context.read<PrinterCubit>().printInvoiceServices(
                  context: context,
                  id: moduleProvider.pageId,
                  docType: moduleProvider.currentModule.genericListService,
                  format: 'POS Arabic',
                )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                StringsManager.print.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Icon(
                Icons.print_sharp,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttachmentPageButton extends StatelessWidget {
  const AttachmentPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final moduleProvider = context.read<ModuleProvider>();
    return IconButton(
      onPressed: () => showAttachments(context),
      splashRadius: DoublesManager.d_20,
      icon: badges.Badge(
        badgeContent: Text(
          '${moduleProvider.pageData['attachments']?.length}',
          style:
              const TextStyle(fontSize: 13, color: Colors.black, height: 1.5),
        ),
        stackFit: StackFit.passthrough,
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Colors.redAccent,
          elevation: 0,
        ),
        showBadge: moduleProvider.pageData['attachments']?.length == null
            ? false
            : moduleProvider.pageData['attachments']?.length == 0
                ? false
                : true,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          child: const Icon(
            Icons.attach_file,
            color: Colors.black,
            size: 35,
          ),
        ),
      ),
      tooltip: 'Attachments',
    );
  }
}

class DuplicatePageButton extends StatelessWidget {
  const DuplicatePageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final provider = context.read<ModuleProvider>();
        provider.setDuplicateMode = true;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => provider.currentModule.createForm!));
      },
      icon: const Icon(
        Icons.copy,
        color: Colors.black,
        size: 35,
      ),
      tooltip: 'Duplicate',
      splashRadius: DoublesManager.d_20,
    );
  }
}

class ShareDocIcon extends StatelessWidget {
  const ShareDocIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: IconButton(
        color: APPBAR_COLOR,
        onPressed: () {
          AnimatedDialog.showAnimatedDialog(
            context,
            const ShareDocWidget(),
          );
        },
        icon: const Icon(
          Icons.ios_share_outlined,
          color: Colors.black,
          size: 35,
        ),
        tooltip: 'Share Doc',
        iconSize: DoublesManager.d_25,
        splashRadius: DoublesManager.d_20,
      ),
    );
  }
}
