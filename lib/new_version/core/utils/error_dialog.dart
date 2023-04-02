import 'package:flutter/material.dart';

import '../resources/strings_manager.dart';

class ErrorDialog extends StatelessWidget {
  final String errorMessage;

  const ErrorDialog({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(errorMessage, softWrap: true),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(StringsManager.okay)),
      ],
    );
  }
}
