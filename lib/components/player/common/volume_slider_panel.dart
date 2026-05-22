import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';

class VolumeSliderPanel extends StatelessWidget {
  const VolumeSliderPanel({super.key, required this.axis});

  static const double _minDb = -30.0;
  static const double _dbCurve = 0.5;

  final Axis axis;

  bool get _showBoostMarker => defaultTargetPlatform == TargetPlatform.android && BGAudioHandler.maxVolume > 1.0;

  double _volumeToSliderValue(double volume) {
    final maxVolume = BGAudioHandler.maxVolume;
    if (maxVolume <= 0) {
      return 0.0;
    }

    final clampedVolume = volume.clamp(0.0, maxVolume).toDouble();
    if (clampedVolume == 0.0) {
      return 0.0;
    }

    final maxDb = 20 * math.log(maxVolume) / math.ln10;
    final dbRange = maxDb - _minDb;
    if (dbRange <= 0) {
      return (clampedVolume / maxVolume).clamp(0.0, 1.0);
    }

    final volumeDb = 20 * math.log(clampedVolume) / math.ln10;
    final normalizedDb = ((volumeDb - _minDb) / dbRange).clamp(0.0, 1.0);
    return math.pow(normalizedDb, 1 / _dbCurve).toDouble().clamp(0.0, 1.0);
  }

  double _sliderValueToVolume(double sliderValue) {
    final maxVolume = BGAudioHandler.maxVolume;
    if (maxVolume <= 0) {
      return 0.0;
    }

    final clampedSliderValue = sliderValue.clamp(0.0, 1.0).toDouble();
    if (clampedSliderValue == 0.0) {
      return 0.0;
    }

    final maxDb = 20 * math.log(maxVolume) / math.ln10;
    final dbRange = maxDb - _minDb;
    if (dbRange <= 0) {
      return (clampedSliderValue * maxVolume).clamp(0.0, maxVolume);
    }

    final easedSliderValue = math.pow(clampedSliderValue, _dbCurve).toDouble();
    final volumeDb = _minDb + (dbRange * easedSliderValue);
    final volume = math.pow(10, volumeDb / 20).toDouble();
    return volume.clamp(0.0, maxVolume);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: audioHandler.volumeStream,
      initialData: 1.0,
      builder: (context, snapshot) {
        final maxVolume = BGAudioHandler.maxVolume;
        final volume = (snapshot.data ?? 1.0).clamp(0.0, maxVolume).toDouble();
        final sliderValue = _volumeToSliderValue(volume);
        final boostMarkerValue = _volumeToSliderValue(1.0);

        if (axis == Axis.vertical) {
          return _VerticalVolumePanel(
            sliderValue: sliderValue,
            boostMarkerValue: boostMarkerValue,
            showBoostMarker: _showBoostMarker,
            onChanged: (value) => audioHandler.setVolume(_sliderValueToVolume(value)),
          );
        }

        return _HorizontalVolumePanel(
          volume: volume,
          sliderValue: sliderValue,
          boostMarkerValue: boostMarkerValue,
          showBoostMarker: _showBoostMarker,
          onChanged: (value) => audioHandler.setVolume(_sliderValueToVolume(value)),
        );
      },
    );
  }
}

class _HorizontalVolumePanel extends StatelessWidget {
  const _HorizontalVolumePanel({
    required this.volume,
    required this.sliderValue,
    required this.boostMarkerValue,
    required this.showBoostMarker,
    required this.onChanged,
  });

  final double volume;
  final double sliderValue;
  final double boostMarkerValue;
  final bool showBoostMarker;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Volume', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.volume_down_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: _VolumeSlider(
                value: sliderValue,
                markerValue: boostMarkerValue,
                showBoostMarker: showBoostMarker,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.volume_up_rounded, color: Theme.of(context).colorScheme.primary),
          ],
        ),
        const SizedBox(height: 8),
        Text('${(volume * 100).round()}%', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _VerticalVolumePanel extends StatelessWidget {
  const _VerticalVolumePanel({
    required this.sliderValue,
    required this.boostMarkerValue,
    required this.showBoostMarker,
    required this.onChanged,
  });

  final double sliderValue;
  final double boostMarkerValue;
  final bool showBoostMarker;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 182,
      child: RotatedBox(
        quarterTurns: 3,
        child: _VolumeSlider(
          value: sliderValue,
          markerValue: boostMarkerValue,
          showBoostMarker: showBoostMarker,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  const _VolumeSlider({
    required this.value,
    required this.markerValue,
    required this.showBoostMarker,
    required this.onChanged,
  });

  final double value;
  final double markerValue;
  final bool showBoostMarker;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final baseTheme = SliderTheme.of(context);
    final sliderTheme = showBoostMarker
        ? baseTheme.copyWith(trackShape: _BoostMarkerTrackShape(markerValue: markerValue))
        : baseTheme;

    return SliderTheme(
      data: sliderTheme,
      child: Slider(value: value, min: 0.0, max: 1.0, onChanged: onChanged),
    );
  }
}

class _BoostMarkerTrackShape extends RoundedRectSliderTrackShape {
  const _BoostMarkerTrackShape({required this.markerValue});

  final double markerValue;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    double additionalActiveTrackHeight = 2,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    super.paint(
      context,
      offset,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
      textDirection: textDirection,
    );

    final clampedMarker = markerValue.clamp(0.0, 1.0).toDouble();
    if (clampedMarker <= 0 || clampedMarker >= 1) {
      return;
    }

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final markerX = trackRect.left + (trackRect.width * clampedMarker);
    final markerPaint = Paint()
      ..color = sliderTheme.thumbColor?.withValues(alpha: 0.9) ?? sliderTheme.activeTrackColor ?? Colors.white
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    context.canvas.drawLine(Offset(markerX, trackRect.top - 3), Offset(markerX, trackRect.bottom + 3), markerPaint);
  }
}
