import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:yaabsa/generated/l10n.dart';

class ListManagementFormResult {
  const ListManagementFormResult({required this.name, this.description});

  final String name;
  final String? description;
}

Future<ListManagementFormResult?> showListManagementFormDialog({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  String? initialName,
  String? initialDescription,
  String? helperText,
}) {
  return showDialog<ListManagementFormResult>(
    context: context,
    builder: (dialogContext) {
      return _ListManagementFormDialog(
        title: title,
        confirmLabel: confirmLabel,
        initialName: initialName,
        initialDescription: initialDescription,
        helperText: helperText,
      );
    },
  );
}

Future<bool> showListManagementDeleteDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(S.current.componentsCommonListManagementDialogsCancel),
          ),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(confirmLabel)),
        ],
      );
    },
  );

  return result ?? false;
}

String listManagementErrorMessage(Object error, {required String fallback}) {
  if (error is DioException) {
    final responseData = error.response?.data;
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData.trim();
    }

    if (responseData is Map) {
      final message = responseData['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final errorText = responseData['error'];
      if (errorText is String && errorText.trim().isNotEmpty) {
        return errorText.trim();
      }
    }
  }

  return fallback;
}

class _ListManagementFormDialog extends StatefulWidget {
  const _ListManagementFormDialog({
    required this.title,
    required this.confirmLabel,
    this.initialName,
    this.initialDescription,
    this.helperText,
  });

  final String title;
  final String confirmLabel;
  final String? initialName;
  final String? initialDescription;
  final String? helperText;

  @override
  State<_ListManagementFormDialog> createState() => _ListManagementFormDialogState();
}

class _ListManagementFormDialogState extends State<_ListManagementFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _showValidationErrors = false;

  bool get _isNameValid => _nameController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _descriptionController = TextEditingController(text: widget.initialDescription ?? '');
    _nameController.addListener(_handleFormFieldChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleFormFieldChanged);
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleFormFieldChanged() {
    setState(() {});
  }

  void _submit() {
    if (!_isNameValid) {
      setState(() {
        _showValidationErrors = true;
      });
      return;
    }

    final description = _descriptionController.text.trim();

    Navigator.of(context).pop(
      ListManagementFormResult(
        name: _nameController.text.trim(),
        description: description.isEmpty ? null : description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.helperText != null && widget.helperText!.trim().isNotEmpty) ...[
                Text(
                  widget.helperText!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: _nameController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: S.current.componentsCommonListManagementDialogsName,
                  errorText: _showValidationErrors && !_isNameValid ? 'Name is required.' : null,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  labelText: S.current.componentsCommonListManagementDialogsDescription,
                  hintText: S.current.componentsCommonListManagementDialogsOptional,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.current.componentsCommonListManagementDialogsCancel),
        ),
        FilledButton(onPressed: _isNameValid ? _submit : null, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
