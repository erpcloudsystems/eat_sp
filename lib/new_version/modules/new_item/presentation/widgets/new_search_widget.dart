import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../widgets/dismiss_keyboard.dart';

class NewSearchWidget extends StatefulWidget {
  const NewSearchWidget({super.key, required this.searchFunction});
  final Function(String value) searchFunction;

  @override
  State<NewSearchWidget> createState() => _NewSearchWidgetState();
}

class _NewSearchWidgetState extends State<NewSearchWidget> {
  Timer? debounceTimer;
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 12),
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
            // Clear the previous debounce timer
            debounceTimer?.cancel();

            // Set a new debounce timer
            debounceTimer = Timer(const Duration(milliseconds: 1000), () {
              widget.searchFunction(value);
            });
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Search".tr(),
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
