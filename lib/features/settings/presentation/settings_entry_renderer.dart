import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/presentation/settings_pane_scope.dart';
import 'package:yaabsa/features/settings/widgets/settings_action_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_choice_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_focus_highlight.dart';
import 'package:yaabsa/features/settings/widgets/settings_number_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_slider_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_time_of_day_presentation.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';

class SettingsEntryRenderer extends ConsumerWidget {
  const SettingsEntryRenderer({
    super.key,
    required this.entry,
    required this.settingsContext,
    required this.availability,
    required this.focused,
    this.focusToken,
  });

  final SettingsEntrySpec entry;
  final SettingsContext settingsContext;
  final SettingsAvailability availability;
  final bool focused;
  final Object? focusToken;

  String? _joinSubtitle(String? description, String? disabledReason) {
    final parts = <String>[
      if (description != null && description.isNotEmpty) description,
      if (!availability.isEnabled && disabledReason != null && disabledReason.isNotEmpty) disabledReason,
    ];

    if (parts.isEmpty) {
      return null;
    }

    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = _buildEntry(context, ref);

    return SettingsFocusHighlight(focused: focused, focusToken: focusToken, child: child);
  }

  Widget _buildEntry(BuildContext context, WidgetRef ref) {
    final currentEntry = entry;
    final title = currentEntry.title(settingsContext);
    final description = currentEntry.description?.call(settingsContext);
    final tooltip = currentEntry.tooltip?.call(settingsContext);
    final disabledReason = availability.disabledReason;
    final isEnabled = availability.isEnabled;

    switch (currentEntry) {
      case SettingsNavEntry():
        return SettingsNavigationTile(
          item: SettingsNavigationItem(
            icon: currentEntry.icon ?? Icons.settings_outlined,
            title: title,
            subtitle: description,
            disabledReason: disabledReason,
            enabled: isEnabled,
            onTap: isEnabled
                ? () {
                    final override = currentEntry.onTapOverride;
                    if (override != null) {
                      override(context, ref);
                      return;
                    }

                    final paneScope = SettingsPaneScope.maybeOf(context);
                    if (paneScope?.onOpenRoute != null) {
                      paneScope!.onOpenRoute!(currentEntry.targetRoute);
                      return;
                    }

                    context.push(currentEntry.targetRoute);
                  }
                : null,
          ),
        );

      case SettingsToggleEntry():
        final currentValue = watchSettingDefinition(ref, currentEntry.definition, userId: settingsContext.userId);

        return SettingsSwitchPresentation(
          label: title,
          description: _joinSubtitle(description, disabledReason),
          value: currentValue,
          enabled: isEnabled,
          icon: currentEntry.icon,
          tooltip: tooltip,
          onChanged: isEnabled
              ? (nextValue) async {
                  if (currentEntry.onBeforeChanged != null) {
                    final shouldProceed = await currentEntry.onBeforeChanged!(context, nextValue);
                    if (!shouldProceed) {
                      return;
                    }
                  }

                  await writeSettingDefinition(ref, currentEntry.definition, nextValue, userId: settingsContext.userId);

                  if (currentEntry.onChanged != null) {
                    await currentEntry.onChanged!(ref, nextValue);
                  }
                }
              : null,
        );

      case SettingsChoiceEntry():
        return currentEntry.accept(<V>(typedEntry) => _buildChoice(context, ref, typedEntry));

      case SettingsSliderEntry():
        return currentEntry.accept(<V>(typedEntry) => _buildSlider(context, ref, typedEntry));

      case SettingsNumberEntry():
        final rawValue = watchSettingDefinition(ref, currentEntry.definition, userId: settingsContext.userId);
        final resolvedValue = (rawValue <= 0 && currentEntry.fallbackBuilder != null)
            ? currentEntry.fallbackBuilder!(settingsContext)
            : rawValue;

        return SettingsNumberPresentation(
          label: title,
          description: _joinSubtitle(description, disabledReason),
          value: resolvedValue,
          min: currentEntry.min,
          max: currentEntry.max,
          unitLabel: currentEntry.unitLabel?.call(settingsContext),
          icon: currentEntry.icon,
          tooltip: tooltip,
          enabled: isEnabled,
          onChanged: isEnabled
              ? (nextValue) {
                  unawaited(
                    writeSettingDefinition(ref, currentEntry.definition, nextValue, userId: settingsContext.userId),
                  );
                }
              : null,
        );

      case SettingsTimeOfDayEntry():
        final minutesOfDay = watchSettingDefinition(ref, currentEntry.definition, userId: settingsContext.userId);

        return SettingsTimeOfDayPresentation(
          label: title,
          description: _joinSubtitle(description, disabledReason),
          minutesOfDay: minutesOfDay,
          icon: currentEntry.icon,
          tooltip: tooltip,
          enabled: isEnabled,
          onChanged: isEnabled
              ? (nextMinutes) {
                  unawaited(
                    writeSettingDefinition(ref, currentEntry.definition, nextMinutes, userId: settingsContext.userId),
                  );
                }
              : null,
        );

      case SettingsActionEntry():
        return SettingsActionPresentation(
          label: title,
          description: _joinSubtitle(description, disabledReason),
          buttonLabel: currentEntry.buttonLabel(settingsContext),
          buttonIcon: currentEntry.buttonIcon,
          isDestructive: currentEntry.isDestructive,
          icon: currentEntry.icon,
          tooltip: tooltip,
          enabled: isEnabled,
          onPressed: isEnabled ? () => currentEntry.onPressed(context, ref) : null,
        );

      case SettingsCustomEntry():
        return currentEntry.builder(context, ref, settingsContext);
    }
  }

