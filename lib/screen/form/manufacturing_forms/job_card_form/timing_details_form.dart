import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants.dart';
import '../../../../new_version/core/resources/app_values.dart';
import '../../../../provider/module/module_provider.dart';
import '../../../../widgets/page_group.dart';
import 'timing_details_dialog.dart';

class TimingDetailsForm extends StatefulWidget {
  const TimingDetailsForm({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<TimingDetailsForm> createState() => _TimingDetailsFormState();
}

class _TimingDetailsFormState extends State<TimingDetailsForm> {
  @override
  void deactivate() {
    super.deactivate();
    Provider.of<ModuleProvider>(context, listen: false).clearTimeSheet = [];
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ModuleProvider>();
    List? timeLogs = widget.data['time_logs'];
    List timeSheetData = provider.getTimeSheetData;
    widget.data['time_logs'] = timeSheetData;
    if (provider.isEditing ||
        provider.isAmendingMode ||
        provider.duplicateMode) {
      timeLogs?.map((e) {
            provider.setTimeSheet = e;
          }).toList() ??
          [];
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringsManager.addTimeLog.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  bottomSheetBuilder(
                    bottomSheetView: TimingDetailsDialog(),
                    context: context,
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DoublesManager.d_8),
                    ),
                  ),
                ),
                child: const Icon(Icons.add),
              )
            ],
          ),
        ),

        /// Time Logs list

        Consumer<ModuleProvider>(
          builder: (context, module, child) => SizedBox(
            height: 190,
            child: ListView.builder(
              itemCount: module.getTimeSheetData.length,
              itemBuilder: (context, index) {
                final timeData = module.getTimeSheetData;
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: PageCard(
                        items: [
                          {
                            StringsManager.employee.tr():
                                timeData[index]['employee'] ?? 'none',
                            StringsManager.completedQuantity.tr():
                                (timeData[index]['completed_qty'] ?? '0')
                                    .toString(),
                          }
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => timeData.removeAt(index));
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
