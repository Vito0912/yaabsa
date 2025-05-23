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
    final TextTheme textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(label, style: textTheme.titleMedium, overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                    if (icon != null && tooltip != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Tooltip(
                          message: tooltip!,
                          child: Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child:
                    isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5))
                        : ElevatedButton.icon(
                          onPressed: onPressed,
                          icon:
                              buttonIcon != null
                                  ? Icon(
                                    buttonIcon,
                                    size: 18,
                                    color: isDestructive ? theme.colorScheme.onError : theme.colorScheme.onPrimary,
                                  )
                                  : const SizedBox.shrink(),
                          label: Text(
                            buttonText,
                            style: textTheme.labelMedium?.copyWith(
                              color: isDestructive ? theme.colorScheme.onError : theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDestructive ? theme.colorScheme.error : theme.colorScheme.primary,
                            foregroundColor: isDestructive ? theme.colorScheme.onError : theme.colorScheme.onPrimary,
                            elevation: 2,
                            shadowColor: theme.colorScheme.shadow.withOpacity(0.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ).copyWith(
                            overlayColor: WidgetStateProperty.all(
                              (isDestructive ? theme.colorScheme.onError : theme.colorScheme.onPrimary).withOpacity(
                                0.1,
                              ),
                            ),
                          ),
                        ),
              ),
            ],
          ),
          if (description != null && description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                description!,
                style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}
