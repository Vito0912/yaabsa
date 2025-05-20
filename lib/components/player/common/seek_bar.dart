import 'dart:async';

import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';

class SeekBar extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final Stream<Duration> positionStream = audioHandler.positionStream;
    final Stream<Duration> totalDurationStream = audioHandler.durationStream;

    return StreamBuilder<Duration>(
      stream: totalDurationStream,
      builder: (context, snapshotTotalDuration) {
        final totalDuration = snapshotTotalDuration.data ?? Duration.zero;
        final maxSliderValue = totalDuration.inMilliseconds / 1000.0;

        return StreamBuilder<Duration>(
          stream: positionStream,
          builder: (context, snapshotPosition) {
            final currentPosition = snapshotPosition.data ?? Duration.zero;

            final double sliderValue = (currentPosition.inMilliseconds / 1000.0).clamp(
              0.0,
              maxSliderValue > 0 ? maxSliderValue : 0.0,
            );
            final Duration displayCurrentTime = currentPosition;

            void executeSeek(double seconds) {
              final seekPosition = Duration(milliseconds: (seconds * 1000).round());
              audioHandler.seek(seekPosition);
            }

            return Row(
              children: [
                Text(_formatDuration(displayCurrentTime), style: const TextStyle(fontSize: 12)),
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
                      child: Slider(
                        value: sliderValue,
                        min: 0.0,
                        max: maxSliderValue > 0 ? maxSliderValue : 1.0,
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                        onChanged:
                            maxSliderValue <= 0
                                ? null
                                : (newValue) {
                                  executeSeek(newValue);
                                },
                        onChangeEnd:
                            maxSliderValue <= 0
                                ? null
                                : (endValue) {
                                  executeSeek(endValue);
                                },
                      ),
                    ),
                  ),
                ),
                Text(_formatDuration(totalDuration), style: const TextStyle(fontSize: 12)),
              ],
            );
          },
        );
      },
    );
  }
}
