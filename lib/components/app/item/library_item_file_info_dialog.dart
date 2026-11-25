import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

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
          _error = listManagementErrorMessage(error, fallback: context.l10n.errorLoadFfprobeDataFailed);
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
    final l10n = context.l10n;
    final locale = l10n.localeName;
    final details = <(String, String)>[
      (l10n.fieldFilePath, audio.metadata.path),
      (l10n.fieldSize, formatBytes(audio.metadata.size, localizations: l10n)),
      if (audio.duration != null) (l10n.fieldDuration, formatDurationShort(Duration(seconds: audio.duration!.round()))),
      if (audio.format != null) (l10n.fieldFormat, audio.format!),
      if (audio.codec != null) (l10n.fieldCodec, audio.codec!),
      if (audio.channels != null)
        (
          l10n.fieldChannels,
          '${NumberFormat.decimalPattern(locale).format(audio.channels)} ${audio.channelLayout ?? ''}'.trim(),
        ),
      if (audio.bitRate != null)
        (
          l10n.fieldBitrate,
          '${NumberFormat.decimalPatternDigits(locale: locale, decimalDigits: 1).format(audio.bitRate! / 1000)} kbps',
        ),
      if (audio.timeBase != null) (l10n.fieldTimeBase, audio.timeBase!),
      if (audio.language != null) (l10n.fieldLanguage, audio.language!),
      (l10n.navChapters, NumberFormat.decimalPattern(locale).format(audio.chapters?.length ?? 0)),
      if (audio.embeddedCoverArt != null) (l10n.fieldEmbeddedCover, audio.embeddedCoverArt!),
      (
        l10n.dateAdded,
        DateFormat.yMd(locale).add_Hm().format(DateTime.fromMillisecondsSinceEpoch(audio.addedAt).toLocal()),
      ),
      (
        l10n.dateModified,
        DateFormat.yMd(locale).add_Hm().format(DateTime.fromMillisecondsSinceEpoch(audio.metadata.mtimeMs).toLocal()),
      ),
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
                Text(l10n.headingMetadataTags, style: Theme.of(context).textTheme.titleSmall),
                SelectableText(const JsonEncoder.withIndent('  ').convert(audio.metaTags!.toJson())),
              ],
              const SizedBox(height: 12),
              if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              if (_loading) const YaabsaLinearProgressIndicator(),
              if (probe != null) ...[
                Text(l10n.headingFfprobeData, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                SelectableText(probe),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (probe == null) TextButton(onPressed: _loading ? null : _loadProbe, child: Text(l10n.actionLoadFfprobeData)),
        if (probe != null)
          TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: probe)),
            child: Text(l10n.actionCopyFfprobeData),
          ),
        FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.actionClose)),
      ],
    );
  }
}
