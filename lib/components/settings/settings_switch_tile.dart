import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';

class SettingSwitchTile extends ConsumerWidget {
  const SettingSwitchTile({
    super.key,
    required this.label,
    required this.settingKey,
    this.subtitle,
    this.disabledReason,
    this.enabled = true,
    this.defaultValue,
    this.onChanged,
  });

  final String label;
  final String settingKey;
  final String? subtitle;
  final String? disabledReason;
  final bool enabled;
  final bool? defaultValue;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultValueDynamic = defaultSettings[settingKey];
    if (defaultValueDynamic is! bool && defaultValue == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'Error: Default value for $settingKey must be bool.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final fallback = defaultValue ?? (defaultValueDynamic as bool? ?? false);
    final settingAsync = ref.watch(globalSettingByKeyProvider(settingKey));

    return settingAsync.when(
      data: (stringValue) {
        final currentValue = SettingsParser.decodeValue<bool>(stringValue, fallback);
        final subtitleParts = <String>[
          if (subtitle != null && subtitle!.isNotEmpty) subtitle!,
          if (!enabled && disabledReason != null && disabledReason!.isNotEmpty) disabledReason!,
        ];

        return SwitchListTile.adaptive(
          value: currentValue,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          title: Text(label, style: Theme.of(context).textTheme.titleSmall),
          subtitle: subtitleParts.isEmpty
              ? null
              : Text(
                  subtitleParts.join('\n'),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
          onChanged: enabled
              ? (newValue) {
                  ref.read(settingsManagerProvider.notifier).setGlobalSetting<bool>(settingKey, newValue);
                  onChanged?.call(newValue);
                }
              : null,
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5)),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'Failed to load $label setting: $error',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
