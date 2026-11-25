import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

enum YaabsaActionTone { neutral, primary, danger }

enum YaabsaActionButtonVariant { plain, filled, filledTonal, outlined }

enum YaabsaActionButtonShape { round, rounded }

class YaabsaActionIconButton extends StatelessWidget {
  const YaabsaActionIconButton({
    super.key,
    this.icon,
    this.iconWidget,
    required this.tooltip,
    required this.onPressed,
    this.onLongPress,
    this.tone = YaabsaActionTone.neutral,
    this.enabled = true,
    this.iconSize = 19,
    this.isLoading = false,
    this.compact = true,
    this.buttonSize,
    this.variant,
    this.shape,
  }) : assert(icon != null || iconWidget != null);

  final IconData? icon;
  final Widget? iconWidget;
  final String tooltip;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final YaabsaActionTone tone;
  final bool enabled;
  final double iconSize;
  final bool isLoading;
  final bool compact;
  final double? buttonSize;
  final YaabsaActionButtonVariant? variant;
  final YaabsaActionButtonShape? shape;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isInteractive = enabled && !isLoading;
    final iconColor = isInteractive ? _toneColor(colorScheme) : colorScheme.onSurfaceVariant.withValues(alpha: 0.42);
    final buttonVariant =
        variant ??
        (tone == YaabsaActionTone.danger ? YaabsaActionButtonVariant.outlined : YaabsaActionButtonVariant.plain);
    final buttonShape =
        shape ?? (tone == YaabsaActionTone.danger ? YaabsaActionButtonShape.rounded : YaabsaActionButtonShape.round);
    final loadingColor = switch (buttonVariant) {
      YaabsaActionButtonVariant.filled => colorScheme.onPrimary,
      YaabsaActionButtonVariant.filledTonal => colorScheme.onSecondaryContainer,
      YaabsaActionButtonVariant.plain || YaabsaActionButtonVariant.outlined => _toneColor(colorScheme),
    };
    final icon = isLoading
        ? YaabsaCircularProgressIndicator(
            size: iconSize,
            color: loadingColor,
            semanticsLabel: context.l10n.statusLoadingAction(tooltip),
          )
        : iconWidget ??
              Icon(
                this.icon!,
                size: iconSize,
                color: buttonVariant == YaabsaActionButtonVariant.plain ? iconColor : null,
              );
    final filledBackground = switch (buttonVariant) {
      YaabsaActionButtonVariant.filled => colorScheme.primary,
      YaabsaActionButtonVariant.filledTonal => colorScheme.secondaryContainer,
      YaabsaActionButtonVariant.plain || YaabsaActionButtonVariant.outlined => null,
    };
    final buttonStyle = IconButton.styleFrom(
      minimumSize: buttonSize == null ? null : Size.square(buttonSize!),
      foregroundColor: tone == YaabsaActionTone.danger ? _toneColor(colorScheme) : null,
      backgroundColor: isLoading ? filledBackground : null,
      disabledBackgroundColor: isLoading ? filledBackground : null,
      shape: switch (buttonShape) {
        YaabsaActionButtonShape.round => const CircleBorder(),
        YaabsaActionButtonShape.rounded => RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      },
    );
    final density = compact ? VisualDensity.compact : VisualDensity.standard;
    final pressed = isInteractive ? onPressed : null;
    final longPressed = isInteractive ? onLongPress : null;

    return switch (buttonVariant) {
      YaabsaActionButtonVariant.plain => IconButton(
        tooltip: tooltip,
        visualDensity: density,
        style: buttonStyle,
        iconSize: iconSize,
        onPressed: pressed,
        onLongPress: longPressed,
        icon: icon,
      ),
      YaabsaActionButtonVariant.filled => IconButton.filled(
        tooltip: tooltip,
        visualDensity: density,
        style: buttonStyle,
        iconSize: iconSize,
        onPressed: pressed,
        onLongPress: longPressed,
        icon: icon,
      ),
      YaabsaActionButtonVariant.filledTonal => IconButton.filledTonal(
        tooltip: tooltip,
        visualDensity: density,
        style: buttonStyle,
        iconSize: iconSize,
        onPressed: pressed,
        onLongPress: longPressed,
        icon: icon,
      ),
      YaabsaActionButtonVariant.outlined => IconButton.outlined(
        tooltip: tooltip,
        visualDensity: density,
        style: buttonStyle,
        iconSize: iconSize,
        onPressed: pressed,
        onLongPress: longPressed,
        icon: icon,
      ),
    };
  }

  Color _toneColor(ColorScheme colorScheme) {
    switch (tone) {
      case YaabsaActionTone.primary:
        return colorScheme.primary;
      case YaabsaActionTone.danger:
        return colorScheme.error;
      case YaabsaActionTone.neutral:
        return colorScheme.onSurfaceVariant;
    }
  }
}

class YaabsaDeleteIconButton extends StatelessWidget {
  const YaabsaDeleteIconButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.enabled = true,
    this.iconSize = 19,
    this.buttonSize,
    this.compact = true,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final bool enabled;
  final double iconSize;
  final double? buttonSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEnabled = enabled && onPressed != null;
    final iconColor = isEnabled ? colorScheme.error : colorScheme.onSurfaceVariant.withValues(alpha: 0.42);

    return YaabsaActionIconButton(
      iconWidget: Icon(Icons.delete_outline_rounded, size: iconSize, color: iconColor),
      tooltip: tooltip,
      onPressed: onPressed,
      enabled: isEnabled,
      buttonSize: buttonSize,
      compact: compact,
      tone: YaabsaActionTone.danger,
      variant: YaabsaActionButtonVariant.outlined,
      shape: YaabsaActionButtonShape.rounded,
    );
  }
}
