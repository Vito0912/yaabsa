import 'dart:math' as math;
import 'dart:ui' show PathMetric;

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

enum YaabsaMediaPlayButtonStyle { circular, scalloped }

const yaabsaScallopedPlayShape = StarBorder(
  points: 10,
  innerRadiusRatio: 0.86,
  pointRounding: 0.5,
  valleyRounding: 0.5,
);

class YaabsaMediaPlayButton extends StatelessWidget {
  const YaabsaMediaPlayButton({
    super.key,
    required this.size,
    required this.tooltip,
    required this.isPlaying,
    required this.isFinished,
    required this.isLoading,
    required this.onPressed,
    this.progress,
    this.iconOverride,
    this.style = YaabsaMediaPlayButtonStyle.circular,
    this.iconSize,
  });

  final double size;
  final String tooltip;
  final bool isPlaying;
  final bool isFinished;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double? progress;
  final IconData? iconOverride;
  final YaabsaMediaPlayButtonStyle style;
  final double? iconSize;

  IconData get _resolvedIcon {
    if (iconOverride != null) {
      return iconOverride!;
    }
    if (isPlaying) {
      return Icons.pause_rounded;
    }
    if (isFinished) {
      return Icons.replay_rounded;
    }
    return Icons.play_arrow_rounded;
  }

  @override
  Widget build(BuildContext context) {
    if (style == YaabsaMediaPlayButtonStyle.scalloped) {
      return _buildScallopedButton(context);
    }

    return _buildCircularButton(context);
  }

  Widget _buildCircularButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final showProgress = progress != null && progress! > 0 && !isFinished;
    final isEnabled = onPressed != null && !isLoading;
    final backgroundColor = !isEnabled
        ? colorScheme.surfaceContainerHighest
        : isFinished
        ? colorScheme.primary
        : colorScheme.surface.withAlpha(230);
    final foregroundColor = !isEnabled
        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6)
        : isFinished
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;
    final resolvedIconSize = iconSize ?? (isFinished ? size / 2 : size * 0.45);
    final backgroundSize = showProgress ? size - 8 : size;
    final progressValue = progress?.clamp(0.0, 1.0).toDouble();

    return SizedBox.square(
      dimension: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            key: const ValueKey('yaabsa-media-play-background'),
            width: backgroundSize,
            height: backgroundSize,
            decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
          ),
          if (showProgress)
            SizedBox.square(
              key: const ValueKey('yaabsa-media-play-progress-ring'),
              dimension: size,
              child: YaabsaCircularProgressIndicator(
                value: progressValue,
                strokeWidth: 3,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
          IconButton(
            tooltip: tooltip,
            onPressed: isLoading ? null : onPressed,
            constraints: BoxConstraints.tightFor(width: size, height: size),
            padding: EdgeInsets.zero,
            splashRadius: size * 0.25,
            icon: isLoading
                ? SizedBox.square(
                    dimension: size * 0.45,
                    child: YaabsaCircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                    ),
                  )
                : Icon(_resolvedIcon, color: foregroundColor, size: resolvedIconSize),
          ),
        ],
      ),
    );
  }

  Widget _buildScallopedButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resolvedIconSize = iconSize ?? 36.0;
    final progressValue = progress?.clamp(0.0, 1.0).toDouble();

    final button = Padding(
      padding: const EdgeInsets.all(3),
      child: IconButton.filled(
        style: IconButton.styleFrom(
          shape: yaabsaScallopedPlayShape,
          padding: EdgeInsets.zero,
          backgroundColor: colorScheme.primary.withValues(alpha: 0.90),
          foregroundColor: colorScheme.onPrimary,
        ),
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        onPressed: isLoading ? null : onPressed,
        tooltip: tooltip,
        icon: isLoading
            ? SizedBox.square(
                dimension: resolvedIconSize * 0.6,
                child: YaabsaCircularProgressIndicator(
                  strokeWidth: 2,
                  size: resolvedIconSize * 0.6,
                  valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                ),
              )
            : Icon(_resolvedIcon, size: resolvedIconSize),
      ),
    );

    return SizedBox.square(
      dimension: size,
      child: progressValue == null
          ? button
          : CustomPaint(
              key: const ValueKey('yaabsa-media-play-scalloped-border'),
              painter: _ScallopedProgressBorderPainter(
                fraction: progressValue,
                color: colorScheme.primary,
                trackColor: colorScheme.onSurface.withValues(alpha: 0.22),
              ),
              child: button,
            ),
    );
  }
}

class _ScallopedProgressBorderPainter extends CustomPainter {
  const _ScallopedProgressBorderPainter({required this.fraction, required this.color, required this.trackColor});

  final double fraction;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = (Offset.zero & size).deflate(1);
    final path = yaabsaScallopedPlayShape.getOuterPath(bounds);
    final paint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paint);

    if (fraction <= 0) {
      return;
    }

    paint.color = color;
    for (final metric in path.computeMetrics()) {
      final start = _topOffset(metric, bounds.center.dx);
      final end = start + metric.length * fraction;
      final progress = metric.extractPath(start, math.min(end, metric.length));
      if (end > metric.length) {
        final wrapped = metric.extractPath(0, end - metric.length);
        progress.extendWithPath(wrapped, Offset.zero);
      }
      canvas.drawPath(progress, paint);
    }
  }

  double _topOffset(PathMetric metric, double centerX) {
    var lower = 0.0;
    var upper = metric.length / yaabsaScallopedPlayShape.points;
    for (var step = 0; step < 24; step++) {
      final middle = (lower + upper) / 2;
      final point = metric.getTangentForOffset(middle)?.position;
      if (point == null) {
        return 0;
      }

      if (point.dx < centerX) {
        lower = middle;
      } else {
        upper = middle;
      }
    }

    return (lower + upper) / 2;
  }

  @override
  bool shouldRepaint(_ScallopedProgressBorderPainter oldDelegate) {
    return fraction != oldDelegate.fraction || color != oldDelegate.color || trackColor != oldDelegate.trackColor;
  }
}
