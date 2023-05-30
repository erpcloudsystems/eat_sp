import 'package:NextApp/core/cloud_system_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../provider/module/module_provider.dart';
import '../../service/service.dart';
import '../../service/service_constants.dart';
import '../snack_bar.dart';

class ActionWidget extends StatefulWidget {
  const ActionWidget({Key? key}) : super(key: key);

  @override
  State<ActionWidget> createState() => _ActionWidgetState();
}

class _ActionWidgetState extends State<ActionWidget> {
  var service = APIService();

  @override
  Widget build(BuildContext context) {
    return Consumer<ModuleProvider>(builder: (context, provider, child) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        margin: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: statusColor(provider.workflowStatus!).withOpacity(.8)),
              child: Text(
                provider.workflowStatus ?? 'none'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: 25.w,
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  if (provider.actionsList.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        insetPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.4,
                        ),
                        content: SizedBox(
                          height: provider.actionsList.length > 2 ? 100 : 60,
                          width: 30,
                          child: ListView.builder(
                            itemCount: provider.actionsList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  await handleRequest(
                                    () async => await service.patchRequest(
                                      UPDATE_WORKFLOW,
                                      {
                                        "doctype": provider.currentModule.title,
                                        "document_name": provider.pageId,
                                        "action": provider.actionsList[index],
                                      },
                                    ),
                                    context,
                                  ).whenComplete(
                                    () => Navigator.pop(context),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black,
                                  ),
                                  child: Center(
                                    child: Text(
                                      provider.actionsList[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ).whenComplete(
                      () => setState(
                        () {
                          provider.getActionList();
                          provider.getWorkflowStatus();
                        },
                      ),
                    );
                  } else {
                    showSnackBar(
                      'No action available',
                      context,
                    );
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: APPBAR_COLOR,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Action',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.compare_arrows,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
