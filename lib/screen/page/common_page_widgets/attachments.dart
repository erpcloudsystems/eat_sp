import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';
import '../../../service/service.dart';
import '../../../provider/user/user_provider.dart';
import '../../../provider/module/module_provider.dart';

void showAttachments(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(GLOBAL_BORDER_RADIUS))),
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
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(25)),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 6),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(GLOBAL_BORDER_RADIUS),
                          bottom: Radius.circular(5))),
                  child: context.read<ModuleProvider>().attachments.isEmpty
                      ? const Center(
                          child: Text('press + to add new attachment'))
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: context
                                .read<ModuleProvider>()
                                .attachments
                                .map((e) => Attachment(attachment: e))
                                .toList(),
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
                onTap: () => context
                    .read<ModuleProvider>()
                    .addAttachment(context)
                    .whenComplete(() => Navigator.pop(context)),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.blueGrey, shape: BoxShape.circle),
                    child: const Icon(
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

class Attachment extends StatelessWidget {
  final Map<String, dynamic> attachment;

  const Attachment({required this.attachment, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: TextButton(
        onPressed: () {
          APIService().openFile(
              url: context.read<UserProvider>().url + attachment['file_url'],
              fileName: attachment['file_name'],
              context: context);
        },
        style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
            elevation: 1,
            padding: EdgeInsets.zero),
        child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS),
              color: Colors.white),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(left: 8, right: 12),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(GLOBAL_BORDER_RADIUS)),
                child: const Icon(Icons.insert_drive_file_rounded,
                    color: Colors.white, size: 26),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(attachment['file_name']!,
                        style: const TextStyle(fontSize: 15)),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(attachment['date_added'] ?? tr('none'),
                          style: const TextStyle(color: Colors.grey)),
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
