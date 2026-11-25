import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

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
      return Center(
        child: Padding(padding: const EdgeInsets.all(24), child: Text(context.l10n.statusNoAudioTracksAvailable)),
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
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final percentFormat = NumberFormat.percentPattern(locale)..maximumFractionDigits = 0;
    final double? progressValue;
    final String progressText;
    if (progressPercent == null) {
      progressValue = null;
      progressText = progressLabel?.trim() ?? '';
    } else {
      progressValue = progressPercent / 100;
      progressText = percentFormat.format(progressValue);
    }

    final String startButtonLabel;
    if (isStarting) {
      startButtonLabel = l10n.statusSubmitting;
    } else if (isTaskRunning) {
      startButtonLabel = l10n.statusRunning;
    } else {
      startButtonLabel = l10n.actionStartEncoding;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.headingM4bEncoder, style: Theme.of(context).textTheme.titleMedium),
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
                l10n.encoderProgress(progressText),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              YaabsaLinearProgressIndicator(
                value: progressValue,
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
                    segments: [
                      ButtonSegment<bool>(value: false, label: Text(l10n.optionPresets)),
                      ButtonSegment<bool>(value: true, label: Text(l10n.optionAdvanced)),
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
                      ? const SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2.1))
                      : const Icon(Icons.stop_circle_outlined),
                  label: Text(isCanceling ? l10n.statusCanceling : l10n.actionCancel),
                ),
                FilledButton.icon(
                  onPressed: (isStarting || isCanceling || isTaskRunning) ? null : onStartEncoding,
                  icon: isStarting || isTaskRunning
                      ? const SizedBox(width: 16, height: 16, child: YaabsaCircularProgressIndicator(strokeWidth: 2.1))
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
            label: context.l10n.fieldCodec,
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
              label: context.l10n.fieldBitrate,
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
              label: context.l10n.fieldChannels,
              value: channels == 1 || channels == 2 ? channels : 2,
              values: const <int>[1, 2],
              display: (value) => value == 1 ? context.l10n.channelMono : context.l10n.channelStereo,
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
              child: StyledTextFormField(
                initialValue: codec,
                onChanged: onCodecChanged,
                label: context.l10n.fieldCodec,
              ),
            ),
            SizedBox(
              width: textfieldWidth,
              child: StyledTextFormField(
                initialValue: bitrate,
                onChanged: onBitrateChanged,
                label: context.l10n.fieldBitrate,
              ),
            ),
            SizedBox(
              width: textfieldWidth,
              child: StyledTextFormField(
                initialValue: channels.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value.trim());
                  if (parsed != null && parsed > 0) {
                    onChannelsChanged(parsed);
                  }
                },
                label: context.l10n.fieldChannels,
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
            Text(context.l10n.fieldAudioTracks, style: Theme.of(context).textTheme.titleMedium),
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
    final locale = Localizations.localeOf(context).toLanguageTag();
    final trackNumber = NumberFormat.decimalPattern(locale).format(audioFile.index ?? index + 1);

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
          SizedBox(width: 28, child: Text(trackNumber)),
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
                  _trackMeta(audioFile, context.l10n),
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
      decoration: InputDecoration(labelText: label),
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

String _trackMeta(AudioFile file, AppLocalizations l10n) {
  final codecValue = file.codec?.trim();
  final String codec;
  if (codecValue == null || codecValue.isEmpty) {
    codec = l10n.statusUnknown;
  } else {
    codec = codecValue.toUpperCase();
  }

  final bitRate = file.bitRate;
  final String bitrate;
  if (bitRate == null || bitRate <= 0) {
    bitrate = l10n.statusUnknown;
  } else {
    bitrate = l10n.encoderBitrateKbps((bitRate / 1000).round());
  }

  final channelCount = file.channels;
  final String channels;
  if (channelCount == null || channelCount <= 0) {
    channels = l10n.statusUnknown;
  } else {
    channels = l10n.encoderChannelCount(channelCount);
  }

  final durationSeconds = file.duration;
  final String duration;
  if (durationSeconds == null || durationSeconds <= 0) {
    duration = l10n.statusUnknown;
  } else {
    duration = formatDurationLong(Duration(seconds: durationSeconds.round()), localizations: l10n);
  }

  final size = formatBytes(file.metadata.size, localizations: l10n);

  return l10n.audioTrackMetadata(codec, bitrate, channels, duration, size);
}

String? describeCurrentEncoding(List<AudioFile> audioFiles, AppLocalizations l10n) {
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

  if (codecs.isEmpty && bitrates.isEmpty && channels.isEmpty) {
    return null;
  }

  final String codec;
  if (codecs.isEmpty) {
    codec = l10n.statusUnknown;
  } else if (codecs.length == 1) {
    codec = codecs.first.toUpperCase();
  } else {
    codec = l10n.encoderMixedCodecs;
  }

  final String bitrate;
  if (bitrates.isEmpty) {
    bitrate = l10n.statusUnknown;
  } else if (bitrates.length == 1) {
    bitrate = l10n.encoderBitrateKbps(bitrates.first);
  } else {
    bitrate = l10n.encoderMixedBitrates;
  }

  final String channelCount;
  if (channels.isEmpty) {
    channelCount = l10n.statusUnknown;
  } else if (channels.length == 1) {
    channelCount = l10n.encoderChannelCount(channels.first);
  } else {
    channelCount = l10n.encoderMixedChannels;
  }

  return l10n.encoderCurrentEncoding(codec, bitrate, channelCount);
}
