import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
  });

  final double size;
  final String tooltip;
  final bool isPlaying;
  final bool isFinished;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double? progress;
  final IconData? iconOverride;

  @override
  Widget build(BuildContext context) {
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
    final icon =
        iconOverride ??
        (isPlaying
            ? Icons.pause_rounded
            : isFinished
            ? Icons.replay_rounded
            : Icons.play_arrow_rounded);
    final iconSize = isFinished ? size / 2 : size * 0.45;
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
                : Icon(icon, color: foregroundColor, size: iconSize),
          ),
        ],
      ),
    );
  }
}
