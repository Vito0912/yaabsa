import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/util/item_formatters.dart';

final double textfieldWidth = 130;

class LibraryItemEncoderView extends StatelessWidget {
  const LibraryItemEncoderView({
    super.key,
    required this.audioFiles,
    required this.advancedMode,
    required this.codec,
    required this.bitrate,
    required this.channels,
    required this.isStarting,
    required this.isTaskRunning,
    required this.isCanceling,
    this.currentEncodingHint,
    required this.onAdvancedModeChanged,
    required this.onCodecChanged,
    required this.onBitrateChanged,
    required this.onChannelsChanged,
    required this.onStartEncoding,
    required this.onCancelEncoding,
    this.encodingProgressByIno = const <String, String>{},
    this.encodingFinishedByIno = const <String, bool>{},
    this.progressLabel,
    this.infoMessage,
    this.errorMessage,
  });

  final List<AudioFile> audioFiles;
  final bool advancedMode;
  final String codec;
  final String bitrate;
  final int channels;
  final bool isStarting;
  final bool isTaskRunning;
  final bool isCanceling;
  final String? currentEncodingHint;
  final ValueChanged<bool> onAdvancedModeChanged;
  final ValueChanged<String> onCodecChanged;
  final ValueChanged<String> onBitrateChanged;
  final ValueChanged<int> onChannelsChanged;
  final VoidCallback onStartEncoding;
  final VoidCallback onCancelEncoding;
  final Map<String, String> encodingProgressByIno;
  final Map<String, bool> encodingFinishedByIno;
  final String? progressLabel;
  final String? infoMessage;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    if (audioFiles.isEmpty) {
      return const Center(
        child: Padding(padding: EdgeInsets.all(24), child: Text('No audio tracks are available for M4B encoding.')),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      children: [
        _EncoderActionCard(
          advancedMode: advancedMode,
          codec: codec,
          bitrate: bitrate,
          channels: channels,
          isStarting: isStarting,
          isTaskRunning: isTaskRunning,
          isCanceling: isCanceling,
          currentEncodingHint: currentEncodingHint,
          progressLabel: progressLabel,
          onAdvancedModeChanged: onAdvancedModeChanged,
          onCodecChanged: onCodecChanged,
          onBitrateChanged: onBitrateChanged,
          onChannelsChanged: onChannelsChanged,
          onStartEncoding: onStartEncoding,
          onCancelEncoding: onCancelEncoding,
        ),
        if (errorMessage != null && errorMessage!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _StatusCard(
              icon: Icons.error_outline,
              message: errorMessage!,
              color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.45),
              iconColor: Theme.of(context).colorScheme.error,
            ),
          ),
        if (infoMessage != null && infoMessage!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _StatusCard(
              icon: Icons.info_outline,
              message: infoMessage!,
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.45),
              iconColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        const SizedBox(height: 12),
        _TrackPanel(
          audioFiles: audioFiles,
          encodingProgressByIno: encodingProgressByIno,
          encodingFinishedByIno: encodingFinishedByIno,
        ),
      ],
    );
  }
}

class _EncoderActionCard extends StatelessWidget {
  const _EncoderActionCard({
    required this.advancedMode,
    required this.codec,
    required this.bitrate,
    required this.channels,
    required this.isStarting,
    required this.isTaskRunning,
    required this.isCanceling,
    this.currentEncodingHint,
    required this.progressLabel,
    required this.onAdvancedModeChanged,
    required this.onCodecChanged,
    required this.onBitrateChanged,
    required this.onChannelsChanged,
    required this.onStartEncoding,
    required this.onCancelEncoding,
  });

  final bool advancedMode;
  final String codec;
  final String bitrate;
  final int channels;
  final bool isStarting;
  final bool isTaskRunning;
  final bool isCanceling;
  final String? currentEncodingHint;
  final String? progressLabel;
  final ValueChanged<bool> onAdvancedModeChanged;
  final ValueChanged<String> onCodecChanged;
  final ValueChanged<String> onBitrateChanged;
  final ValueChanged<int> onChannelsChanged;
  final VoidCallback onStartEncoding;
  final VoidCallback onCancelEncoding;