  Widget _buildChoice<V>(BuildContext context, WidgetRef ref, SettingsChoiceEntry<V> typedEntry) {
    final title = typedEntry.title(settingsContext);
    final description = typedEntry.description?.call(settingsContext);
    final tooltip = typedEntry.tooltip?.call(settingsContext);
    final isEnabled = availability.isEnabled;
    final options = typedEntry.optionsBuilder(settingsContext);

    final currentValue = typedEntry.valueResolver != null
        ? typedEntry.valueResolver!(settingsContext)
        : watchSettingDefinition<V>(ref, typedEntry.definition, userId: settingsContext.userId);

    return SettingsChoicePresentation<V>(
      label: title,
      description: _joinSubtitle(description, availability.disabledReason),
      options: options,
      value: currentValue,
      presentation: typedEntry.presentation,
      icon: typedEntry.icon,
      tooltip: tooltip,
      enabled: isEnabled,
      onChanged: isEnabled
          ? (nextValue) async {
              if (typedEntry.onValueSelected != null) {
                await typedEntry.onValueSelected!(context, ref, nextValue);
              } else {
                await writeSettingDefinition<V>(ref, typedEntry.definition, nextValue, userId: settingsContext.userId);
              }

              if (typedEntry.onChanged != null) {
                await typedEntry.onChanged!(ref, nextValue);
              }
            }
          : null,
    );
  }

  Widget _buildSlider<V>(BuildContext context, WidgetRef ref, SettingsSliderEntry<V> typedEntry) {
    final title = typedEntry.title(settingsContext);
    final description = typedEntry.description?.call(settingsContext);
    final tooltip = typedEntry.tooltip?.call(settingsContext);
    final isEnabled = availability.isEnabled;

    final currentValue = watchSettingDefinition<V>(ref, typedEntry.definition, userId: settingsContext.userId);

    final labels = typedEntry.values
        .map((value) => typedEntry.labelForValue(settingsContext, value))
        .toList(growable: false);

    return SettingsSliderPresentation<V>(
      label: title,
      description: _joinSubtitle(description, availability.disabledReason),
      icon: typedEntry.icon,
      tooltip: tooltip,
      values: typedEntry.values,
      valueLabels: labels,
      value: currentValue,
      enabled: isEnabled,
      onChanged: isEnabled
          ? (nextValue) async {
              await writeSettingDefinition<V>(ref, typedEntry.definition, nextValue, userId: settingsContext.userId);

              if (typedEntry.onChanged != null) {
                await typedEntry.onChanged!(ref, nextValue);
              }
            }
          : null,
    );
  }
}
