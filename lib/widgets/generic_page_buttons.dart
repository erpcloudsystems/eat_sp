import 'package:expandable_menu/expandable_menu.dart';
import 'package:badges/badges.dart' as badges;
import 'package:NextApp/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/page/page_screen.dart';
import '../provider/module/module_provider.dart';
import '../new_version/core/resources/app_values.dart';
import '../new_version/core/utils/animated_dialog.dart';
import 'genric_page_widget/assgin_dialog.dart';
import 'genric_page_widget/share_doc_widget.dart';

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
          // backgroundColor: APPBAR_COLOR,

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
    return IconButton(
      onPressed: moduleProvider.pageSubmitStatus == 0 &&
              moduleProvider.currentModule.createForm != null
          ? () => editPage(context)
          : () {},
      splashRadius: DoublesManager.d_20,
      icon: Icon(
        Icons.edit,
        color: (context.read<ModuleProvider>().pageSubmitStatus == 0)
            ? Colors.black
            : Colors.black54,
      ),
      tooltip: 'Edit',
    );
  }
}

class DownloadPdfButton extends StatelessWidget {
  const DownloadPdfButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context
              .select<ModuleProvider, bool>((value) => value.availablePdfFormat)
          ? () => context.read<ModuleProvider>().downloadPdf(context)
          : null,
      splashRadius: DoublesManager.d_20,
      icon: const Icon(
        Icons.download,
        color: Colors.black,
        size: 35,
      ),
      tooltip: 'Download PDF',
    );
  }
}

class PrintPageButton extends StatelessWidget {
  const PrintPageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: context
              .select<ModuleProvider, bool>((value) => value.availablePdfFormat)
          ? () => context.read<ModuleProvider>().printPdf(context)
          : null,
      splashRadius: DoublesManager.d_20,
      icon: const Icon(
        Icons.print_sharp,
        color: Colors.black,
        size: 35,
      ),
      tooltip: 'Print',
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
        badgeColor: Colors.redAccent,
        elevation: 0,
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
