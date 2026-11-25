import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';

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
    final l10n = context.l10n;
    final isMulti = widget.isMulti;

    return AlertDialog(
      title: Text(isMulti ? l10n.headingDownloadSelectedBooks : l10n.headingDownloadBook),
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
                title: Text(l10n.optionAudiobookAndEbook),
                secondary: const Icon(Icons.library_books),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                value: 'audiobook',
                title: Text(l10n.optionAudiobookOnly),
                secondary: const Icon(Icons.audiotrack),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                value: 'ebook',
                title: Text(l10n.optionEbookOnly),
                secondary: const Icon(Icons.book),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),
              const Divider(),
              CheckboxListTile(
                value: _rememberChoice,
                title: Text(l10n.optionRememberDownloadChoice),
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
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.actionCancel)),
        FilledButton(
          onPressed: () {
            Navigator.pop(context, DownloadTypeDialogResult(type: _selectedType, remember: _rememberChoice));
          },
          child: Text(l10n.actionDownload),
        ),
      ],
    );
  }
}
