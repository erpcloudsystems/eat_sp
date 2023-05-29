import 'package:flutter/material.dart';

import '../resources/strings_manager.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onPressed;

  const ErrorDialog({
    super.key,
    required this.errorMessage,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(errorMessage, softWrap: true),
      actions: [
        TextButton(
            onPressed: onPressed ?? () =>  Navigator.of(context).pop(),
            child: const Text(StringsManager.okay)),
      ],
    );
  }
}