  @override
  Widget build(BuildContext context) {
    final progressPercent = _tryParsePercent(progressLabel);
    final startButtonLabel = isStarting
        ? 'Submitting...'
        : isTaskRunning
        ? 'Running...'
        : 'Start Encode';

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('M4B Encoder', style: Theme.of(context).textTheme.titleMedium),
            if (currentEncodingHint != null && currentEncodingHint!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  currentEncodingHint!,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            const SizedBox(height: 4),
            if (isTaskRunning && progressLabel != null && progressLabel!.trim().isNotEmpty) ...[
              Text(
                'Progress: ${progressLabel!.trim()}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progressPercent == null ? null : progressPercent / 100,
                minHeight: 6,
                borderRadius: BorderRadius.circular(999),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment<bool>(value: false, label: Text('Presets')),
                      ButtonSegment<bool>(value: true, label: Text('Advanced')),
                    ],
                    selected: <bool>{advancedMode},
                    onSelectionChanged: (selection) {
                      final selected = selection.isEmpty ? false : selection.first;
                      onAdvancedModeChanged(selected);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (!advancedMode)
              _PresetOptions(
                codec: codec,
                bitrate: bitrate,
                channels: channels,
                onCodecChanged: onCodecChanged,
                onBitrateChanged: onBitrateChanged,
                onChannelsChanged: onChannelsChanged,
              )
            else
              _AdvancedOptions(
                codec: codec,
                bitrate: bitrate,
                channels: channels,
                onCodecChanged: onCodecChanged,
                onBitrateChanged: onBitrateChanged,
                onChannelsChanged: onChannelsChanged,
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: (!isTaskRunning || isStarting || isCanceling) ? null : onCancelEncoding,
                  icon: isCanceling
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.1))
                      : const Icon(Icons.stop_circle_outlined),
                  label: Text(isCanceling ? 'Canceling...' : 'Cancel'),
                ),
                FilledButton.icon(
                  onPressed: (isStarting || isCanceling || isTaskRunning) ? null : onStartEncoding,
                  icon: isStarting || isTaskRunning
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.1))
                      : const Icon(Icons.play_arrow_rounded),
                  label: Text(startButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetOptions extends StatelessWidget {
  const _PresetOptions({
    required this.codec,
    required this.bitrate,
    required this.channels,
    required this.onCodecChanged,
    required this.onBitrateChanged,
    required this.onChannelsChanged,
  });

  final String codec;
  final String bitrate;
  final int channels;
  final ValueChanged<String> onCodecChanged;
  final ValueChanged<String> onBitrateChanged;
  final ValueChanged<int> onChannelsChanged;

  @override
  Widget build(BuildContext context) {
    final isCopyCodec = codec.trim().toLowerCase() == 'copy';

    return Wrap(
      spacing: 12,
      runSpacing: 10,
      children: [
        SizedBox(
          width: textfieldWidth,
          child: _DropdownCard<String>(
            label: 'Codec',
            value: _safeStringValue(codec, const <String>['copy', 'aac', 'opus']),
            values: const <String>['copy', 'aac', 'opus'],
            display: (value) => value,
            onChanged: (value) {
              if (value != null) {
                onCodecChanged(value);
              }
            },
          ),
        ),
        if (!isCopyCodec)
          SizedBox(
            width: textfieldWidth,
            child: _DropdownCard<String>(
              label: 'Bitrate',
              value: _safeStringValue(bitrate, const <String>['32k', '64k', '128k', '192k']),
              values: const <String>['32k', '64k', '128k', '192k'],
              display: (value) => value,
              onChanged: (value) {
                if (value != null) {
                  onBitrateChanged(value);
                }
              },
            ),
          ),
        if (!isCopyCodec)
          SizedBox(
            width: textfieldWidth,
            child: _DropdownCard<int>(
              label: 'Channels',
              value: channels == 1 || channels == 2 ? channels : 2,
              values: const <int>[1, 2],
              display: (value) => value == 1 ? 'Mono' : 'Stereo',
              onChanged: (value) {
                if (value != null) {
                  onChannelsChanged(value);
                }
              },
            ),
          ),
      ],
    );
  }
}

class _AdvancedOptions extends StatelessWidget {
  const _AdvancedOptions({
    required this.codec,
    required this.bitrate,
    required this.channels,
    required this.onCodecChanged,
    required this.onBitrateChanged,
    required this.onChannelsChanged,
  });

  final String codec;
  final String bitrate;
  final int channels;
  final ValueChanged<String> onCodecChanged;
  final ValueChanged<String> onBitrateChanged;
  final ValueChanged<int> onChannelsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            SizedBox(
              width: textfieldWidth,
              child: TextFormField(
                initialValue: codec,
                decoration: const InputDecoration(labelText: 'Codec', border: OutlineInputBorder()),
                onChanged: onCodecChanged,
              ),
            ),
            SizedBox(
              width: textfieldWidth,
              child: TextFormField(
                initialValue: bitrate,
                decoration: const InputDecoration(labelText: 'Bitrate', border: OutlineInputBorder()),
                onChanged: onBitrateChanged,
              ),
            ),
            SizedBox(
              width: textfieldWidth,
              child: TextFormField(
                initialValue: channels.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Channels', border: OutlineInputBorder()),
                onChanged: (value) {
                  final parsed = int.tryParse(value.trim());
                  if (parsed != null && parsed > 0) {
                    onChannelsChanged(parsed);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TrackPanel extends StatelessWidget {
  const _TrackPanel({
    required this.audioFiles,
    required this.encodingProgressByIno,
    required this.encodingFinishedByIno,
  });

  final List<AudioFile> audioFiles;
  final Map<String, String> encodingProgressByIno;
  final Map<String, bool> encodingFinishedByIno;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Audio Tracks', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: _trackListHeight,
              child: ListView.builder(
                primary: false,
                itemCount: audioFiles.length,
                itemBuilder: (context, index) {
                  final audioFile = audioFiles[index];
                  return _TrackRow(
                    index: index,
                    audioFile: audioFile,
                    progress: encodingProgressByIno[audioFile.ino],
                    isFinished: encodingFinishedByIno[audioFile.ino] == true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get _trackListHeight {
    const rowHeight = 58.0;
    const maxHeight = 420.0;
    return (audioFiles.length * rowHeight).clamp(rowHeight, maxHeight).toDouble();
  }
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({required this.index, required this.audioFile, this.progress, required this.isFinished});

  final int index;
  final AudioFile audioFile;
  final String? progress;
  final bool isFinished;

  @override
  Widget build(BuildContext context) {
    final normalizedProgress = progress?.trim();
    final showProgress = normalizedProgress != null && normalizedProgress.isNotEmpty;
    final showFinished = isFinished || normalizedProgress == '100%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: index.isOdd ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 28, child: Text('${audioFile.index ?? index + 1}.')),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  audioFile.metadata.filename,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  _trackMeta(audioFile),
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 42,
            child: Align(
              alignment: Alignment.topRight,
              child: showFinished
                  ? Icon(Icons.check_circle_outline_rounded, color: Theme.of(context).colorScheme.primary, size: 20)
                  : showProgress
                  ? Text(
                      normalizedProgress,
                      style: Theme.of(context).textTheme.labelSmall
                          ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownCard<T> extends StatelessWidget {
  const _DropdownCard({
    required this.label,
    required this.value,
    required this.values,
    required this.display,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T value) display;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return YaabsaExpressiveDropdownField<T>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      options: [for (final entry in values) YaabsaDropdownOption<T>(value: entry, label: display(entry))],
      onChanged: onChanged,
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.icon, required this.message, required this.color, required this.iconColor});

  final IconData icon;
  final String message;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

String _safeStringValue(String value, List<String> allowed) {
  return allowed.contains(value) ? value : allowed.first;
}

double? _tryParsePercent(String? value) {
  if (value == null) {
    return null;
  }

  final normalized = value.trim().replaceAll('%', '');
  if (normalized.isEmpty) {
    return null;
  }

  final parsed = double.tryParse(normalized);
  if (parsed == null || !parsed.isFinite) {
    return null;
  }

  return parsed.clamp(0, 100).toDouble();
}

String _trackMeta(AudioFile file) {
  final codec = file.codec ?? 'unknown codec';
  final bitrate = file.bitRate == null ? 'unknown bitrate' : '${(file.bitRate! / 1000).round()}k';
  final channels = file.channels == null ? 'unknown channels' : '${file.channels}ch';
  final duration = file.duration == null
      ? 'unknown duration'
      : formatDurationLong(Duration(seconds: file.duration!.round()));

  return '$codec • $bitrate • $channels • $duration • ${formatBytes(file.metadata.size)}';
}

String? describeCurrentEncoding(List<AudioFile> audioFiles) {
  if (audioFiles.isEmpty) {
    return null;
  }

  final codecs = audioFiles
      .map((file) => file.codec?.trim().toLowerCase())
      .whereType<String>()
      .where((value) => value.isNotEmpty)
      .toSet();
  final bitrates = audioFiles
      .map((file) => file.bitRate)
      .whereType<int>()
      .where((value) => value > 0)
      .map((value) => (value / 1000).round())
      .toSet();
  final channels = audioFiles.map((file) => file.channels).whereType<int>().where((value) => value > 0).toSet();

  final parts = <String>[];
  if (codecs.isNotEmpty) {
    parts.add(codecs.length == 1 ? codecs.first.toUpperCase() : 'Mixed codecs');
  }
  if (bitrates.isNotEmpty) {
    parts.add(bitrates.length == 1 ? '${bitrates.first} kbps' : 'Mixed bitrates');
  }
  if (channels.isNotEmpty) {
    parts.add(channels.length == 1 ? '${channels.first} channel${channels.first == 1 ? '' : 's'}' : 'Mixed channels');
  }

  return parts.isEmpty ? null : 'Current encoding: ${parts.join(' • ')}';
}
