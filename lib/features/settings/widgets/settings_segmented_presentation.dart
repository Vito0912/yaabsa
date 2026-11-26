import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';

class SettingsSegmentedPresentation<T> extends StatelessWidget {
  const SettingsSegmentedPresentation({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.description,
    this.icon,
    this.tooltip,
    this.enabled = true,
  });

  final String label;
  final List<SettingsChoiceOption<T>> options;
  final T value;
  final ValueChanged<T>? onChanged;
  final String? description;
  final IconData? icon;
  final String? tooltip;
  final bool enabled;

  T _resolveSafeValue() {
    for (final option in options) {
      if (option.value == value) {
        return option.value;
      }
    }

    return options.first.value;
  }

  bool _fitsSegmented(BuildContext context, double maxWidth) {
    if (options.isEmpty || options.length > 5 || !maxWidth.isFinite) {
      return options.isNotEmpty && options.length <= 5;
    }

    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelLarge ?? const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);

    var widestSegment = 0.0;
    for (final option in options) {
      final painter = TextPainter(
        text: TextSpan(text: option.label, style: labelStyle),
        maxLines: 1,
        textDirection: textDirection,
        textScaler: textScaler,
      )..layout();

      final iconAllowance = option.icon != null ? 26.0 : 0.0;
      final segmentWidth = painter.width + iconAllowance + 32.0;
      widestSegment = math.max(widestSegment, segmentWidth);
    }

    return widestSegment * options.length <= maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && onChanged != null;

    if (options.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: SettingsControlLabel(
          label: label,
          description: description,
          enabled: isEnabled,
          icon: icon,
          tooltip: tooltip,
        ),
      );
    }

    final safeValue = _resolveSafeValue();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsControlLabel(
            label: label,
            description: description,
            enabled: isEnabled,
            icon: icon,
            tooltip: tooltip,
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              if (_fitsSegmented(context, constraints.maxWidth)) {
                return SegmentedButton<T>(
                  showSelectedIcon: false,
                  segments: [
                    for (final option in options)
                      ButtonSegment<T>(
                        value: option.value,
                        label: Text(option.label, overflow: TextOverflow.ellipsis, maxLines: 1),
                        icon: option.icon != null ? Icon(option.icon, size: 18) : null,
                      ),
                  ],
                  selected: <T>{safeValue},
                  onSelectionChanged: isEnabled
                      ? (selection) {
                          if (selection.isNotEmpty) {
                            onChanged?.call(selection.first);
                          }
                        }
                      : null,
                );
              }

              return _buildStackedFallback(context, safeValue, isEnabled);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStackedFallback(BuildContext context, T safeValue, bool isEnabled) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RadioGroup<T>(
      groupValue: safeValue,
      onChanged: (nextValue) {
        if (isEnabled && nextValue != null) {
          onChanged?.call(nextValue);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in options)
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: isEnabled ? () => onChanged?.call(option.value) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    if (option.icon != null) ...[
                      Icon(
                        option.icon,
                        size: 20,
                        color: isEnabled
                            ? (option.value == safeValue ? colorScheme.primary : colorScheme.onSurfaceVariant)
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        option.label,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isEnabled
                              ? (option.value == safeValue ? colorScheme.primary : colorScheme.onSurface)
                              : colorScheme.onSurface.withValues(alpha: 0.38),
                        ),
                      ),
                    ),
                    Radio<T>(value: option.value, activeColor: colorScheme.primary),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
