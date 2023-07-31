import 'package:NextApp/new_version/core/resources/app_values.dart';
import 'package:NextApp/screen/list/otherLists.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../new_version/core/resources/strings_manager.dart';
import '../../../../test/test_text_field.dart';
import '../../../../widgets/form_widgets.dart';

class Group3 extends StatefulWidget {
  const Group3({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<Group3> createState() => _Group3State();
}

class _Group3State extends State<Group3> {
  
  /// Refers to quality_inspection_template 
  bool isQIT = false;

  @override
  Widget build(BuildContext context) {
    return Group(
      child: ListView(
        children: [
          //______________________ Quality Inspection Required_______________________
          Padding(
            padding: const EdgeInsets.symmetric(vertical: DoublesManager.d_5),
            child: CheckBoxWidget(
              'Inspection Required',
              StringsManager.qualityInspectionRequired.tr(),
              initialValue:
                  widget.data['Inspection Required'] == 1 ? true : false,
              onChanged: (id, value) => setState(
                () {
                  if (value == true) {
                    widget.data['Inspection Required'] = 1;
                    isQIT = true;
                  } else {
                    widget.data['Inspection Required'] = 0;
                    isQIT = false;
                  }
                },
              ),
            ),
          ),
          //_____________________________ Quality Inspection Template________________
             if(isQIT)
              Padding(
            padding: const EdgeInsets.symmetric(vertical: DoublesManager.d_5),
            child:CustomTextFieldTest(
                        'Quality Inspection Template',
                        StringsManager.qualityInspectionTemplate.tr(),
                        initialValue: widget.data['quality_inspection_template'],
                        disableValidation: true,
                        clearButton: true,
                        onChanged: (value) => widget.data['quality_inspection_template'] = value,
                        onSave: (key, value) => widget.data[key] = value,
                        onPressed: () async {
                          final res =
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => qualityInspectionTemplatesListScreen()));
                          widget.data['quality_inspection_template'] = res.itemCode;
                          return res.itemName;
                        },
                      ))
          //____________________________________ Materials______________________________
        ],
      ),
    );
  }
}
