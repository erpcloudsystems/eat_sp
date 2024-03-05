import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../list/otherLists.dart';
import '../../../../widgets/form_widgets.dart';
import '../../../../widgets/new_widgets/test_text_field.dart';
import '../../../../new_version/core/resources/strings_manager.dart';

class JobCardGroup2 extends StatelessWidget {
  const JobCardGroup2({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Group(
      child: ListView(
        children: [
          //_______________________________________Quantity_____________________________________________________
          CustomTextFieldTest(
            'for_quantity',
            StringsManager.qtyToManufacture.tr(),
            disableValidation: false,
            initialValue: data['for_quantity']?.toString(),
            validator: (value) => numberValidation(value, allowNull: false),
            keyboardType: TextInputType.number,
            onSave: (key, value) =>
                data['for_quantity'] = double.tryParse(value),
            onChanged: (value) => data['for_quantity'] = double.tryParse(value),
          ),
          //_______________________________________Posting Date_____________________________________________________
          DatePickerTest('posting_date', StringsManager.postingDate.tr(),
              initialValue: data['posting_date'],
              disableValidation: true,
              onChanged: (value) => data['posting_date'] = value),
          //_______________________________________Work Order_____________________________________________________
          CustomTextFieldTest('wip_warehouse', StringsManager.wipWarehouse,
              initialValue: data['wip_warehouse'],
              liestenToInitialValue: true,
              onSave: (key, value) => data[key] = value,
              onPressed: () async {
                final res = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => warehouseScreen()));
                if (res != null) data['wip_warehouse'] = res;
                return res;
              }),
          //_____________________________ Quality Inspection Template________________
          CustomTextFieldTest(
            'quality_inspection_template',
            StringsManager.qualityInspectionTemplate.tr(),
            initialValue: data['quality_inspection_template'],
            disableValidation: true,
            clearButton: true,
            onChanged: (value) => data['quality_inspection_template'] = value,
            onSave: (key, value) => data[key] = value,
            onPressed: () async {
              final res = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => qualityInspectionTemplatesListScreen()));
              if (res != null) data['quality_inspection_template'] = res;
              return res;
            },
          ),
          //_______________________________________Project_____________________________________________________
          CustomTextFieldTest(
            'project',
            StringsManager.project.tr(),
            initialValue: data['project'],
            disableValidation: true,
            clearButton: true,
            onSave: (key, value) => data[key] = value,
            onPressed: () async {
              final res = await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => projectScreen()));
              if (res != null) data['project'] = res['name'];
              return res['name'];
            },
          ),
          //_______________________________________Batch No._____________________________________________________
          CustomTextFieldTest('batch_no', StringsManager.batchNo,
              initialValue: data['batch_no'],
              disableValidation: true,
              clearButton: true,
              onChanged: (value) => data['batch_no'] = value,
              onSave: (key, value) => data[key] = value,
              onPressed: () async {
                final res = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => batchNoListScreen()));
                if (res != null) data['batch_no'] = res;
                return res;
              }),
        ],
      ),
    );
  }
}
