import 'package:flutter/material.dart';

import '../../../../../widgets/dismiss_keyboard.dart';

class NewSearchWidget extends StatefulWidget {
  const NewSearchWidget({super.key, required this.searchFunction});
  final Function(String value) searchFunction;

  @override
  State<NewSearchWidget> createState() => _NewSearchWidgetState();
}

class _NewSearchWidgetState extends State<NewSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Container(
        height: 40,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: TextField(
          onChanged: (value) {
            widget.searchFunction(value);
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: const EdgeInsets.only(
              left: 15,
              bottom: 7,
              top: 0,
              right: 15,
            ),
            disabledBorder: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}