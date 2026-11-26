import 'dart:math' as math;

import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class YaabsaLoadingIndicator extends StatelessWidget {
  const YaabsaLoadingIndicator({super.key, this.size = 56, this.color, this.semanticLabel, this.semanticValue});

  final double size;
  final Color? color;
  final String? semanticLabel;
  final String? semanticValue;

  @override
  Widget build(BuildContext context) {
    final resolvedSize = math.max(1.0, size);

    if (resolvedSize < 24) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox.square(
          dimension: resolvedSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
            semanticsLabel: semanticLabel,
            semanticsValue: semanticValue,
          ),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: M3ELoadingIndicator(
        size: resolvedSize,
        color: color,
        semanticLabel: semanticLabel,
        semanticValue: semanticValue,
      ),
    );
  }
}

class YaabsaCircularProgressIndicator extends StatelessWidget {
  const YaabsaCircularProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.strokeWidth,
    this.semanticsLabel,
    this.semanticsValue,
    this.size,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final double? strokeWidth;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final indicatorSize = math.max(1.0, size ?? (value == null ? 56.0 : 40.0));
    final effectiveColor = valueColor?.value ?? color;

    if (indicatorSize < 24) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox.square(
          dimension: indicatorSize,
          child: CircularProgressIndicator(
            value: value,
            backgroundColor: backgroundColor,
            color: effectiveColor,
            valueColor: valueColor,
            strokeWidth: strokeWidth ?? 2,
            semanticsLabel: semanticsLabel,
            semanticsValue: semanticsValue,
          ),
        ),
      );
    }

    if (value == null) {
      return YaabsaLoadingIndicator(
        size: indicatorSize,
        color: effectiveColor,
        semanticLabel: semanticsLabel,
        semanticValue: semanticsValue,
      );
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: M3EProgressIndicator.circular(
        value: value,
        size: indicatorSize,
        strokeWidth: strokeWidth,
        color: effectiveColor,
        trackColor: backgroundColor,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
      ),
    );
  }
}

class YaabsaLinearProgressIndicator extends StatelessWidget {
  const YaabsaLinearProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.minHeight,
    this.borderRadius,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? color;
  final Animation<Color?>? valueColor;
  final double? minHeight;
  final BorderRadiusGeometry? borderRadius;
  final String? semanticsLabel;
  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = valueColor?.value ?? color;
    final indicator = M3EProgressIndicator.linear(
      value: value,
      linearSize: minHeight == null ? M3EProgressIndicatorSize.s : M3EProgressIndicatorSize.m,
      strokeWidth: minHeight,
      trackStrokeWidth: minHeight,
      color: effectiveColor,
      trackColor: backgroundColor,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
    );
    final radius = borderRadius;

    if (radius == null) {
      return indicator;
    }

    return ClipRRect(borderRadius: radius, child: indicator);
  }
}
