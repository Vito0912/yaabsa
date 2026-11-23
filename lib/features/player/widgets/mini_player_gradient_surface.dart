import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

class MiniPlayerGradientSurface extends StatelessWidget {
  const MiniPlayerGradientSurface({
    required this.startColor,
    required this.endColor,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.duration = const Duration(milliseconds: 260),
    super.key,
  });

  final Color startColor;
  final Color endColor;
  final Widget child;
  final BorderRadius borderRadius;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final targetColors = _GradientColorPair(start: startColor, end: endColor);

    return TweenAnimationBuilder<_GradientColorPair>(
      tween: _GradientColorPairTween(end: targetColors),
      duration: duration,
      curve: Curves.easeOut,
      child: child,
      builder: (context, colors, child) {
        return CustomPaint(
          painter: _BoundedMiniPlayerGradientPainter(
            startColor: colors.start,
            endColor: colors.end,
            borderRadius: borderRadius,
          ),
          child: child,
        );
      },
    );
  }
}

class _GradientColorPair {
  const _GradientColorPair({required this.start, required this.end});

  final Color start;
  final Color end;

  @override
  bool operator ==(Object other) {
    return other is _GradientColorPair && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

class _GradientColorPairTween extends Tween<_GradientColorPair> {
  _GradientColorPairTween({required _GradientColorPair end}) : super(end: end);

  @override
  _GradientColorPair lerp(double t) {
    final endColors = end!;
    final beginColors = begin ?? endColors;

    return _GradientColorPair(
      start: Color.lerp(beginColors.start, endColors.start, t)!,
      end: Color.lerp(beginColors.end, endColors.end, t)!,
    );
  }
}

class _BoundedMiniPlayerGradientPainter extends CustomPainter {
  const _BoundedMiniPlayerGradientPainter({
    required this.startColor,
    required this.endColor,
    required this.borderRadius,
  });

  static const double _maximumShaderLength = 160;
  static const double _segmentOverlap = 0.5;

  final Color startColor;
  final Color endColor;
  final BorderRadius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }

    final bounds = Offset.zero & size;
    canvas.save();
    canvas.clipRRect(borderRadius.toRRect(bounds), doAntiAlias: true);

    if (startColor == endColor) {
      canvas.drawColor(startColor, BlendMode.src);
      canvas.restore();
      return;
    }

    final gradientStart = bounds.topLeft;
    final gradientEnd = bounds.bottomRight;
    final gradientVector = gradientEnd - gradientStart;
    final gradientLength = gradientVector.distance;
    final gradientLengthSquared = gradientLength * gradientLength;
    final horizontalProjection = gradientVector.dx.abs() * bounds.width / gradientLength;
    final verticalProjection = gradientVector.dy.abs() * bounds.height / gradientLength;
    var columns = math.max(1, (horizontalProjection / _maximumShaderLength).ceil());
    var rows = math.max(1, (verticalProjection / _maximumShaderLength).ceil());

    while (horizontalProjection / columns + verticalProjection / rows > _maximumShaderLength) {
      final horizontalSegmentLength = horizontalProjection / columns;
      final verticalSegmentLength = verticalProjection / rows;
      if (horizontalSegmentLength >= verticalSegmentLength) {
        columns += 1;
      } else {
        rows += 1;
      }
    }

    final segmentWidth = bounds.width / columns;
    final segmentHeight = bounds.height / rows;
    final paint = Paint()..isAntiAlias = false;

    for (var row = 0; row < rows; row += 1) {
      for (var column = 0; column < columns; column += 1) {
        final segment = Rect.fromLTWH(
          bounds.left + segmentWidth * column,
          bounds.top + segmentHeight * row,
          segmentWidth,
          segmentHeight,
        );
        final shaderBounds = segment.inflate(_segmentOverlap);
        final startT = _gradientPosition(shaderBounds.topLeft, gradientStart, gradientVector, gradientLengthSquared);
        final endT = _gradientPosition(shaderBounds.bottomRight, gradientStart, gradientVector, gradientLengthSquared);
        final boundedStartT = startT.clamp(0.0, 1.0);
        final boundedEndT = endT.clamp(0.0, 1.0);
        final shaderStart = gradientStart + gradientVector * boundedStartT;
        final shaderEnd = gradientStart + gradientVector * boundedEndT;

        if (boundedEndT <= boundedStartT) {
          paint
            ..shader = null
            ..color = Color.lerp(startColor, endColor, boundedStartT)!;
        } else {
          paint
            ..color = Colors.white
            ..shader = ui.Gradient.linear(
              shaderStart,
              shaderEnd,
              <Color>[Color.lerp(startColor, endColor, boundedStartT)!, Color.lerp(startColor, endColor, boundedEndT)!],
              null,
              ui.TileMode.clamp,
            );
        }

        canvas.drawRect(shaderBounds, paint);
      }
    }

    canvas.restore();
  }

  double _gradientPosition(Offset point, Offset start, Offset vector, double lengthSquared) {
    final offset = point - start;
    return (offset.dx * vector.dx + offset.dy * vector.dy) / lengthSquared;
  }

  @override
  bool shouldRepaint(covariant _BoundedMiniPlayerGradientPainter oldDelegate) {
    return oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor ||
        oldDelegate.borderRadius != borderRadius;
  }
}
