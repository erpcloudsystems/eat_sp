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
  List getList = [];
  Future<void> handelCall() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);

    getList = await provider.generalGetList(docType: widget.docType);
    setState(() {});
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
        List<DropDownValueModel> dropDownList = getList.map((value) {
          return DropDownValueModel(
            name: value[widget.nameResponse],
            value: value[widget.nameResponse],
          );
        }).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            DropDownTextField(
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
                filled: true,
                //<-- SEE HERE
                fillColor: Colors.grey.shade200,
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                isDense: true,
                isCollapsed: false,
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.transparent,
                  ),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.red,
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.transparent,
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.red,
                  ),
                ),
                contentPadding: const EdgeInsets.all(5),
              ),
              listTextStyle: const TextStyle(
                color: Colors.black,
              ),
              enableSearch: true,
              dropDownItemCount: getList.length,
              dropDownList: dropDownList,
              onChanged: (val) {
                int index = dropDownList.indexWhere((item) => item == val);
                if (index != -1) {
                  Map<String, dynamic> selectedMap = getList[index];
                  widget.onChange(selectedMap);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
