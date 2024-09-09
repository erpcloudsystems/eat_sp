import 'dart:io';
import 'package:NextApp/new_version/modules/printer/controller/cubit/printer_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../service/service.dart';
import '../../widgets/snack_bar.dart';
import '../../service/server_exception.dart';
import '../../service/service_constants.dart';
import '../../provider/user/user_provider.dart';
import '../../widgets/dialog/loading_dialog.dart';
import '../../provider/module/module_provider.dart';
import 'common_page_widgets/attachments.dart';

Widget submitDocument({
  required int docStatus,
  required void Function() onSubmitted,
  required String id,
  required String docType,
}) {
  switch (docStatus) {
    case (0):
      return const SubmitButton();
    case (1):
      return const CancelButton();
    case (2):
      return const AmendButton();

    default:
      return const SizedBox();
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: SUBMIT_BUTTON_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS))),
        onPressed: () => context.read<ModuleProvider>().submitDocument(context),
        child: Text('Submit'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 15)));
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: CANCEL_BUTTON_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS))),
        onPressed: () =>
            context.read<ModuleProvider>().cancelledDocument(context),
        child: Text('Cancel'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 15)));
  }
}

class AmendButton extends StatelessWidget {
  const AmendButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: AMEND_BUTTON_COLOR,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS))),
        onPressed: () {
          Provider.of<ModuleProvider>(context, listen: false).amendDoc = true;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  context.read<ModuleProvider>().currentModule.createForm!));
        },
        child: Text('Amend'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 15)));
  }
}

class SelectFormatDialog extends StatelessWidget {
  final List<String> formats;
  final String title;

  const SelectFormatDialog(
      {super.key, required this.formats, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          child: Dialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                      child: Text(title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold))),
                ),
                const Divider(color: Colors.grey, height: 5, thickness: 0.5),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, i) => InkWell(
                            onTap: () => Navigator.pop(context, formats[i]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(formats[i],
                                      style: const TextStyle(fontSize: 14.5)),
                                ),
                              ],
                            )),
                        separatorBuilder: (_, i) => const Divider(
                            height: 2, color: Colors.grey, thickness: 0.35),
                        itemCount: formats.length),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class PageAppBar extends StatefulWidget {
  final String docType;
  final String id;
  final ValueNotifier<List<Map<String, dynamic>>> attachments;
  final VoidCallback? onAttachmentAdded;
  final ValueNotifier<List<String>> pdfFormats;

  const PageAppBar({
    super.key,
    required this.docType,
    required this.id,
    required this.pdfFormats,
    required this.attachments,
    this.onAttachmentAdded,
  });

  @override
  State<PageAppBar> createState() => _PageAppBarState();
}

class _PageAppBarState extends State<PageAppBar> {
  void refresh() =>
      Future.delayed(Duration.zero).then((value) => setState(() {}));

  @override
  void initState() {
    widget.pdfFormats.addListener(refresh);
    super.initState();
  }

  @override
  void dispose() {
    widget.pdfFormats.removeListener(refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void printPdf() async {
      if (widget.pdfFormats.value.length == 1) {
        context.read<PrinterCubit>().printInvoiceServices(
            context: context,
            docType: widget.docType,
            id: widget.id,
            format: 'POS Arabic');
      } else {
        final format = await showDialog(
            context: context,
            builder: (_) => SelectFormatDialog(
                formats: widget.pdfFormats.value,
                title: 'Select Print Format'));
        if (format == null) return;
        context.read<PrinterCubit>().printInvoiceServices(
            context: context,
            docType: widget.docType,
            id: widget.id,
            format: format);
      }
    }

    // Future<String?> downloadsPath() async {
    //   try {
    //     // return await DownloadsPathProvider.downloadsDirectory;
    //     // return await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    //   } on PlatformException {
    //     print('Could not get the downloads directory');
    //   }
    // }

    void downloadPdf() async {
      //make sure for storage permission
      if (!context.read<UserProvider>().storageAccess) {
        await context.read<UserProvider>().checkPermission();

        //return if it's not guaranteed
        if (!context.read<UserProvider>().storageAccess) {
          showSnackBar('Storage Access Required!', context, color: Colors.red);
          return;
        }
      }

      try {
        // final _localPath = '/storage/emulated/0/download/ERPCloud.systems/${widget.docType}';
        // final Directory savedDir = Directory(_localPath)..createSync();
        // bool hasExisted = savedDir.existsSync();
        // // if (true) {
        //   print('creating directory');
        // savedDir.createSync();
        // savedDir.listSync();
        // // }
        // print(_localPath);
        // hold out the response
        File? file;

        if (widget.pdfFormats.value.length == 1) {
          showLoadingDialog(context, 'Downloading PDF ...');
          file = await APIService().downloadFile(
            '${context.read<UserProvider>().url}/api/$PRINT_INVOICE',
            '${widget.id}.pdf',
            queryParameters: {
              'doctype': widget.docType,
              'name': widget.id,
              'format': widget.pdfFormats.value[0]
            },
            path: null,
          );
        } else {
          final format = await showDialog(
              context: context,
              builder: (_) => SelectFormatDialog(
                  formats: widget.pdfFormats.value,
                  title: 'Select PDF Format'));
          if (format == null) return;
          showLoadingDialog(context, 'Downloading PDF ...');
          file = await APIService().downloadFile(
            '${context.read<UserProvider>().url}/api/$PRINT_INVOICE',
            '${widget.id}-$format' '.pdf',
            queryParameters: {
              'doctype': widget.docType,
              'name': widget.id,
              'format': format
            },
            path: null,
          );
        }
        Navigator.pop(context);
        if (file is File) OpenFile.open(file.path);
        // showSnackBar('checkout: downloads/ERPCloud.systems/${widget.docType}', context);
      } on ServerException catch (e) {
        print(e);
        Navigator.pop(context);
        showSnackBar(e.message, context, color: Colors.red);
      } on PlatformException catch (e) {
        print(e);
        Navigator.pop(context);
        showSnackBar('Could\'t save file!', context, color: Colors.red);
      } catch (e) {
        print(e);
        Navigator.pop(context);
        showSnackBar('something went wrong!', context, color: Colors.red);
      }
    }

    return AppBar(
      title: Text(widget.docType),
      actions: [
        IconButton(
            onPressed: widget.pdfFormats.value.isEmpty ? null : downloadPdf,
            splashRadius: 20,
            icon: const Icon(Icons.download)),
        IconButton(
            onPressed: widget.pdfFormats.value.isEmpty ? null : printPdf,
            splashRadius: 20,
            icon: const Icon(Icons.print_sharp)),
        IconButton(
            onPressed: () => showAttachments(context),
            splashRadius: 20,
            icon: const Icon(Icons.attach_file)),
      ],
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
            // padding: EdgeInsets.zero,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }
}

//===================== draft ====================

class Choice {
  const Choice(
      {required this.title,
      required this.icon,
      this.color,
      required this.onPressed});

  final String title;
  final IconData icon;
  final Color? color;
  final void Function(BuildContext context)? onPressed;
}

PopupMenuItem<Choice> choiceItem(Choice choice) {
  return PopupMenuItem<Choice>(
      value: choice,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: choice.color,
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
            child: Icon(choice.icon, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(choice.title,
              style: TextStyle(
                  color: choice.onPressed == null ? Colors.grey : Colors.black))
        ],
      ));
}
