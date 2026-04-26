import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';

class SettingSwitch extends ConsumerWidget {
  final String label;
  final String? description;
  final String? disabledReason;
  final String? tooltip;
  final IconData? icon;
  final String settingKey;
  final ValueChanged<bool>? onChanged;
  final String? userId;
  final bool? defaultValue;
  final bool enabled;

  const SettingSwitch({
    super.key,
    required this.label,
    this.description,
    this.disabledReason,
    this.tooltip,
    this.icon,
    required this.settingKey,
    this.onChanged,
    this.userId,
    this.defaultValue,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final dynamic defaultValueDynamic = defaultSettings[settingKey];
    if (defaultValueDynamic is! bool) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'Error: Default value for $settingKey (type: ${defaultValueDynamic?.runtimeType}) is not of type bool.',
          style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
        ),
      );
    }

    final bool resolvedDefaultValue = defaultValue ?? defaultValueDynamic;
    final String? activeUserId = userId;
    if (activeUserId == null) {
      final settingAsyncValue = ref.watch(globalSettingByKeyProvider(settingKey));

      return settingAsyncValue.when(
        data: (stringValue) {
          final bool currentValue = SettingsParser.decodeValue<bool>(stringValue, resolvedDefaultValue);
          return _buildSwitchContent(context, currentValue, theme, textTheme, (bool newValue) {
            ref.read(settingsManagerProvider.notifier).setGlobalSetting<bool>(settingKey, newValue);
            onChanged?.call(newValue);
          });
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

    final appDatabase = ref.watch(appDatabaseProvider);

    return StreamBuilder<UserSettingEntry?>(
      stream: appDatabase.watchUserSetting(activeUserId, settingKey),
      builder: (context, snapshot) {
        final bool fallbackValue = ref
            .read(settingsManagerProvider.notifier)
            .getUserSetting<bool>(activeUserId, settingKey, defaultValue: resolvedDefaultValue);
        final bool currentValue = SettingsParser.decodeValue<bool>(snapshot.data?.value, fallbackValue);

        return _buildSwitchContent(context, currentValue, theme, textTheme, (bool newValue) {
          ref.read(settingsManagerProvider.notifier).setUserSetting<bool>(activeUserId, settingKey, newValue);
          onChanged?.call(newValue);
        });
      },
    );
  }

  Widget _buildSwitchContent(
    BuildContext context,
    bool currentValue,
    ThemeData theme,
    TextTheme textTheme,
    ValueChanged<bool> onValueChanged,
  ) {
    final details = <String>[
      if (description != null && description!.isNotEmpty) description!,
      if (!enabled && disabledReason != null && disabledReason!.isNotEmpty) disabledReason!,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
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
                    if (icon != null && tooltip != null)
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
              Switch(
                value: currentValue,
                onChanged: enabled ? onValueChanged : null,
                activeThumbColor: theme.colorScheme.primary,
                activeTrackColor: theme.colorScheme.primaryContainer,
                inactiveThumbColor: theme.colorScheme.outline,
                inactiveTrackColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ],
          ),
          if (details.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                details.join('\n'),
                style: textTheme.bodySmall?.copyWith(
                  color: enabled ? theme.colorScheme.onSurfaceVariant : theme.disabledColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
