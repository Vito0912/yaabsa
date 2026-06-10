import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingSlider<T> extends ConsumerWidget {
  final String label;
  final String? description;
  final String? disabledReason;
  final String? tooltip;
  final IconData? icon;
  final List<T> values;
  final List<String> valueLabels;
  final String settingKey;
  final ValueChanged<T>? onChanged;
  final bool enabled;

  const SettingSlider({
    super.key,
    required this.label,
    this.description,
    this.disabledReason,
    this.tooltip,
    this.icon,
    required this.values,
    required this.valueLabels,
    required this.settingKey,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsyncValue = ref.watch(globalSettingByKeyProvider(settingKey));
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return settingAsyncValue.when(
      data: (stringValue) {
        final dynamic defaultValueDynamic = defaultSettings[settingKey];
        if (defaultValueDynamic is! T) {
          if (values.isNotEmpty && defaultValueDynamic == null) {
            final T currentValue = SettingsParser.decodeValue<T>(stringValue, values.first);
            return _buildSliderContent(context, ref, currentValue, theme, textTheme);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Text(
              'Error: Default value for $settingKey (type: ${defaultValueDynamic?.runtimeType}) is not of type $T or values list is empty.',
              style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
            ),
          );
        }
        final T defaultValue = defaultValueDynamic;
        final T currentValue = SettingsParser.decodeValue<T>(stringValue, defaultValue);
        return _buildSliderContent(context, ref, currentValue, theme, textTheme);
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: textTheme.titleMedium?.copyWith(color: theme.disabledColor),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5)),
          ],
        ),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: textTheme.titleMedium?.copyWith(color: theme.colorScheme.error),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderContent(
    BuildContext context,
    WidgetRef ref,
    T currentValue,
    ThemeData theme,
    TextTheme textTheme,
  ) {
    if (values.isEmpty || valueLabels.isEmpty || values.length != valueLabels.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Text(
          'Configuration error for slider: $label',
          style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
        ),
      );
    }

    final colorScheme = theme.colorScheme;
    final int currentIndex = values.indexOf(currentValue);
    final int safeIndex = currentIndex >= 0 && currentIndex < values.length ? currentIndex : 0;
    final String currentDisplayValue = valueLabels[safeIndex];
    final isEnabled = enabled;

    final details = <String>[
      if (description != null && description!.isNotEmpty) description!,
      if (!enabled && disabledReason != null && disabledReason!.isNotEmpty) disabledReason!,
    ];
    final subtitleText = details.isEmpty ? null : details.join('\n');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isEnabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                    ),
                    if (subtitleText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitleText,
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null && tooltip != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Tooltip(
                        message: tooltip!,
                        child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  Text(
                    currentDisplayValue,
                    style: textTheme.bodyMedium?.copyWith(
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
                valueIndicatorTextStyle: textTheme.labelSmall?.copyWith(color: colorScheme.onPrimary),
                valueIndicatorColor: colorScheme.primary,
              ),
              child: Slider(
                min: 0,
                max: (values.length - 1).toDouble(),
                divisions: values.length - 1,
                value: safeIndex.toDouble(),
                label: valueLabels[safeIndex],
                onChanged: isEnabled
                    ? (double newIndex) {
                        final T newValue = values[newIndex.round()];
                        ref.read(settingsManagerProvider.notifier).setGlobalSetting<T>(settingKey, newValue);
                        onChanged?.call(newValue);
                      }
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    valueLabels.first,
                    style: textTheme.labelSmall?.copyWith(
                      color: isEnabled
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                    ),
                  ),
                  if (valueLabels.length > 2 && valueLabels.length.isOdd)
                    Text(
                      valueLabels[(valueLabels.length ~/ 2)],
                      style: textTheme.labelSmall?.copyWith(
                        color: isEnabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                      ),
                    ),
                  if (valueLabels.length > 1)
                    Text(
                      valueLabels.last,
                      style: textTheme.labelSmall?.copyWith(
                        color: isEnabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                      ),
                    ),
                ],
              ),
            ),
          ] else if (values.length == 1) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                valueLabels.first,
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
