import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../list/otherLists.dart';
import '../../../../widgets/form_widgets.dart';
import '../../../../test/test_text_field.dart';
import '../../../../new_version/core/resources/strings_manager.dart';

class JobCardGroup3 extends StatelessWidget {
  const JobCardGroup3({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Group(
      child: ListView(
        children: [
          //_______________________________________Workstation_____________________________________________________
          CustomTextFieldTest('workstation', StringsManager.workstation.tr(),
              initialValue: data['workstation'],
              clearButton: true,
              onSave: (key, value) => data['workstation'] = value,
              onPressed: () async => await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => workstationListScreen()))),
          //_______________________________________Employee_____________________________________________________
          CustomTextFieldTest(
            'employee',
            StringsManager.employee.tr(),
            initialValue: data['employee'],
            onPressed: () async {
              String? id;
              final res = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => selectEmployeeScreen()));
              if (res != null) {
                id = res['name'];
              }
              return id;
            },
          ),
          // //_______________________________________Work Order_____________________________________________________
          // CustomTextFieldTest('wip_warehouse', StringsManager.wipWarehouse,
          //     initialValue: widget.data['wip_warehouse'],
          //     liestenToInitialValue: true,
          //     onSave: (key, value) => widget.data[key] = value,
          //     onPressed: () async {
          //       final res = await Navigator.of(context)
          //           .push(MaterialPageRoute(builder: (_) => warehouseScreen()));
          //       if (res != null) widget.data['wip_warehouse'] = res;
          //       return res;
          //     }),
          // //_____________________________ Quality Inspection Template________________
          // CustomTextFieldTest(
          //   'Quality Inspection Template',
          //   StringsManager.qualityInspectionTemplate.tr(),
          //   initialValue: widget.data['quality_inspection_template'],
          //   disableValidation: true,
          //   clearButton: true,
          //   onChanged: (value) =>
          //       widget.data['quality_inspection_template'] = value,
          //   onSave: (key, value) => widget.data[key] = value,
          //   onPressed: () async {
          //     final res = await Navigator.of(context).push(MaterialPageRoute(
          //         builder: (_) => qualityInspectionTemplatesListScreen()));
          //     widget.data['quality_inspection_template'] = res.itemCode;
          //     return res.itemName;
          //   },
          // ),
          // //_______________________________________Project_____________________________________________________
          // CustomTextFieldTest(
          //   'project',
          //   StringsManager.project.tr(),
          //   initialValue: widget.data['project'],
          //   disableValidation: true,
          //   clearButton: true,
          //   onSave: (key, value) => widget.data[key] = value,
          //   onPressed: () async {
          //     final res = await Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (_) => projectScreen()));
          //     return res['name'];
          //   },
          // ),
          // //_______________________________________Batch No._____________________________________________________
          // CustomTextFieldTest(
          //   'batch_no',
          //   StringsManager.batchNo,
          //   initialValue: widget.data['batch_no'],
          //   disableValidation: true,
          //   clearButton: true,
          //   onChanged: (value) => widget.data['batch_no'] = value,
          //   onSave: (key, value) => widget.data[key] = value,
          //   onPressed: () async {
          //     final res = await Navigator.of(context).push(MaterialPageRoute(
          //         builder: (_) => qualityInspectionTemplatesListScreen()));
          //     widget.data['quality_inspection_template'] = res.itemCode;
          //     return res.itemName;
          //   },
          // ),
        ],
      ),
    );
  }
}
