import 'package:flutter/material.dart';

Future<T> runWithLoadingSnackBar<T>({
  required BuildContext context,
  required String message,
  required Future<T> Function() action,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  messenger.showSnackBar(
    SnackBar(
      duration: const Duration(days: 1),
      content: Row(
        children: [
          const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2)),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    ),
  );

  try {
    return await action();
  } finally {
    if (context.mounted) {
      messenger.hideCurrentSnackBar();
    }
  }
}
