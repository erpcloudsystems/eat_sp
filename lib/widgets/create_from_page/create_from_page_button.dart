import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/module/module_provider.dart';

class CreateFromPageButton extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> items;
  final String? defaultValue;
  final String doctype;
  final bool? disableCreate;

  const CreateFromPageButton({
    Key? key,
    required this.items,
    required this.data,
    required this.doctype,
    this.disableCreate = false,
    this.defaultValue,
  }) : super(key: key);

  @override
  _CreateFromPageButtonState createState() => _CreateFromPageButtonState();
}

class _CreateFromPageButtonState extends State<CreateFromPageButton> {
  String? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  @override
  void didUpdateWidget(covariant CreateFromPageButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ModuleProvider>(context);
    widget.data['doctype'] = widget.doctype;
    return Container(
      height: 30,
      width: 110,
      margin: EdgeInsets.only(top: 0, left: 4),
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IgnorePointer(
        ignoring: widget.disableCreate ?? false,
        child: DropdownButton<String>(
            value: _value,
            borderRadius: BorderRadius.circular(5),
            underline: SizedBox(),
            alignment: Alignment.centerLeft,
            menuMaxHeight: 300,
            iconSize: 26,
            isDense: true,
            isExpanded: true,
            //iconDisabledColor:Colors.transparent,
            //iconEnabledColor:Colors.transparent,
            hint: Text(
              'Create'.tr(),
              style: TextStyle(
                  color: !(widget.disableCreate ?? false)
                      ? Colors.black87
                      : Colors.grey),
              textAlign: TextAlign.center,
            ),
            onChanged: (value) {
              if (value == null) return;
              _value = value;
              // InheritedForm.of(context).items.clear();

              context.read<ModuleProvider>().pushCreateFromPage(
                  pageData: widget.data, doctype: _value.toString());

              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (_) => widget.items[_value.toString()]))
                  .then((value) {
                provider.iAmCreatingAForm();
                provider.removeCreateFromPage();
              });
            },
            items: widget.items.keys
                .toList()
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: FittedBox(
                      child: Text(e, overflow: TextOverflow.ellipsis),
                    )))
                .toList()),
      ),
    );
  }
}
