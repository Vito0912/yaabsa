import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/features/settings/widgets/settings_control_status_presentation.dart';
import 'package:yaabsa/ui/components/lists/settings_control_label.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

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
            context.l10n.errorDropdownConfiguration(label),
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
              context.l10n.errorDropdownDefaultTypeMismatch(
                settingKey!,
                defaultValueDynamic?.runtimeType.toString() ?? context.l10n.statusUnknown,
              ),
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
      loading: () => SettingsControlStatusPresentation(label: label, state: SettingsControlLoadState.loading),
      error: (error, stackTrace) =>
          SettingsControlStatusPresentation(label: label, state: SettingsControlLoadState.error),
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
          context.l10n.errorDropdownConfiguration(label),
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
              child: SettingsControlLabel(
                label: label,
                description: description,
                enabled: enabled,
                icon: icon,
                tooltip: tooltip,
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
        title: SettingsControlLabel(
          label: label,
          description: currentDisplayValue,
          enabled: enabled,
          icon: icon,
          tooltip: tooltip,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(context.l10n.actionCancel),
                        ),
                      ],
                    );
                  },
                );
              }
            : null,
      );
    }
  }
}

class SettingMultiSelectDropdown<T> extends StatelessWidget {
  const SettingMultiSelectDropdown({
    super.key,
    required this.label,
    required this.values,
    required this.valueLabels,
    required this.selectedValues,
    required this.onValueChanged,
    this.description,
    this.emptyValueLabel,
    this.enabled = true,
    this.isLoading = false,
  });

  final String label;
  final String? description;
  final List<T> values;
  final List<String> valueLabels;
  final Iterable<T> selectedValues;
  final ValueChanged<List<T>> onValueChanged;
  final String? emptyValueLabel;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (values.length != valueLabels.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          context.l10n.errorDropdownConfiguration(label),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selected = selectedValues.toSet();
    final selectedLabels = <String>[
      for (int index = 0; index < values.length; index++)
        if (selected.contains(values[index])) valueLabels[index],
    ];
    final isEnabled = enabled && !isLoading && values.isNotEmpty;
    final selectedLabel = switch (selectedLabels.length) {
      0 => emptyValueLabel ?? context.l10n.statusNoneSelected,
      1 => selectedLabels.single,
      _ => context.l10n.selectedCount(selectedLabels.length),
    };

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      title: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: isEnabled ? colorScheme.onSurface : colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
      subtitle: Text(
        selectedLabel,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isEnabled ? colorScheme.onSurfaceVariant : colorScheme.onSurfaceVariant.withValues(alpha: 0.38),
        ),
      ),
      trailing: isLoading
          ? const SizedBox(height: 20, width: 20, child: YaabsaCircularProgressIndicator(strokeWidth: 2.5))
          : Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant.withValues(alpha: isEnabled ? 0.6 : 0.38),
            ),
      onTap: isEnabled ? () => _showSelectionDialog(context, initialSelection: selected) : null,
    );
  }

  Future<void> _showSelectionDialog(BuildContext context, {required Set<T> initialSelection}) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        var pendingSelection = Set<T>.from(initialSelection);

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(label),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (description != null && description!.isNotEmpty) ...[
                        Text(
                          description!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        const Divider(height: 24),
                      ],
                      for (int index = 0; index < values.length; index++) ...[
                        CheckboxListTile(
                          value: pendingSelection.contains(values[index]),
                          onChanged: (isSelected) {
                            setDialogState(() {
                              if (isSelected ?? false) {
                                pendingSelection.add(values[index]);
                              } else {
                                pendingSelection.remove(values[index]);
                              }
                            });
                          },
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(valueLabels[index]),
                        ),
                        if (index < values.length - 1) const Divider(height: 8, thickness: 0.5),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(dialogContext.l10n.actionCancel),
                ),
                FilledButton(
                  onPressed: () {
                    onValueChanged([
                      for (final value in values)
                        if (pendingSelection.contains(value)) value,
                    ]);
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(dialogContext.l10n.actionDone),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
