import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/audio_file_download_mode.dart';
import 'package:yaabsa/util/l10n.dart';

typedef AudioFileDownloadChoice = ({AudioFileDownloadMode mode, int fileCount, bool alwaysDownloadAll});

class AudioFileDownloadDialog extends StatefulWidget {
  const AudioFileDownloadDialog({super.key, required this.fileCount});

  final int fileCount;

  @override
  State<AudioFileDownloadDialog> createState() => _AudioFileDownloadDialogState();
}

class _AudioFileDownloadDialogState extends State<AudioFileDownloadDialog> {
  AudioFileDownloadMode _mode = AudioFileDownloadMode.all;
  late final _countController = TextEditingController(text: '${widget.fileCount < 4 ? widget.fileCount : 4}');
  bool _alwaysDownloadAll = false;
  String? _error;

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  void _download() {
    final l10n = context.l10n;
    final count = int.tryParse(_countController.text);
    if (_mode == AudioFileDownloadMode.custom && (count == null || count < 1 || count > widget.fileCount)) {
      setState(() => _error = l10n.errorWholeNumberRange(1, widget.fileCount));
      return;
    }
    Navigator.pop<AudioFileDownloadChoice>(context, (
      mode: _mode,
      fileCount: count ?? widget.fileCount,
      alwaysDownloadAll: _mode == AudioFileDownloadMode.all && _alwaysDownloadAll,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.headingDownloadAudioFiles),
      content: SingleChildScrollView(
        child: RadioGroup<AudioFileDownloadMode>(
          groupValue: _mode,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _mode = value;
                _error = null;
              });
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final mode in AudioFileDownloadMode.values)
                RadioListTile<AudioFileDownloadMode>(
                  value: mode,
                  title: Text(mode.label),
                  subtitle: switch (mode) {
                    AudioFileDownloadMode.all => Text(l10n.downloadAllAudioFilesDescription),
                    AudioFileDownloadMode.custom => Text(l10n.downloadCustomAudioFilesDescription),
                    AudioFileDownloadMode.fromCurrent => Text(l10n.downloadFromCurrentAudioFileDescription),
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              if (_mode == AudioFileDownloadMode.custom)
                StyledTextField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onSubmitted: (_) => _download(),
                  label: l10n.fieldAudioFileCount,
                  helperText: l10n.downloadAudioFileCountIncludesCurrent,
                  errorText: _error,
                ),
              if (_mode == AudioFileDownloadMode.all)
                CheckboxListTile(
                  value: _alwaysDownloadAll,
                  title: Text(l10n.settingDownloadAllAudioFiles),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) => setState(() => _alwaysDownloadAll = value ?? false),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.actionCancel)),
        FilledButton(onPressed: _download, child: Text(l10n.actionDownload)),
      ],
    );
  }
}
