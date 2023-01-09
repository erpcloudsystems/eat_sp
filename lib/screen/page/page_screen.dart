import 'dart:io';

import 'package:next_app/core/constants.dart';
import 'package:next_app/service/server_exception.dart';
import 'package:next_app/service/service.dart';
import 'package:next_app/service/service_constants.dart';
import 'package:next_app/provider/module/module_provider.dart';
import 'package:next_app/provider/user/user_provider.dart';
import 'package:next_app/widgets/snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../../widgets/dialog/loading_dialog.dart';

void showAttachments(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(GLOBAL_BORDER_RADIUS))),
    context: context,
    builder: (_) {
      return Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                width: 40,
                height: 8,
                decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(25)),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200, borderRadius: BorderRadius.vertical(top: Radius.circular(GLOBAL_BORDER_RADIUS), bottom: Radius.circular(5))),
                  child: context.read<ModuleProvider>().attachments.isEmpty
                      ? Center(child: Text('press + to add new attachment'))
                      : SingleChildScrollView(
          physics: BouncingScrollPhysics(),
                          child: Column(
                          children: context.read<ModuleProvider>().attachments.map((e) => Attachment(attachment: e)).toList(),
                        )),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: InkWell(
                onTap: () => context.read<ModuleProvider>().addAttachment(context),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.blueGrey, shape: BoxShape.circle),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 28,
                    )),
              ),
            ),
          )
        ],
      );
    },
  );
}

Widget submitDocument({required int docStatus, required void Function() onSubmitted, required String id, required String docType}) {
  switch (docStatus) {
    case (0):
      return SubmitButton();
    case (1):
      return CancelButton();
    case (2):
      return AmendButton();

    default:
      return SizedBox();
  }
}

class SubmitButton extends StatelessWidget {

  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: SUBMIT_BUTTON_COLOR, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS))),
        onPressed: () => context.read<ModuleProvider>().submitDocument(context),
        child: Text('Submit', style: const TextStyle(color: Colors.white, fontSize: 15)));
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: CANCEL_BUTTON_COLOR, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS))),
        onPressed: () => context.read<ModuleProvider>().cancelledDocument(context),
        child: Text('Cancel', style: const TextStyle(color: Colors.white, fontSize: 15)));
  }
}

class AmendButton extends StatelessWidget {
  const AmendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(primary: AMEND_BUTTON_COLOR, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS))),
        onPressed: () => null,
            //context.read<ModuleProvider>().cancelledDocument(context),
        child: Text('Amend', style: const TextStyle(color: Colors.white, fontSize: 15)));
  }
}

// Future<String?> selectPrintFormat(List<String> formats, String title) async {}

class SelectFormatDialog extends StatelessWidget {
  final List<String> formats;
  final String title;

  const SelectFormatDialog({Key? key, required this.formats, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            backgroundColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                ),
                Divider(color: Colors.grey, height: 5, thickness: 0.5),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (_, i) => InkWell(
                            onTap: () => Navigator.pop(context, formats[i]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(formats[i], style: const TextStyle(fontSize: 14.5)),
                                ),
                              ],
                            )),
                        separatorBuilder: (_, i) => Divider(height: 2, color: Colors.grey, thickness: 0.35),
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

class Attachment extends StatelessWidget {
  final Map<String, dynamic> attachment;

  const Attachment({required this.attachment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: TextButton(
        onPressed: () {
          APIService().openFile(url: context.read<UserProvider>().url + attachment['file_url'], fileName: attachment['file_name'], context: context);
        },
        style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)), elevation: 1, padding: EdgeInsets.zero),
        child: Ink(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS), color: Colors.white),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(left: 8, right: 12),
                decoration: BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
                child: Icon(Icons.insert_drive_file_rounded, color: Colors.white, size: 26),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(attachment['file_name']!, style: const TextStyle(fontSize: 15)),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(attachment['date_added'] ?? tr('none'), style: const TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PageAppBar extends StatefulWidget {
  final String docType;
  final String id;
  final ValueNotifier<List<Map<String, dynamic>>> attachments;
  final VoidCallback? onAttachmentAdded;
  final ValueNotifier<List<String>> pdfFormats;

  const PageAppBar({Key? key, required this.docType, required this.id, required this.pdfFormats, required this.attachments, this.onAttachmentAdded})
      : super(key: key);

  @override
  State<PageAppBar> createState() => _PageAppBarState();
}

class _PageAppBarState extends State<PageAppBar> {
  void refresh() => Future.delayed(Duration.zero).then((value) => setState(() {}));

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
      if (widget.pdfFormats.value.length == 1)
        APIService().printInvoice(context: context, docType: widget.docType, id: widget.id, format: widget.pdfFormats.value[0]);
      else {
        final format = await showDialog(context: context, builder: (_) => SelectFormatDialog(formats: widget.pdfFormats.value, title: 'Select Print Format'));
        if (format == null) return;
        APIService().printInvoice(context: context, docType: widget.docType, id: widget.id, format: format);
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
        var file;

        if (widget.pdfFormats.value.length == 1) {
          showLoadingDialog(context, 'Downloading PDF ...');
          file = await APIService().downloadFile(
            context.read<UserProvider>().url + '/api/' + PRINT_INVOICE,
            widget.id + '.pdf',
            queryParameters: {'doctype': widget.docType, 'name': widget.id, 'format': widget.pdfFormats.value[0]},
            path: null,
          );
        } else {
          final format = await showDialog(context: context, builder: (_) => SelectFormatDialog(formats: widget.pdfFormats.value, title: 'Select PDF Format'));
          if (format == null) return;
          showLoadingDialog(context, 'Downloading PDF ...');
          file = await APIService().downloadFile(
            context.read<UserProvider>().url + '/api/' + PRINT_INVOICE,
            '${widget.id}-$format' + '.pdf',
            queryParameters: {'doctype': widget.docType, 'name': widget.id, 'format': format},
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
        IconButton(onPressed: widget.pdfFormats.value.isEmpty ? null : downloadPdf, splashRadius: 20, icon: Icon(Icons.download)),
        IconButton(onPressed: widget.pdfFormats.value.isEmpty ? null : printPdf, splashRadius: 20, icon: Icon(Icons.print_sharp)),
        IconButton(
            onPressed: () => showAttachments(context), splashRadius: 20, icon: Icon(Icons.attach_file)),
      ],
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.black),
          style: TextButton.styleFrom(
            shape: CircleBorder(),
            // padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

//===================== draft ====================

class Choice {
  const Choice({required this.title, required this.icon, this.color, required this.onPressed});

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
            decoration: BoxDecoration(color: choice.color, borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
            child: Icon(choice.icon, color: Colors.white),
          ),
          SizedBox(width: 8),
          Text(choice.title, style: TextStyle(color: choice.onPressed == null ? Colors.grey : Colors.black))
        ],
      ));
}
