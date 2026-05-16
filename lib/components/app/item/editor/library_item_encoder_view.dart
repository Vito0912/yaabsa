import 'package:flutter/material.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
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
    required this.onAdvancedModeChanged,
    required this.onCodecChanged,
    required this.onBitrateChanged,
    required this.onChannelsChanged,
    required this.onStartEncoding,
    required this.onCancelEncoding,
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
  final ValueChanged<bool> onAdvancedModeChanged;
  final ValueChanged<String> onCodecChanged;
  final ValueChanged<String> onBitrateChanged;
  final ValueChanged<int> onChannelsChanged;
  final VoidCallback onStartEncoding;
  final VoidCallback onCancelEncoding;
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
        _TrackPanel(audioFiles: audioFiles),
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
  const _TrackPanel({required this.audioFiles});

  final List<AudioFile> audioFiles;

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
            for (var i = 0; i < audioFiles.length; i++)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: i.isOdd ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : null,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 28, child: Text('${audioFiles[i].index ?? i + 1}.')),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            audioFiles[i].metadata.filename,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _trackMeta(audioFiles[i]),
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
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
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: [for (final value in values) DropdownMenuItem<T>(value: value, child: Text(display(value)))],
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
