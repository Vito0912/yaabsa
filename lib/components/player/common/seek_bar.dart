import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';

class SeekBar extends ConsumerWidget {
  const SeekBar({super.key});

  String _formatDuration(Duration? duration) {
    if (duration == null) return "--:--";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  InternalChapter? _getCurrentChapter(List<InternalChapter> chapters, Duration currentPosition) {
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

    return null;
  }

  Duration _clampDuration(Duration value, Duration min, Duration max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              _formatDuration(leftTime),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 10.0,
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
                      final rangeSeconds = rangeDuration.inMilliseconds / 1000.0;

                      final markerOffsets = <double>[];
                      if (rangeSeconds > 0) {
                        for (final marker in markers) {
                          if (marker <= rangeStart || marker >= rangeEnd) {
                            continue;
                          }
                          final markerSeconds = (marker - rangeStart).inMilliseconds / 1000.0;
                          markerOffsets.add((markerSeconds / rangeSeconds) * sliderWidth);
                        }
                      }

                      return Stack(
                        children: [
                          Slider(
                            value: sliderValue.clamp(0.0, hasSeekRange ? maxSliderValue : 0.0),
                            min: 0.0,
                            max: hasSeekRange ? maxSliderValue : 1.0,
                            activeColor: Theme.of(context).colorScheme.primary,
                            inactiveColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                            onChanged: hasSeekRange
                                ? (newValue) {
                                    executeSeek(newValue);
                                  }
                                : null,
                            onChangeEnd: hasSeekRange
                                ? (endValue) {
                                    executeSeek(endValue);
                                  }
                                : null,
                          ),
                          for (final offset in markerOffsets)
                            Positioned(
                              left: offset,
                              child: Container(
                                width: 1.0,
                                height: 10.0,
                                color: Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.75),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Text(
              _formatDuration(rightTime),
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seekBarModeValue = ref.watch(globalSettingByKeyProvider(SettingKeys.playerSeekBarMode)).asData?.value;
    final configuredMode = PlayerSeekBarMode.fromSettingValue(seekBarModeValue);

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
