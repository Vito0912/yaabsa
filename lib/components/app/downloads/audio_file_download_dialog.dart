import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/audio_file_download_mode.dart';

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
    final count = int.tryParse(_countController.text);
    if (_mode == AudioFileDownloadMode.custom && (count == null || count < 1 || count > widget.fileCount)) {
      setState(() => _error = 'Enter a number from 1 to ${widget.fileCount}');
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
    return AlertDialog(
      title: const Text('Download audio files'),
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
                    AudioFileDownloadMode.all => const Text('Download the entire audiobook'),
                    AudioFileDownloadMode.custom => const Text(
                      'Choose how many files to download from the current file',
                    ),
                    AudioFileDownloadMode.fromCurrent => const Text('Download earlier files after the last file'),
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              if (_mode == AudioFileDownloadMode.custom)
                TextField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Number of files',
                    helperText: 'Includes the current file',
                    errorText: _error,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _download(),
                ),
              if (_mode == AudioFileDownloadMode.all)
                CheckboxListTile(
                  value: _alwaysDownloadAll,
                  title: const Text('Always download all audio files'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (value) => setState(() => _alwaysDownloadAll = value ?? false),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _download, child: const Text('Download')),
      ],
    );
  }
}
