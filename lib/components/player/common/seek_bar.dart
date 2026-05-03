import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';

class SeekBar extends ConsumerWidget {
  const SeekBar({super.key, this.trackHeight = 10.0, this.timeLabelsBelow = false, this.timeLabelFontSize = 12.0});

  final double trackHeight;
  final bool timeLabelsBelow;
  final double timeLabelFontSize;

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--:--';

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }

    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  InternalChapter? _getCurrentChapter(List<InternalChapter> chapters, Duration currentPosition) {
    final mediaChapter = audioHandler.currentMediaItem?.getChapterForDuration(currentPosition);
    if (mediaChapter != null) {
      return mediaChapter;
    }

    if (chapters.isEmpty) {
      return null;
    }

    for (final chapter in chapters) {
      final chapterStart = chapter.start.toDuration;
      final chapterEnd = chapter.end.toDuration;
      if (currentPosition >= chapterStart && currentPosition < chapterEnd) {
        return chapter;
      }
    }

    final lastChapter = chapters.last;
    if (currentPosition >= lastChapter.end.toDuration) {
      return lastChapter;
    }

    if (currentPosition < chapters.first.start.toDuration) {
      return chapters.first;
    }

    return null;
  }

  Duration _clampDuration(Duration value, Duration min, Duration max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  List<double> _resolveMarkerOffsets({
    required List<Duration> markers,
    required Duration rangeStart,
    required Duration rangeEnd,
    required double sliderWidth,
  }) {
    final rangeDuration = rangeEnd - rangeStart;
    final rangeSeconds = rangeDuration.inMilliseconds / 1000.0;
    if (rangeSeconds <= 0 || sliderWidth <= 0 || markers.isEmpty) {
      return const <double>[];
    }

    final rawOffsets = <double>[];
    for (final marker in markers) {
      if (marker <= rangeStart || marker >= rangeEnd) {
        continue;
      }

      final markerSeconds = (marker - rangeStart).inMilliseconds / 1000.0;
      final offset = (markerSeconds / rangeSeconds) * sliderWidth;
      rawOffsets.add(offset.clamp(0.0, sliderWidth).toDouble());
    }

    if (rawOffsets.length <= 1) {
      return rawOffsets;
    }

    rawOffsets.sort();

    final markerCount = rawOffsets.length;
    final minVisualGap = markerCount <= 24
        ? 0.0
        : markerCount <= 60
        ? 2.0
        : markerCount <= 140
        ? 3.0
        : 4.0;

    if (minVisualGap == 0.0) {
      return rawOffsets;
    }

    final filtered = <double>[rawOffsets.first];
    for (var i = 1; i < rawOffsets.length; i++) {
      if (rawOffsets[i] - filtered.last >= minVisualGap) {
        filtered.add(rawOffsets[i]);
      }
    }

    return filtered;
  }

  Widget _buildTimeLabel(BuildContext context, Duration time) {
    return Text(
      _formatDuration(time),
      style: TextStyle(
        fontSize: timeLabelFontSize,
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
      ),
    );
  }

  Widget _buildSeekSlider({
    required BuildContext context,
    required Duration rangeStart,
    required Duration rangeEnd,
    required double sliderValue,
    required double maxSliderValue,
    required bool hasSeekRange,
    required List<Duration> markers,
    required void Function(double seconds) executeSeek,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: timeLabelsBelow ? 0 : 4),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: trackHeight,
          trackShape: const RectangularSliderTrackShape(),
          thumbShape: const RoundSliderThumbShape(
            enabledThumbRadius: 0.0,
            disabledThumbRadius: 0.0,
            pressedElevation: 0.0,
          ),
          overlayShape: SliderComponentShape.noOverlay,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sliderWidth = constraints.maxWidth;
            final markerOffsets = _resolveMarkerOffsets(
              markers: markers,
              rangeStart: rangeStart,
              rangeEnd: rangeEnd,
              sliderWidth: sliderWidth,
            );

            final markerCount = markerOffsets.length;
            final markerWidth = markerCount <= 24
                ? 2.4
                : markerCount <= 70
                ? 2.0
                : markerCount <= 140
                ? 1.6
                : 1.2;
            final markerAlpha = markerCount <= 24
                ? 0.95
                : markerCount <= 70
                ? 0.9
                : markerCount <= 140
                ? 0.84
                : 0.78;

            return Stack(
              children: [
                Slider(
                  value: sliderValue.clamp(0.0, hasSeekRange ? maxSliderValue : 0.0),
                  min: 0.0,
                  max: hasSeekRange ? maxSliderValue : 1.0,
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  onChanged: hasSeekRange ? executeSeek : null,
                  onChangeEnd: hasSeekRange ? executeSeek : null,
                ),
                for (final offset in markerOffsets)
                  Positioned(
                    left: (offset - (markerWidth / 2))
                        .clamp(0.0, sliderWidth > markerWidth ? sliderWidth - markerWidth : 0.0)
                        .toDouble(),
                    child: Container(
                      width: markerWidth,
                      height: trackHeight + 2,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary.withValues(alpha: markerAlpha),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSeekRow({
    required BuildContext context,
    required Duration rangeStart,
    required Duration rangeEnd,
    required Duration currentPosition,
    required Duration leftTime,
    required Duration rightTime,
    required void Function(Duration) onSeek,
    required List<Duration> markers,
  }) {
    final clampedCurrent = _clampDuration(currentPosition, rangeStart, rangeEnd);
    final rangeDuration = rangeEnd - rangeStart;
    final maxSliderValue = rangeDuration.inMilliseconds / 1000.0;
    final sliderValue = (clampedCurrent - rangeStart).inMilliseconds / 1000.0;
    final hasSeekRange = maxSliderValue > 0;

    void executeSeek(double seconds) {
      final seekPosition = rangeStart + Duration(milliseconds: (seconds * 1000).round());
      onSeek(seekPosition);
    }

    final slider = _buildSeekSlider(
      context: context,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      sliderValue: sliderValue,
      maxSliderValue: maxSliderValue,
      hasSeekRange: hasSeekRange,
      markers: markers,
      executeSeek: executeSeek,
    );

    if (timeLabelsBelow) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          slider,
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildTimeLabel(context, leftTime), _buildTimeLabel(context, rightTime)],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        _buildTimeLabel(context, leftTime),
        Expanded(child: slider),
        _buildTimeLabel(context, rightTime),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for persisted setting changes and resolve from cache for immediate in-app updates.
    ref.watch(globalSettingByKeyProvider(SettingKeys.playerSeekBarMode));
    final settingsManager = ref.read(settingsManagerProvider.notifier);

    final Stream<Duration> positionStream = audioHandler.positionStream;
    final Stream<Duration> totalDurationStream = audioHandler.durationStream;
    final Stream<List<InternalChapter>> chaptersStream = audioHandler.chaptersStream;

    return StreamBuilder<Duration>(
      stream: totalDurationStream,
      builder: (context, totalDurationSnapshot) {
        final totalDuration = totalDurationSnapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: positionStream,
          builder: (context, positionSnapshot) {
            final currentPosition = positionSnapshot.data ?? Duration.zero;
            return StreamBuilder<List<InternalChapter>>(
              stream: chaptersStream,
              builder: (context, chaptersSnapshot) {
                final configuredMode = PlayerSeekBarMode.fromSettingValue(
                  settingsManager.getGlobalSetting<String>(
                    SettingKeys.playerSeekBarMode,
                    defaultValue: PlayerSeekBarMode.full.name,
                  ),
                );
                final chapters = chaptersSnapshot.data ?? const <InternalChapter>[];
                final currentChapter = _getCurrentChapter(chapters, currentPosition);

                final shouldShowChapter =
                    (configuredMode == PlayerSeekBarMode.chapter || configuredMode == PlayerSeekBarMode.both) &&
                    currentChapter != null;
                final shouldShowFull =
                    configuredMode == PlayerSeekBarMode.full ||
                    configuredMode == PlayerSeekBarMode.both ||
                    !shouldShowChapter;

                final chapterRows = <Widget>[];

                if (shouldShowChapter) {
                  final chapter = currentChapter;
                  final chapterStart = chapter.start.toDuration;
                  final chapterEnd = chapter.end.toDuration;
                  final chapterDuration = chapterEnd - chapterStart;
                  final chapterElapsed = _clampDuration(currentPosition, chapterStart, chapterEnd) - chapterStart;

                  chapterRows.add(
                    _buildSeekRow(
                      context: context,
                      rangeStart: chapterStart,
                      rangeEnd: chapterEnd,
                      currentPosition: currentPosition,
                      leftTime: chapterElapsed,
                      rightTime: chapterDuration,
                      onSeek: (seekPosition) => audioHandler.seek(seekPosition),
                      markers: const [],
                    ),
                  );
                }

                if (shouldShowChapter && shouldShowFull) {
                  chapterRows.add(const SizedBox(height: 4));
                }

                if (shouldShowFull) {
                  chapterRows.add(
                    _buildSeekRow(
                      context: context,
                      rangeStart: Duration.zero,
                      rangeEnd: totalDuration,
                      currentPosition: currentPosition,
                      leftTime: currentPosition,
                      rightTime: totalDuration,
                      onSeek: (seekPosition) => audioHandler.seek(seekPosition),
                      markers: chapters.map((chapter) => chapter.start.toDuration).toList(),
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: chapterRows,
                );
              },
            );
          },
        );
      },
    );
  }
}
