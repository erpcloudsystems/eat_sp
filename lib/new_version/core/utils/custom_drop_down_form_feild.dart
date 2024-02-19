import 'package:NextApp/new_version/core/resources/strings_manager.dart';
import 'package:NextApp/provider/new_controller/home_provider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../test/test_text_field.dart';
import 'new_list_widget.dart';

class CustomDropDownFromField extends StatefulWidget {
  const CustomDropDownFromField({
    super.key,
    required this.controller,
    required this.title,
    this.icon,
    this.isValidate = true,
    required this.onChange,
    required this.docType,
    required this.nameResponse,
  });
  final SingleValueDropDownController controller;
  final String title;
  final String docType;
  final String nameResponse;
  final IconData? icon;
  final Function(dynamic) onChange;
  final bool isValidate;

  @override
  State<CustomDropDownFromField> createState() =>
      _CustomDropDownFromFieldState();
}

class _CustomDropDownFromFieldState extends State<CustomDropDownFromField> {
  String selectedValue = '';
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
              initialValue: selectedValue,
              clearButton: true,
              keyboardType: TextInputType.number,
              onPressed: () async {
                _showMyDialog();
                return null;
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: NewListWidget(
            docType: widget.docType,
            nameResponse: widget.nameResponse,
            onPressed: (value) {
              widget.onChange(value);
              setState(() {
                selectedValue = value[widget.nameResponse];
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text(StringsManager.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
