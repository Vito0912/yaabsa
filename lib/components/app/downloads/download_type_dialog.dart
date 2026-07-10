import 'package:flutter/material.dart';

class DownloadTypeDialogResult {
  final String type;
  final bool remember;

  const DownloadTypeDialogResult({required this.type, required this.remember});
}

class DownloadTypeDialog extends StatefulWidget {
  final bool isMulti;

  const DownloadTypeDialog({super.key, this.isMulti = false});

  @override
  State<DownloadTypeDialog> createState() => _DownloadTypeDialogState();
}

class _DownloadTypeDialogState extends State<DownloadTypeDialog> {
  String _selectedType = 'both';
  bool _rememberChoice = false;

  @override
  Widget build(BuildContext context) {
    final isMulti = widget.isMulti;

    return AlertDialog(
      title: Text(isMulti ? 'Download Selected Books' : 'Download Book'),
      content: SingleChildScrollView(
        child: RadioGroup<String>(
          groupValue: _selectedType,
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedType = val;
              });
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile<String>(
                value: 'both',
                title: const Text('Audiobook & Ebook'),
                secondary: const Icon(Icons.library_books),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                value: 'audiobook',
                title: const Text('Audiobook only'),
                secondary: const Icon(Icons.audiotrack),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                value: 'ebook',
                title: const Text('Ebook only'),
                secondary: const Icon(Icons.book),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              const Divider(),
              CheckboxListTile(
                value: _rememberChoice,
                title: const Text('Remember my choice'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() {
                    _rememberChoice = val ?? false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, DownloadTypeDialogResult(type: _selectedType, remember: _rememberChoice));
          },
          child: const Text('Download'),
        ),
      ],
    );
  }
}
