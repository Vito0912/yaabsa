import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingDropdown<T> extends ConsumerWidget {
  final String label;
  final String? description;
  final String? tooltip;
  final IconData? icon;
  final List<T> values;
  final List<String> valueLabels;
  final String? settingKey;
  final ValueChanged<T>? onChanged;
  final T? value;
  final ValueChanged<T>? onValueChanged;
  final bool enabled;
  final bool isLoading;

  const SettingDropdown({
    super.key,
    required this.label,
    this.description,
    this.tooltip,
    this.icon,
    required this.values,
    required this.valueLabels,
    required this.settingKey,
    this.onChanged,
    this.enabled = true,
    this.isLoading = false,
  }) : value = null,
       onValueChanged = null;

  const SettingDropdown.remote({
    super.key,
    required this.label,
    this.description,
    this.tooltip,
    this.icon,
    required this.values,
    required this.valueLabels,
    required this.value,
    required this.onValueChanged,
    this.enabled = true,
    this.isLoading = false,
  }) : settingKey = null,
       onChanged = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    if (settingKey == null) {
      if (values.isEmpty || valueLabels.isEmpty || values.length != valueLabels.length) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Configuration error for dropdown: $label',
            style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
          ),
        );
      }

      final fallbackValue = values.first;
      final resolvedValue = value != null && values.contains(value) ? value as T : fallbackValue;

      return _buildDropdownContent(
        context,
        resolvedValue,
        theme,
        textTheme,
        enabled: enabled && !isLoading,
        onValueSelected: (newValue) {
          onValueChanged?.call(newValue);
        },
      );
    }

    final settingAsyncValue = ref.watch(globalSettingByKeyProvider(settingKey!));

    return settingAsyncValue.when(
      data: (stringValue) {
        final dynamic defaultValueDynamic = defaultSettings[settingKey!];
        if (defaultValueDynamic is! T) {
          if (values.isNotEmpty && defaultValueDynamic == null) {
            final T currentValue = SettingsParser.decodeValue<T>(stringValue, values.first);
            return _buildDropdownContent(
              context,
              currentValue,
              theme,
              textTheme,
              enabled: enabled && !isLoading,
              onValueSelected: (newValue) {
                ref.read(settingsManagerProvider.notifier).setGlobalSetting<T>(settingKey!, newValue);
                onChanged?.call(newValue);
              },
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              'Error: Default value for $settingKey (type: ${defaultValueDynamic?.runtimeType}) is not of type $T or values list is empty.',
              style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
            ),
          );
        }
        final T defaultValue = defaultValueDynamic;
        final T currentValue = SettingsParser.decodeValue<T>(stringValue, defaultValue);
        return _buildDropdownContent(
          context,
          currentValue,
          theme,
          textTheme,
          enabled: enabled && !isLoading,
          onValueSelected: (newValue) {
            ref.read(settingsManagerProvider.notifier).setGlobalSetting<T>(settingKey!, newValue);
            onChanged?.call(newValue);
          },
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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

  Widget _buildDropdownContent(
    BuildContext context,
    T currentValue,
    ThemeData theme,
    TextTheme textTheme, {
    required bool enabled,
    required ValueChanged<T> onValueSelected,
  }) {
    if (values.isEmpty || valueLabels.isEmpty || values.length != valueLabels.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'Configuration error for dropdown: $label',
          style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
        ),
      );
    }

    final int currentIndex = values.indexOf(currentValue);
    final int safeIndex = currentIndex >= 0 && currentIndex < values.length ? currentIndex : 0;
    final T selectedValue = values[safeIndex];
    final bool hasTooltipIcon = icon != null && tooltip != null;

    final InputDecoration decoration = yaabsaFieldDecoration(context, label: '').copyWith(
      label: null,
      labelText: null,
      hintText: null,
      helperText: null,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );

    final List<YaabsaDropdownOption<T>> options = List.generate(
      values.length,
      (index) => YaabsaDropdownOption<T>(value: values[index], label: valueLabels[index]),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double dropdownWidth = (constraints.maxWidth * 0.45).clamp(120.0, 240.0);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        style: textTheme.titleMedium?.copyWith(color: enabled ? null : theme.disabledColor),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (description != null && description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Tooltip(
                          message: description!,
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(
                            Icons.info_outline,
                            size: 20,
                            color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
                          ),
                        ),
                      ),
                    if (hasTooltipIcon)
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Tooltip(
                          message: tooltip!,
                          child: Icon(
                            icon,
                            size: 20,
                            color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: dropdownWidth,
                child: YaabsaExpressiveDropdownField<T>(
                  value: selectedValue,
                  enabled: enabled,
                  options: options,
                  width: dropdownWidth,
                  decoration: decoration,
                  onChanged: enabled
                      ? (newValue) {
                          if (newValue != null) {
                            onValueSelected(newValue);
                          }
                        }
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
