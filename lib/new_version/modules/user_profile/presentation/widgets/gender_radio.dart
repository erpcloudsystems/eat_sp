import 'package:flutter/material.dart';

import '../../../../core/resources/strings_manager.dart';

class GenderRadio extends StatefulWidget {
  final String userGender;
  final Function newGender;

  const GenderRadio(
      {super.key, required this.userGender, required this.newGender});

  @override
  State<GenderRadio> createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  @override
  void initState() {
    super.initState();
    selectedValue = widget.userGender;
  }

  late String selectedValue;

  void handleRadioValueChanged(String? value) {
    setState(() {
      selectedValue = value!;
      widget.newGender(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RadioListTile<String>(
            title: const Text(StringsManager.male),
            value: StringsManager.male,
            groupValue: selectedValue,
            onChanged: handleRadioValueChanged,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text(StringsManager.female),
            value: StringsManager.female,
            groupValue: selectedValue,
            onChanged: handleRadioValueChanged,
          ),
        ),
      ],
    );
  }
}
