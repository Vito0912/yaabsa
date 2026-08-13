import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/globals.dart';

class VolumeSliderPanel extends StatelessWidget {
  const VolumeSliderPanel({super.key, required this.axis});

  static const double _minDb = -30.0;
  static const double _dbCurve = 0.5;

  final Axis axis;

  double _volumeToSliderValue(double volume, double maxVolume) {
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

  double _sliderValueToVolume(double sliderValue, double maxVolume) {
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
    return StreamBuilder<bool>(
      stream: audioHandler.volumeBoostAvailableStream,
      initialData: audioHandler.volumeBoostAvailable,
      builder: (context, _) {
        return StreamBuilder<double>(
          stream: audioHandler.volumeStream,
          initialData: 1.0,
          builder: (context, snapshot) {
            final maxVolume = audioHandler.maxVolume;
            final volume = (snapshot.data ?? 1.0).clamp(0.0, maxVolume).toDouble();
            final sliderValue = _volumeToSliderValue(volume, maxVolume);
            final unitySliderValue = _volumeToSliderValue(1.0, maxVolume);

            if (axis == Axis.vertical) {
              return _VerticalVolumePanel(
                maxVolume: maxVolume,
                sliderValue: sliderValue,
                unitySliderValue: unitySliderValue,
                sliderValueToVolume: (double value) => _sliderValueToVolume(value, maxVolume),
                onChanged: (value) => audioHandler.setVolume(_sliderValueToVolume(value, maxVolume)),
              );
            }

            return _HorizontalVolumePanel(
              volume: volume,
              maxVolume: maxVolume,
              sliderValue: sliderValue,
              unitySliderValue: unitySliderValue,
              sliderValueToVolume: (double value) => _sliderValueToVolume(value, maxVolume),
              onChanged: (value) => audioHandler.setVolume(_sliderValueToVolume(value, maxVolume)),
            );
          },
        );
      },
    );
  }
}

class _HorizontalVolumePanel extends StatelessWidget {
  const _HorizontalVolumePanel({
    required this.volume,
    required this.maxVolume,
    required this.sliderValue,
    required this.unitySliderValue,
    required this.sliderValueToVolume,
    required this.onChanged,
  });

  final double volume;
  final double maxVolume;
  final double sliderValue;
  final double unitySliderValue;
  final double Function(double) sliderValueToVolume;
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
                maxVolume: maxVolume,
                unitySliderValue: unitySliderValue,
                sliderValueToVolume: sliderValueToVolume,
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
    required this.maxVolume,
    required this.sliderValue,
    required this.unitySliderValue,
    required this.sliderValueToVolume,
    required this.onChanged,
  });

  final double maxVolume;
  final double sliderValue;
  final double unitySliderValue;
  final double Function(double) sliderValueToVolume;
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
          maxVolume: maxVolume,
          unitySliderValue: unitySliderValue,
          sliderValueToVolume: sliderValueToVolume,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _VolumeSlider extends StatefulWidget {
  const _VolumeSlider({
    required this.value,
    required this.maxVolume,
    required this.unitySliderValue,
    required this.sliderValueToVolume,
    required this.onChanged,
  });

  final double value;
  final double maxVolume;
  final double unitySliderValue;
  final double Function(double) sliderValueToVolume;
  final ValueChanged<double> onChanged;

  @override
  State<_VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<_VolumeSlider> {
  static const double _detentCapture = 0.02;
  static const double _detentRelease = 0.04;
  bool _detentLatched = false;

  void _handleChanged(double rawSliderValue) {
    final rawVolume = widget.sliderValueToVolume(rawSliderValue);
    if (_detentLatched && (rawVolume - 1.0).abs() > _detentRelease) {
      _detentLatched = false;
    }
    if (!_detentLatched && (rawVolume - 1.0).abs() <= _detentCapture) {
      _detentLatched = true;
    }
    widget.onChanged(_detentLatched ? widget.unitySliderValue : rawSliderValue);
  }

  @override
  Widget build(BuildContext context) {
    final showMarker = widget.maxVolume > 1.0;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackShape: showMarker
            ? _UnityMarkerTrackShape(
                position: widget.unitySliderValue,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
              )
            : null,
      ),
      child: Slider(
        value: widget.value,
        min: 0.0,
        max: 1.0,
        onChanged: _handleChanged,
        onChangeStart: (_) => _detentLatched = false,
        onChangeEnd: (_) => _detentLatched = false,
      ),
    );
  }
}

class _UnityMarkerTrackShape extends RoundedRectSliderTrackShape {
  const _UnityMarkerTrackShape({required this.position, required this.color});

  final double position;
  final Color color;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
    );

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final markerPaint = Paint()..color = color;
    final markerX = trackRect.left + (trackRect.width * position);
    context.canvas.drawRect(
      Rect.fromCenter(center: Offset(markerX, trackRect.center.dy), width: 2, height: 8),
      markerPaint,
    );
  }
}
