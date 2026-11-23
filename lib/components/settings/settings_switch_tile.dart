import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class SettingSwitchTile extends ConsumerWidget {
  const SettingSwitchTile({
    super.key,
    required this.label,
    required this.settingKey,
    this.subtitle,
    this.disabledReason,
    this.tooltip,
    this.icon,
    this.userId,
    this.enabled = true,
    this.defaultValue,
    this.onChanged,
    this.onBeforeChanged,
    this.isLoading = false,
  }) : value = null,
       onValueChanged = null;

  const SettingSwitchTile.remote({
    super.key,
    required this.label,
    required this.value,
    required this.onValueChanged,
    this.subtitle,
    this.disabledReason,
    this.tooltip,
    this.icon,
    this.enabled = true,
    this.isLoading = false,
  }) : settingKey = null,
       userId = null,
       defaultValue = null,
       onChanged = null,
       onBeforeChanged = null;

  final String label;
  final String? settingKey;
  final String? subtitle;
  final String? disabledReason;
  final String? tooltip;
  final IconData? icon;
  final String? userId;
  final bool enabled;
  final bool? defaultValue;
  final ValueChanged<bool>? onChanged;
  final FutureOr<bool> Function(BuildContext context, bool newValue)? onBeforeChanged;
  final bool? value;
  final ValueChanged<bool>? onValueChanged;
  final bool isLoading;

  Widget _buildTile(bool currentValue, ValueChanged<bool>? onChangedHandler, String? subtitleText) {
    final isEnabled = onChangedHandler != null && enabled;

    return SettingsSwitchPresentation(
      label: label,
      description: subtitleText,
      value: currentValue,
      onChanged: onChangedHandler,
      enabled: isEnabled,
      icon: icon,
      tooltip: tooltip,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleParts = <String>[
      if (subtitle != null && subtitle!.isNotEmpty) subtitle!,
      if (!enabled && disabledReason != null && disabledReason!.isNotEmpty) disabledReason!,
    ];
    final subtitleText = subtitleParts.isEmpty ? null : subtitleParts.join('\n');

    if (settingKey == null) {
      if (value == null) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Text(
            'Error: remote switch value for $label is null.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        );
      }

      return _buildTile(value!, enabled && !isLoading ? onValueChanged : null, subtitleText);
    }

    final settingKeyValue = settingKey!;
    final defaultValueDynamic = defaultSettings[settingKeyValue];
    if (defaultValueDynamic is! bool && defaultValue == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Text(
          'Error: Default value for $settingKeyValue must be bool.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final bool resolvedDefaultValue = defaultValue ?? (defaultValueDynamic as bool? ?? false);
    final String? activeUserId = userId;

    if (activeUserId == null) {
      final settingAsync = ref.watch(globalSettingByKeyProvider(settingKeyValue));

      return settingAsync.when(
        data: (stringValue) {
          final currentValue = SettingsParser.decodeValue<bool>(stringValue, resolvedDefaultValue);
          return _buildTile(
            currentValue,
            enabled && !isLoading
                ? onBeforeChanged == null
                      ? (newValue) {
                          ref.read(settingsManagerProvider.notifier).setGlobalSetting<bool>(settingKeyValue, newValue);
                          onChanged?.call(newValue);
                        }
                      : (newValue) async {
                          final shouldChange = await onBeforeChanged!(context, newValue);
                          if (!shouldChange) return;
                          await ref
                              .read(settingsManagerProvider.notifier)
                              .setGlobalSetting<bool>(settingKeyValue, newValue);
                          onChanged?.call(newValue);
                        }
                : null,
            subtitleText,
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: SizedBox(width: 20, height: 20, child: YaabsaCircularProgressIndicator(strokeWidth: 2.5)),
        ),
        error: (error, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Text(
            'Failed to load $label setting: $error',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    final appDatabase = ref.watch(appDatabaseProvider);

    return StreamBuilder<UserSettingEntry?>(
      stream: appDatabase.watchUserSetting(activeUserId, settingKeyValue),
      builder: (context, snapshot) {
        final bool fallbackValue = ref
            .read(settingsManagerProvider.notifier)
            .getUserSetting<bool>(activeUserId, settingKeyValue, defaultValue: resolvedDefaultValue);
        final bool currentValue = SettingsParser.decodeValue<bool>(snapshot.data?.value, fallbackValue);

        return _buildTile(
          currentValue,
          enabled && !isLoading
              ? onBeforeChanged == null
                    ? (newValue) {
                        ref
                            .read(settingsManagerProvider.notifier)
                            .setUserSetting<bool>(activeUserId, settingKeyValue, newValue);
                        onChanged?.call(newValue);
                      }
                    : (newValue) async {
                        final shouldChange = await onBeforeChanged!(context, newValue);
                        if (!shouldChange) return;
                        await ref
                            .read(settingsManagerProvider.notifier)
                            .setUserSetting<bool>(activeUserId, settingKeyValue, newValue);
                        onChanged?.call(newValue);
                      }
              : null,
          subtitleText,
        );
      },
    );
  }
}
