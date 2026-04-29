import 'package:flutter/material.dart';

class SignInHeaderEntry {
  const SignInHeaderEntry({required this.name, required this.value});

  final String name;
  final String value;
}

Future<SignInHeaderEntry?> showSignInHeaderEditorDialog({
  required BuildContext context,
  required Map<String, String> existingHeaders,
  String? originalHeaderName,
}) async {
  final keyController = TextEditingController(text: originalHeaderName ?? '');
  final valueController = TextEditingController(
    text: originalHeaderName == null ? '' : (existingHeaders[originalHeaderName] ?? ''),
  );

  try {
    return await showDialog<SignInHeaderEntry>(
      context: context,
      builder: (dialogContext) {
        String? dialogError;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(originalHeaderName == null ? 'Add Header' : 'Edit Header'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: keyController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Header Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: valueController,
                    decoration: const InputDecoration(labelText: 'Header Value'),
                  ),
                  if (dialogError != null) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(dialogError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    final key = keyController.text.trim();
                    final value = valueController.text.trim();

                    if (key.isEmpty || value.isEmpty) {
                      setDialogState(() {
                        dialogError = 'Header name and value are required.';
                      });
                      return;
                    }

                    final hasDuplicate = existingHeaders.keys.any(
                      (existingKey) =>
                          existingKey.toLowerCase() == key.toLowerCase() && existingKey != originalHeaderName,
                    );
                    if (hasDuplicate) {
                      setDialogState(() {
                        dialogError = 'A header with this name already exists.';
                      });
                      return;
                    }

                    Navigator.of(dialogContext).pop(SignInHeaderEntry(name: key, value: value));
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  } finally {
    keyController.dispose();
    valueController.dispose();
  }
}
