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
  final List<String>? valueDescriptions;
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
    this.valueDescriptions,
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
    this.valueDescriptions,
    required this.value,
    required this.onValueChanged,
    this.enabled = true,
    this.isLoading = false,
  }) : settingKey = null,
       onChanged = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (settingKey == null) {
      if (values.isEmpty || valueLabels.isEmpty || values.length != valueLabels.length) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
              enabled: enabled && !isLoading,
              onValueSelected: (newValue) {
                ref.read(settingsManagerProvider.notifier).setGlobalSetting<T>(settingKey!, newValue);
                onChanged?.call(newValue);
              },
            );
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
        return _buildDropdownContent(
          context,
          currentValue,
          enabled: enabled && !isLoading,
          onValueSelected: (newValue) {
            ref.read(settingsManagerProvider.notifier).setGlobalSetting<T>(settingKey!, newValue);
            onChanged?.call(newValue);
          },
        );
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

  Widget _buildDropdownContent(
    BuildContext context,
    T currentValue, {
    required bool enabled,
    required ValueChanged<T> onValueSelected,
  }) {
    if (values.isEmpty || valueLabels.isEmpty || values.length != valueLabels.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Text(
          'Configuration error for dropdown: $label',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final int currentIndex = values.indexOf(currentValue);
    final int safeIndex = currentIndex >= 0 && currentIndex < values.length ? currentIndex : 0;
    final String currentDisplayValue = valueLabels[safeIndex];

    final bool useFewOptionsInlineStyle = values.length <= 3;

    if (useFewOptionsInlineStyle) {
      return RadioGroup<T>(
        groupValue: currentValue,
        onChanged: (T? val) {
          if (enabled && val != null) {
            onValueSelected(val);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: enabled ? colorScheme.primary : colorScheme.primary.withValues(alpha: 0.38),
                    ),
                  ),
                  if (description != null && description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: enabled
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            for (int i = 0; i < values.length; i++) ...[
              InkWell(
                onTap: enabled ? () => onValueSelected(values[i]) : null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32, right: 20, top: 12, bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              valueLabels[i],
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: enabled
                                    ? (values[i] == currentValue ? colorScheme.primary : colorScheme.onSurface)
                                    : colorScheme.onSurface.withValues(alpha: 0.38),
                              ),
                            ),
                            if (valueDescriptions != null &&
                                i < valueDescriptions!.length &&
                                valueDescriptions![i].isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                valueDescriptions![i],
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: enabled
                                      ? colorScheme.onSurfaceVariant
                                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Radio<T>(value: values[i], activeColor: colorScheme.primary),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: enabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
        subtitle: Text(
          currentDisplayValue,
          style: theme.textTheme.bodySmall?.copyWith(
            color: enabled ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
          ),
        ),
        trailing: Row(
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
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant.withValues(alpha: enabled ? 0.6 : 0.38),
            ),
          ],
        ),
        onTap: enabled
            ? () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      title: Text(label),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: SingleChildScrollView(
                          child: RadioGroup<T>(
                            groupValue: currentValue,
                            onChanged: (T? val) {
                              if (val != null) {
                                onValueSelected(val);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (description != null && description!.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, right: 4.0),
                                    child: Text(
                                      description!,
                                      style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                                    ),
                                  ),
                                  const Divider(height: 16),
                                ],
                                for (int i = 0; i < values.length; i++) ...[
                                  ListTile(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    title: Text(
                                      valueLabels[i],
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: values[i] == currentValue ? colorScheme.primary : colorScheme.onSurface,
                                      ),
                                    ),
                                    subtitle:
                                        valueDescriptions != null &&
                                            i < valueDescriptions!.length &&
                                            valueDescriptions![i].isNotEmpty
                                        ? Text(
                                            valueDescriptions![i],
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          )
                                        : null,
                                    trailing: Radio<T>(value: values[i], activeColor: colorScheme.primary),
                                    onTap: () {
                                      onValueSelected(values[i]);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  if (i < values.length - 1) const Divider(height: 8, thickness: 0.5),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel'))],
                    );
                  },
                );
              }
            : null,
      );
    }
  }
}
