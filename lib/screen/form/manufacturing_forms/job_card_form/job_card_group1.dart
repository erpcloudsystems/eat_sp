import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../models/list_models/manufacturing_list_model/work_order_model.dart';
import '../../../list/otherLists.dart';
import '../../../../widgets/form_widgets.dart';
import '../../../../test/test_text_field.dart';
import '../../../../new_version/core/resources/strings_manager.dart';

class JobCardGroup1 extends StatefulWidget {
  const JobCardGroup1({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<JobCardGroup1> createState() => _JobCardGroup1State();
}

class _JobCardGroup1State extends State<JobCardGroup1> {
  WorkOrderItemModel? workOrder;

  @override
  void initState() {
    super.initState();
    workOrder = widget.data['work_order'];
  }

  @override
  Widget build(BuildContext context) {
    return Group(
      child: ListView(
        children: [
          //_______________________________________Company_____________________________________________________
          CustomTextFieldTest('company', StringsManager.company.tr(),
              initialValue: widget.data['company'],
              onSave: (key, value) => widget.data[key] = value,
              onPressed: () async {
                final res = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => companyListScreen()));
                widget.data['company'] = res['name'];
                return res['name'];
              }),
          //_______________________________________Work Order_____________________________________________________
          CustomTextFieldTest(
            'work_order',
            StringsManager.workOrder.tr(),
            initialValue: widget.data['work_order'],
            disableValidation: false,
            clearButton: true,
            onClear: () => setState(() {
              workOrder = null;
              widget.data['item_name'] = null;
            }),
            onChanged: (value) => widget.data['work_order'] = value,
            onSave: (key, value) => widget.data[key] = value,
            onPressed: () async {
              final WorkOrderItemModel res = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => workOrderListScreen()));
              widget.data['work_order'] = res.name;
              setState(() => workOrder = res);
              return res.name;
            },
          ),
          //_______________________________________BOM No._____________________________________________________
          if (widget.data['bom_no'] != null || workOrder != null)
            CustomTextFieldTest(
              'bom_no',
              StringsManager.bomNo,
              initialValue: widget.data['bom_no'] ?? workOrder?.bomNo,
              enabled: false,
              onChanged: (value) => widget.data['bom_no'] = value,
              onSave: (key, value) => widget.data[key] = value,
            ),
          //_______________________________________Item Name_____________________________________________________
          if (widget.data['item_name'] != null || workOrder != null)
            CustomTextFieldTest(
              'item_name',
              StringsManager.itemName.tr(),
              initialValue: widget.data['item_name'] ?? workOrder?.itemName,
              enabled: false,
              onChanged: (value) => widget.data['item_name'] = value,
              onSave: (key, value) => widget.data[key] = value,
            ),
          //_______________________________________Production Item_____________________________________________________
          if (widget.data['production_item'] != null || workOrder != null)
            CustomTextFieldTest(
              'production_item',
              StringsManager.productionItem.tr(),
              initialValue:
                  widget.data['production_item'] ?? workOrder?.productionItem,
              enabled: false,
              onChanged: (value) => widget.data['production_item'] = value,
              onSave: (key, value) => widget.data[key] = value,
            ),
          //_____________________Operation_____________________________________
          if (widget.data['operation'] != null || workOrder != null)
            CustomTextFieldTest(
              'operation',
              StringsManager.operation.tr(),
              initialValue: widget.data['operation'],
              //TODO: enable validation after finishing backend side logic.
              disableValidation: true,
              clearButton: true,
              onSave: (key, value) => widget.data['operation'] = value,
              onPressed: () async {
                final res = await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        operationsListScreen(workOrderId: workOrder?.name)));
                return res;
              },
            ),
        ],
      ),
    );
  }
}
