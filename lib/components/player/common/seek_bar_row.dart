import 'package:flutter/material.dart';
import 'package:yaabsa/components/player/common/seek_bar_slider.dart';
import 'package:yaabsa/util/setting_key.dart';

class SeekBarRow extends StatelessWidget {
  const SeekBarRow({
    super.key,
    required this.trackHeight,
    required this.timeLabelsBelow,
    required this.timeLabelFontSize,
    required this.previewLabelFontSize,
    required this.rangeStart,
    required this.rangeEnd,
    required this.currentPosition,
    required this.leftTime,
    required this.rightTime,
    required this.onSeek,
    required this.markers,
    required this.markerMode,
    required this.buildPreviewLabel,
    required this.formatDuration,
  });

  final double trackHeight;
  final bool timeLabelsBelow;
  final double timeLabelFontSize;
  final double? previewLabelFontSize;
  final Duration rangeStart;
  final Duration rangeEnd;
  final Duration currentPosition;
  final Duration leftTime;
  final Duration rightTime;
  final void Function(Duration) onSeek;
  final List<SeekTimelineMarker> markers;
  final SeekBarMarkerMode markerMode;
  final String Function(Duration position) buildPreviewLabel;
  final String Function(Duration? duration) formatDuration;

  Duration _clampDuration(Duration value, Duration min, Duration max) {
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }

  Widget _buildTimeLabel(BuildContext context, Duration time) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      formatDuration(time),
      style: TextStyle(
        fontSize: timeLabelFontSize,
        fontFamily: 'monospace',
        fontFeatures: const [FontFeature.tabularFigures()],
        color: colorScheme.onSurface.withValues(alpha: 0.9),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clampedCurrent = _clampDuration(currentPosition, rangeStart, rangeEnd);
    final rangeDuration = rangeEnd - rangeStart;
    final maxSliderValue = rangeDuration.inMilliseconds / 1000.0;
    final sliderValue = (clampedCurrent - rangeStart).inMilliseconds / 1000.0;
    final hasSeekRange = maxSliderValue > 0;

    void executeSeek(double seconds) {
      final seekPosition = rangeStart + Duration(milliseconds: (seconds * 1000).round());
      onSeek(seekPosition);
    }

    final slider = SeekBarSlider(
      trackHeight: trackHeight,
      timeLabelsBelow: timeLabelsBelow,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      sliderValue: sliderValue,
      maxSliderValue: maxSliderValue,
      hasSeekRange: hasSeekRange,
      markers: markers,
      markerMode: markerMode,
      executeSeek: executeSeek,
      buildPreviewLabel: buildPreviewLabel,
      previewLabelFontSize: previewLabelFontSize,
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
}
