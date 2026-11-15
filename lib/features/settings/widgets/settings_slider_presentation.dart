import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';

class SettingsSliderPresentation<T> extends StatelessWidget {
  const SettingsSliderPresentation({
    super.key,
    required this.label,
    required this.values,
    required this.valueLabels,
    required this.value,
    this.description,
    this.icon,
    this.tooltip,
    this.enabled = true,
    this.onChanged,
  });

  final String label;
  final List<T> values;
  final List<String> valueLabels;
  final T value;
  final String? description;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty || valueLabels.isEmpty || values.length != valueLabels.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          'Configuration error for slider: $label',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final index = values.indexOf(value);
    final safeIndex = index >= 0 && index < values.length ? index : 0;
    final isEnabled = enabled && onChanged != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SettingsControlLabel(label: label, description: description, enabled: isEnabled),
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null && tooltip != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Tooltip(
                        message: tooltip!,
                        child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  Text(
                    valueLabels[safeIndex],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isEnabled ? colorScheme.primary : theme.disabledColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (values.length > 1) ...[
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: colorScheme.primary,
                inactiveTrackColor: colorScheme.primaryContainer,
                thumbColor: colorScheme.primary,
                overlayColor: colorScheme.primary.withValues(alpha: 0.12),
                valueIndicatorTextStyle: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary),
                valueIndicatorColor: colorScheme.primary,
              ),
              child: Slider(
                min: 0,
                max: (values.length - 1).toDouble(),
                divisions: values.length - 1,
                value: safeIndex.toDouble(),
                label: valueLabels[safeIndex],
                onChanged: isEnabled ? (newIndex) => onChanged?.call(values[newIndex.round()]) : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _SliderEndpointLabel(label: valueLabels.first, enabled: isEnabled),
                  if (valueLabels.length > 2 && valueLabels.length.isOdd)
                    _SliderEndpointLabel(label: valueLabels[valueLabels.length ~/ 2], enabled: isEnabled),
                  _SliderEndpointLabel(label: valueLabels.last, enabled: isEnabled),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                valueLabels.first,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SliderEndpointLabel extends StatelessWidget {
  const _SliderEndpointLabel({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: enabled ? colors.onSurfaceVariant : colors.onSurfaceVariant.withValues(alpha: 0.38)),
    );
  }
}
