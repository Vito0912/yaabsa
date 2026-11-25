import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/util/network/request_headers.dart';
import 'package:yaabsa/util/l10n.dart';

class SignInHeaderEntry {
  const SignInHeaderEntry({required this.name, required this.value});

  final String name;
  final String value;
}

Future<SignInHeaderEntry?> showSignInHeaderEditorDialog({
  required BuildContext context,
  required Map<String, String> existingHeaders,
  String? originalHeaderName,
}) {
  return showDialog<SignInHeaderEntry>(
    context: context,
    builder: (_) => _SignInHeaderEditorDialog(existingHeaders: existingHeaders, originalHeaderName: originalHeaderName),
  );
}

class _SignInHeaderEditorDialog extends StatefulWidget {
  const _SignInHeaderEditorDialog({required this.existingHeaders, this.originalHeaderName});

  final Map<String, String> existingHeaders;
  final String? originalHeaderName;

  @override
  State<_SignInHeaderEditorDialog> createState() => _SignInHeaderEditorDialogState();
}

class _SignInHeaderEditorDialogState extends State<_SignInHeaderEditorDialog> {
  // Owned by the dialog so they outlive the pop until its exit animation has
  // finished; disposing them when showDialog returns breaks the closing frames.
  late final TextEditingController _keyController = TextEditingController(text: widget.originalHeaderName ?? '');
  late final TextEditingController _valueController = TextEditingController(
    text: widget.originalHeaderName == null ? '' : (widget.existingHeaders[widget.originalHeaderName] ?? ''),
  );
  String? _dialogError;

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _save() {
    final key = _keyController.text.trim();
    final value = _valueController.text.trim();

    final validationError = validateServerHeader(name: key, value: _valueController.text);
    if (validationError != null) {
      setState(() {
        _dialogError = validationError;
      });
      return;
    }

    final hasDuplicate = widget.existingHeaders.keys.any(
      (existingKey) => existingKey.toLowerCase() == key.toLowerCase() && existingKey != widget.originalHeaderName,
    );
    if (hasDuplicate) {
      setState(() {
        _dialogError = context.l10n.authHeaderNameDuplicate;
      });
      return;
    }

    Navigator.of(context).pop(SignInHeaderEntry(name: key, value: value));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.originalHeaderName == null ? context.l10n.titleAddCustomHeader : context.l10n.titleEditCustomHeader,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StyledTextField(
            label: context.l10n.fieldHeaderName,
            controller: _keyController,
            autofocus: true,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.http_rounded),
          ),
          const SizedBox(height: 12),
          StyledTextField(
            label: context.l10n.fieldValue,
            controller: _valueController,
            prefixIcon: const Icon(Icons.key_rounded),
          ),
          if (_dialogError != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(_dialogError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(context.l10n.actionCancel)),
        FilledButton(onPressed: _save, child: Text(context.l10n.actionSave)),
      ],
    );
  }
}
