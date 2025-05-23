import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingSwitch extends ConsumerWidget {
  final String label;
  final String? description;
  final String? tooltip;
  final IconData? icon;
  final String settingKey;
  final ValueChanged<bool>? onChanged;

  const SettingSwitch({
    super.key,
    required this.label,
    this.description,
    this.tooltip,
    this.icon,
    required this.settingKey,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsyncValue = ref.watch(globalSettingByKeyProvider(settingKey));
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return settingAsyncValue.when(
      data: (stringValue) {
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
        final bool defaultValue = defaultValueDynamic;
        final bool currentValue = SettingsParser.decodeValue<bool>(stringValue, defaultValue);
        return _buildSwitchContent(context, ref, currentValue, theme, textTheme);
      },
      loading:
          () => Padding(
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
      error:
          (error, stackTrace) => Padding(
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

  Widget _buildSwitchContent(
    BuildContext context,
    WidgetRef ref,
    bool currentValue,
    ThemeData theme,
    TextTheme textTheme,
  ) {
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
                      child: Text(label, style: textTheme.titleMedium, overflow: TextOverflow.ellipsis, maxLines: 1),
                    ),
                    if (icon != null && tooltip != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Tooltip(
                          message: tooltip!,
                          child: Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                  ],
                ),
              ),
              Switch(
                value: currentValue,
                onChanged: (bool newValue) {
                  ref.read(globalSettingsManagerProvider.notifier).setSetting<bool>(settingKey, newValue);
                  onChanged?.call(newValue);
                },
                activeColor: theme.colorScheme.primary,
                activeTrackColor: theme.colorScheme.primaryContainer,
                inactiveThumbColor: theme.colorScheme.outline,
                inactiveTrackColor: theme.colorScheme.surfaceVariant,
              ),
            ],
          ),
          if (description != null && description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                description!,
                style: textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}
