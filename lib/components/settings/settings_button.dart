import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingButton extends ConsumerWidget {
  final String label;
  final String? description;
  final String? tooltip;
  final IconData? icon;
  final String buttonText;
  final IconData? buttonIcon;
  final VoidCallback? onPressed;
  final bool isDestructive;
  final bool isLoading;

  const SettingButton({
    super.key,
    required this.label,
    this.description,
    this.tooltip,
    this.icon,
    required this.buttonText,
    this.buttonIcon,
    this.onPressed,
    this.isDestructive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final isEnabled = onPressed != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isEnabled
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (icon != null && tooltip != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Tooltip(
                          message: tooltip!,
                          child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                  ],
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: textTheme.bodySmall?.copyWith(
                      color: isEnabled
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
              : FilledButton.icon(
                  onPressed: onPressed,
                  icon: buttonIcon != null
                      ? Icon(buttonIcon, size: 16, color: isDestructive ? colorScheme.onError : colorScheme.onPrimary)
                      : const SizedBox.shrink(),
                  label: Text(
                    buttonText,
                    style: textTheme.labelMedium?.copyWith(
                      color: isDestructive ? colorScheme.onError : colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: isDestructive ? colorScheme.error : colorScheme.primary,
                    foregroundColor: isDestructive ? colorScheme.onError : colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
        ],
      ),
    );
  }
}
