import 'package:material_ui/material_ui.dart';

class SettingsControlLabel extends StatelessWidget {
  const SettingsControlLabel({
    super.key,
    required this.label,
    this.description,
    this.enabled = true,
    this.icon,
    this.tooltip,
  });

  final String label;
  final String? description;
  final bool enabled;
  final IconData? icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: enabled ? colors.onSurface : colors.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ),
            if (icon != null && tooltip != null)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Tooltip(
                  message: tooltip!,
                  child: Icon(icon, size: 20, color: colors.onSurfaceVariant),
                ),
              ),
          ],
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            description!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: enabled ? colors.onSurfaceVariant : colors.onSurfaceVariant.withValues(alpha: 0.38),
            ),
          ),
        ],
      ],
    );
  }
}
