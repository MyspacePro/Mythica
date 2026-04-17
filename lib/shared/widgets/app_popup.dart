import 'package:flutter/material.dart';

Future<void> showAppPopup({
  required BuildContext context,
  required String title,
  required String message,
  required String buttonText,
}) async {
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    ),
  );
}
