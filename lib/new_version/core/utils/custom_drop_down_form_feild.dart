import 'package:NextApp/provider/new_controller/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../screen/page/common_page_widgets/common_utils.dart';
import '../../../widgets/new_widgets/test_text_field.dart';
import 'new_list_widget.dart';

class CustomDropDownFromField extends StatefulWidget {
  const CustomDropDownFromField({
    super.key,
    required this.title,
    this.icon,
    this.isValidate = true,
    required this.onChange,
    required this.docType,
    required this.nameResponse,
    this.defaultValue,
    this.keys,
    this.filters,
    this.enable = true,
  });
  final String title;
  final String docType;
  final String? defaultValue;
  final String nameResponse;
  final IconData? icon;
  final Function(dynamic) onChange;
  final bool isValidate;
  final Map<String, dynamic>? keys;
  final Map<String, dynamic>? filters;
  final bool? enable;

  @override
  State<CustomDropDownFromField> createState() =>
      _CustomDropDownFromFieldState();
}

class _CustomDropDownFromFieldState extends State<CustomDropDownFromField> {
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFieldTest(
              'test',
              widget.title,
              initialValue: selectedValue ?? widget.defaultValue,
              clearButton: true,
              enabled: widget.enable,
              disableValidation: !widget.isValidate,
              onPressed: () async {
                CommonPageUtils.commonBottomSheet(
                  builderWidget: NewListWidget(
                    docType: widget.docType,
                    nameResponse: widget.nameResponse,
                    subTitleKey: widget.keys?['subTitle'],
                    trailingKey: widget.keys?['trailing'],
                    filter: widget.filters,
                    onPressed: (value) {
                      widget.onChange(value);

                      setState(() {
                        selectedValue = value[widget.nameResponse];
                      });
                    },
                  ),
                  context: context,
                );
                // _showMyDialog();
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}
