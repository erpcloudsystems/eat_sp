import 'package:NextApp/core/constants.dart';
import 'package:NextApp/provider/new_controller/home_provider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  Future<void> handelCall() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    await provider.generalGetList(docType: widget.docType);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      handelCall();
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        List<DropDownValueModel> dropDownList = provider.getList.map((value) {
          return DropDownValueModel(
            name: value[widget.nameResponse],
            value: value[widget.nameResponse],
          );
        }).toList();
        return DropDownTextField(
          controller: widget.controller,
          clearOption: true,
          validator: widget.isValidate
              ? (value) {
                  if (value!.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
          textFieldDecoration: InputDecoration(
            label: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: APPBAR_COLOR,
                  )
                : null,
          ),
          listTextStyle: const TextStyle(
            color: Colors.black,
          ),
          enableSearch: true,
          dropDownItemCount: provider.getList.length,
          dropDownList: dropDownList,
          onChanged: (val) {
            widget.onChange(val);
          },
        );
      },
    );
  }
}
