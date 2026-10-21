import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/item_formatters.dart';

class LibraryItemFileInfoDialog extends ConsumerStatefulWidget {
  const LibraryItemFileInfoDialog({super.key, required this.itemId, required this.audioFile});

  final String itemId;
  final AudioFile audioFile;

  @override
  ConsumerState<LibraryItemFileInfoDialog> createState() => _LibraryItemFileInfoDialogState();
}

class _LibraryItemFileInfoDialogState extends ConsumerState<LibraryItemFileInfoDialog> {
  final _cancelToken = CancelToken();
  var _loading = false;
  String? _probe;
  String? _error;

  @override
  void dispose() {
    _cancelToken.cancel();
    super.dispose();
  }

  Future<void> _loadProbe() async {
    final api = ref.read(absApiProvider);
    final type = ref.read(currentUserProvider).value?.type.toLowerCase();
    if (api == null || _loading || (type != 'admin' && type != 'root')) {
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await api.getLibraryItemApi().getAudioFileFFProbeData(
        widget.itemId,
        widget.audioFile.ino,
        cancelToken: _cancelToken,
      );
      if (mounted) {
        setState(() {
          _probe = const JsonEncoder.withIndent('  ').convert(data);
        });
      }
    } catch (error) {
      if (mounted && !_cancelToken.isCancelled) {
        setState(() {
          _error = listManagementErrorMessage(error, fallback: 'Could not load FFprobe data.');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audio = widget.audioFile;
    final details = <(String, String)>[
      ('Path', audio.metadata.path),
      ('Size', formatBytes(audio.metadata.size)),
      if (audio.duration != null) ('Duration', formatDurationShort(Duration(seconds: audio.duration!.round()))),
      if (audio.format != null) ('Format', audio.format!),
      if (audio.codec != null) ('Codec', audio.codec!),
      if (audio.channels != null) ('Channels', '${audio.channels} ${audio.channelLayout ?? ''}'.trim()),
      if (audio.bitRate != null) ('Bitrate', '${(audio.bitRate! / 1000).toStringAsFixed(1)} kbps'),
      if (audio.timeBase != null) ('Time base', audio.timeBase!),
      if (audio.language != null) ('Language', audio.language!),
      ('Chapters', '${audio.chapters?.length ?? 0}'),
      if (audio.embeddedCoverArt != null) ('Embedded cover', audio.embeddedCoverArt!),
      ('Added', DateTime.fromMillisecondsSinceEpoch(audio.addedAt).toLocal().toString()),
      ('Modified', DateTime.fromMillisecondsSinceEpoch(audio.metadata.mtimeMs).toLocal().toString()),
    ];
    final probe = _probe;

    return AlertDialog(
      title: Text(audio.metadata.filename),
      content: SizedBox(
        width: 680,
        height: MediaQuery.sizeOf(context).height * 0.65,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final detail in details)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(detail.$1, style: Theme.of(context).textTheme.labelMedium),
                      SelectableText(detail.$2),
                    ],
                  ),
                ),
              if (audio.metaTags != null) ...[
                const SizedBox(height: 8),
                Text('Metadata tags', style: Theme.of(context).textTheme.titleSmall),
                SelectableText(const JsonEncoder.withIndent('  ').convert(audio.metaTags!.toJson())),
              ],
              const SizedBox(height: 12),
              if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              if (_loading) const LinearProgressIndicator(),
              if (probe != null) ...[
                Text('FFprobe data', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                SelectableText(probe),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (probe == null) TextButton(onPressed: _loading ? null : _loadProbe, child: const Text('Load FFprobe data')),
        if (probe != null)
          TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: probe)),
            child: const Text('Copy FFprobe data'),
          ),
        FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
      ],
    );
  }
}
