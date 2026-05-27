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

    final ButtonStyle baseEntryStyle = MenuItemButton.styleFrom(
      padding: const EdgeInsetsDirectional.only(start: 8, end: 10),
      minimumSize: const Size.fromHeight(44),
      textStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    final List<DropdownMenuEntry<T>> entries = List.generate(values.length, (index) {
      final bool isSelected = values[index] == selectedValue;
      final Color foregroundColor = isSelected ? theme.colorScheme.onSecondaryContainer : theme.colorScheme.onSurface;

      return DropdownMenuEntry<T>(
        value: values[index],
        label: valueLabels[index],
        trailingIcon: isSelected ? Icon(Icons.check_rounded, size: 18, color: foregroundColor) : null,
        style: baseEntryStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll<Color?>(
            isSelected ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.78) : null,
          ),
          foregroundColor: WidgetStatePropertyAll<Color?>(foregroundColor),
          iconColor: WidgetStatePropertyAll<Color?>(foregroundColor),
        ),
      );
    });

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: textTheme.titleMedium?.copyWith(color: enabled ? null : theme.disabledColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          if (description != null && description!.isNotEmpty)
                            Text(
                              description!,
                              style: textTheme.bodySmall?.copyWith(
                                color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
                              ),
                            ),
                        ],
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
                child: DropdownMenuFormField<T>(
                  initialSelection: selectedValue,
                  enabled: enabled,
                  width: dropdownWidth,
                  menuHeight: 320,
                  selectOnly: true,
                  requestFocusOnTap: false,
                  dropdownMenuEntries: entries,
                  trailingIcon: Icon(Icons.keyboard_arrow_down_rounded, color: theme.colorScheme.onSurfaceVariant),
                  selectedTrailingIcon: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  alignmentOffset: const Offset(0, 4),
                  menuStyle: MenuStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(theme.colorScheme.surfaceContainerHigh),
                    surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                    elevation: const WidgetStatePropertyAll<double>(3),
                    shape: WidgetStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 4)),
                  ),
                  textStyle: textTheme.bodyMedium?.copyWith(
                    color: enabled ? theme.colorScheme.onSurface : theme.disabledColor,
                    fontWeight: FontWeight.w500,
                  ),
                  decorationBuilder: (context, _) => decoration,
                  onSelected: enabled
                      ? (T? newValue) {
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
