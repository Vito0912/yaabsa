import 'dart:math' as math;

import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ESlider, M3ESliderColors, M3ESliderSize, M3ESliderTheme, M3ESliderTrack;
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/globals.dart';

class VolumeSliderPanel extends StatelessWidget {
  const VolumeSliderPanel({super.key, required this.axis});

  final Axis axis;

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
            final volume = snapshot.data ?? 1.0;

            return VolumeSliderPresentation(
              axis: axis,
              volume: volume,
              maxVolume: maxVolume,
              onChanged: audioHandler.setVolume,
            );
          },
        );
      },
    );
  }
}

class VolumeSliderPresentation extends StatelessWidget {
  const VolumeSliderPresentation({
    super.key,
    required this.axis,
    required this.volume,
    required this.maxVolume,
    required this.onChanged,
  });

  static const double _minDb = -30.0;
  static const double _dbCurve = 0.5;

  final Axis axis;
  final double volume;
  final double maxVolume;
  final ValueChanged<double> onChanged;

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
    final convertedVolume = math.pow(10, volumeDb / 20).toDouble();
    return convertedVolume.clamp(0.0, maxVolume);
  }

  @override
  Widget build(BuildContext context) {
    final clampedVolume = volume.clamp(0.0, maxVolume).toDouble();
    final sliderValue = _volumeToSliderValue(clampedVolume, maxVolume);
    final unitySliderValue = _volumeToSliderValue(1.0, maxVolume);
    double sliderValueToVolume(double value) {
      return _sliderValueToVolume(value, maxVolume);
    }

    void onSliderChanged(double value) {
      onChanged(sliderValueToVolume(value));
    }

    if (axis == Axis.vertical) {
      return _VerticalVolumePanel(
        maxVolume: maxVolume,
        sliderValue: sliderValue,
        unitySliderValue: unitySliderValue,
        sliderValueToVolume: sliderValueToVolume,
        onChanged: onSliderChanged,
      );
    }

    return _HorizontalVolumePanel(
      volume: clampedVolume,
      maxVolume: maxVolume,
      sliderValue: sliderValue,
      unitySliderValue: unitySliderValue,
      sliderValueToVolume: sliderValueToVolume,
      onChanged: onSliderChanged,
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
                axis: Axis.horizontal,
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
    return _VolumeSlider(
      axis: Axis.vertical,
      value: sliderValue,
      maxVolume: maxVolume,
      unitySliderValue: unitySliderValue,
      sliderValueToVolume: sliderValueToVolume,
      onChanged: onChanged,
    );
  }
}

class _VolumeSlider extends StatefulWidget {
  const _VolumeSlider({
    required this.axis,
    required this.value,
    required this.maxVolume,
    required this.unitySliderValue,
    required this.sliderValueToVolume,
    required this.onChanged,
  });

  final Axis axis;
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

  Widget _buildTrack({
    required BuildContext context,
    required M3ESliderColors colors,
    required M3ESliderTheme theme,
    required double fraction,
    required List<double> tickFractions,
    required double handleThickness,
  }) {
    final showMarker = widget.maxVolume > 1.0;
    final direction = Directionality.of(context);
    final track = M3ESliderTrack(
      fraction: fraction,
      tickFractions: tickFractions,
      colors: colors,
      theme: theme,
      axis: widget.axis,
      textDirection: direction,
      handleThickness: handleThickness,
      drawDots: true,
      edgeInset: theme.stopIndicatorTrailingSpace,
    );

    if (!showMarker) {
      return track;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        track,
        CustomPaint(
          painter: _UnityMarkerPainter(
            axis: widget.axis,
            position: widget.unitySliderValue,
            textDirection: direction,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    void handleChangeEnd(double _) {
      _detentLatched = false;
    }

    final slider = widget.axis == Axis.vertical
        ? M3ESlider.vertical(
            value: widget.value,
            min: 0.0,
            max: 1.0,
            onChanged: _handleChanged,
            onChangeEnd: handleChangeEnd,
            semanticLabel: 'Volume',
            semanticFormatterCallback: (value) => '${(widget.sliderValueToVolume(value) * 100).round()}%',
            size: M3ESliderSize.xs,
            trackBuilder: _buildTrack,
          )
        : M3ESlider(
            value: widget.value,
            min: 0.0,
            max: 1.0,
            onChanged: _handleChanged,
            onChangeEnd: handleChangeEnd,
            semanticLabel: 'Volume',
            semanticFormatterCallback: (value) => '${(widget.sliderValueToVolume(value) * 100).round()}%',
            size: M3ESliderSize.xs,
            trackBuilder: _buildTrack,
          );

    if (widget.axis == Axis.vertical) {
      return SizedBox(width: 32, height: 182, child: slider);
    }

    return slider;
  }
}

class _UnityMarkerPainter extends CustomPainter {
  const _UnityMarkerPainter({
    required this.axis,
    required this.position,
    required this.textDirection,
    required this.color,
  });

  final Axis axis;
  final double position;
  final TextDirection textDirection;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final markerPaint = Paint()..color = color;

    if (axis == Axis.vertical) {
      final markerY = size.height * (1.0 - position);
      canvas.drawRect(Rect.fromCenter(center: Offset(size.width / 2, markerY), width: 8, height: 2), markerPaint);
      return;
    }

    final markerPosition = textDirection == TextDirection.rtl ? 1.0 - position : position;
    final markerX = size.width * markerPosition;
    canvas.drawRect(Rect.fromCenter(center: Offset(markerX, size.height / 2), width: 2, height: 8), markerPaint);
  }

  @override
  bool shouldRepaint(_UnityMarkerPainter oldDelegate) {
    return axis != oldDelegate.axis ||
        position != oldDelegate.position ||
        textDirection != oldDelegate.textDirection ||
        color != oldDelegate.color;
  }
}
