import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../provider/module/module_provider.dart';
import '../../screen/form/selling_forms/customer_form.dart';

class CreateFromPageButton extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> items;
  final String? defaultValue;

  const CreateFromPageButton({
    Key? key,
    required this.items,
    required this.data,
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

    return Container(
      height: 30,
     // width: 120,
      margin: EdgeInsets.only(top: 0,left: 4),
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
           value: _value,
          borderRadius: BorderRadius.circular(5),
          underline: SizedBox(),
          alignment:Alignment.center,
          menuMaxHeight: 300,
          iconSize:26,
          isDense:true,
          isExpanded:false,
          hint: Text('Create'.tr(),style: TextStyle(color: Colors.black87),textAlign: TextAlign.center,),
          onChanged: (value) {
            if (value == null) return;
            _value = value;
            context
                .read<ModuleProvider>()
                .pushCreateFromPage(pageData: widget.data, doctype: _value.toString());

            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => widget.items[_value.toString()]))
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
    );
  }
}
