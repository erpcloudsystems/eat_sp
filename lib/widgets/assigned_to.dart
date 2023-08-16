import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../new_version/core/resources/app_values.dart';
import '../provider/module/module_provider.dart';
import '../models/page_models/model_functions.dart';

import '../core/constants.dart';
import '../provider/user/user_provider.dart';

const KBorderRadius = 18.0;

showAssignedTOSheet(BuildContext context) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) => AssignedToSheet(scaffoldContext: context));
}

class AssignedToSheet extends StatefulWidget {
  final BuildContext scaffoldContext;

  const AssignedToSheet({Key? key, required this.scaffoldContext})
      : super(key: key);

  @override
  State<AssignedToSheet> createState() => _AssignedToSheetState();
}

class _AssignedToSheetState extends State<AssignedToSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(widget.scaffoldContext).padding.top,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ClipRRect(
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(KBorderRadius)),
        child: ColoredBox(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: DoublesManager.d_50,
                color: Colors.grey.shade200, //APPBAR_COLOR,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    //_____________________ Navigation back Button______________________
                    Padding(
                      padding: const EdgeInsets.only(left: DoublesManager.d_16),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.black87,
                                size: 25,
                              ))),
                    ),
                    //___________________________ Header text______________________________________
                    Text(
                        "${(context.read<ModuleProvider>().pageData['_assign'] as List?)?.length} Assigns",
                        style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 15))
                  ],
                ),
              ),
              //___________________________ Header text______________________________________
              Expanded(
                child: ColoredBox(
                  color: Colors.transparent, //APPBAR_COLOR,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(KBorderRadius),
                      child: ((context
                                      .read<ModuleProvider>()
                                      .pageData['_assign'] as List?) ??
                                  [])
                              .isEmpty
                          ? const Center(
                              child: Text('No Assigns',
                                  style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 0),
                              itemCount: (context
                                          .read<ModuleProvider>()
                                          .pageData['_assign'] as List?)
                                      ?.length ??
                                  0,
                              itemBuilder: (_, index) => AssignedBubble(
                                context
                                    .read<ModuleProvider>()
                                    .pageData['_assign'][index],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignedBubble extends StatelessWidget {
  final Map<String, dynamic> assignObject;

  const AssignedBubble(this.assignObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
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
            radius: 24,
            child: Text(
              //TODO: Data base Key
              assignObject['owner']!.toString()[0],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //____________________ Name Or Header ______________________________
                      Text(
                        // TODO: Database Key.
                        assignObject['owner']!.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                        ),
                      ),
                      //____________________ Right Text ______________________________
                      Text(
                          // TODO: Database Key.
                          DateFormat("d/M/y  h:mm a").format(DateTime.parse(
                              assignObject['creation']!.toString())),
                          style: const TextStyle(
                              fontSize: 12,
                              height: 1.6,
                              color: Colors.black54)),
                    ],
                  ),
                ),
                //____________________ Subtitle ______________________________
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    formatDescription(assignObject['content'].toString()),
                    style: const TextStyle(
                        height: 1.5, fontWeight: FontWeight.w300),
                  ),
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
