import 'dart:async';

import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/features/settings/widgets/settings_slider_presentation.dart';
import 'package:yaabsa/features/settings/widgets/settings_control_status_presentation.dart';

class SettingSlider<T> extends ConsumerWidget {
  final String label;
  final String? description;
  final String? disabledReason;
  final String? tooltip;
  final IconData? icon;
  final List<T> values;
  final List<String> valueLabels;
  final String settingKey;
  final String? userId;
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
    this.userId,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    if (userId != null) {
      final appDatabase = ref.watch(appDatabaseProvider);
      return StreamBuilder<UserSettingEntry?>(
        stream: appDatabase.watchUserSetting(userId!, settingKey),
        builder: (context, snapshot) {
          final dynamic defaultValueDynamic = defaultSettings[settingKey];
          if (defaultValueDynamic is! T) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Text(
                'Error: Default value for $settingKey is not of type $T.',
                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
              ),
            );
          }

          final fallbackValue = ref
              .read(settingsManagerProvider.notifier)
              .getUserSetting<T>(userId, settingKey, defaultValue: defaultValueDynamic);
          final currentValue = SettingsParser.decodeValue<T>(snapshot.data?.value, fallbackValue);
          return _buildSliderContent(ref, currentValue);
        },
      );
    }

    final settingAsyncValue = ref.watch(globalSettingByKeyProvider(settingKey));

    return settingAsyncValue.when(
      data: (stringValue) {
        final dynamic defaultValueDynamic = defaultSettings[settingKey];
        if (defaultValueDynamic is! T) {
          if (values.isNotEmpty && defaultValueDynamic == null) {
            final T currentValue = SettingsParser.decodeValue<T>(stringValue, values.first);
            return _buildSliderContent(ref, currentValue);
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
        return _buildSliderContent(ref, currentValue);
      },
      loading: () => SettingsControlStatusPresentation(label: label, state: SettingsControlLoadState.loading),
      error: (error, stackTrace) =>
          SettingsControlStatusPresentation(label: label, state: SettingsControlLoadState.error),
    );
  }

  Widget _buildSliderContent(WidgetRef ref, T currentValue) {
    final details = <String>[
      if (description != null && description!.isNotEmpty) description!,
      if (!enabled && disabledReason != null && disabledReason!.isNotEmpty) disabledReason!,
    ];
    final subtitleText = details.isEmpty ? null : details.join('\n');

    return SettingsSliderPresentation<T>(
      label: label,
      description: subtitleText,
      icon: icon,
      tooltip: tooltip,
      values: values,
      valueLabels: valueLabels,
      value: currentValue,
      enabled: enabled,
      onChanged: enabled
          ? (newValue) {
              final settings = ref.read(settingsManagerProvider.notifier);
              if (userId == null) {
                unawaited(settings.setGlobalSetting<T>(settingKey, newValue));
              } else {
                unawaited(settings.setUserSetting<T>(userId, settingKey, newValue));
              }
              onChanged?.call(newValue);
            }
          : null,
    );
  }
}
