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
    this.enabled = true,
    this.isLoading = false,
  }) : settingKey = null,
       defaultValue = null,
       onChanged = null;

  final String label;
  final String? settingKey;
  final String? subtitle;
  final String? disabledReason;
  final bool enabled;
  final bool? defaultValue;
  final ValueChanged<bool>? onChanged;
  final bool? value;
  final ValueChanged<bool>? onValueChanged;
  final bool isLoading;

  Widget _buildTile(
    BuildContext context,
    bool currentValue,
    ValueChanged<bool>? onChangedHandler,
    String? subtitleText,
  ) {
    return SwitchListTile.adaptive(
      value: currentValue,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      subtitle: subtitleText == null
          ? null
          : Text(
              subtitleText,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
      secondary: isLoading
          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2.2))
          : null,
      onChanged: onChangedHandler,
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Error: remote switch value for $label is null.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
          ),
        );
      }

      return _buildTile(context, value!, enabled && !isLoading ? onValueChanged : null, subtitleText);
    }

    final settingKeyValue = settingKey!;
    final defaultValueDynamic = defaultSettings[settingKeyValue];
    if (defaultValueDynamic is! bool && defaultValue == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'Error: Default value for $settingKeyValue must be bool.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      );
    }

    final fallback = defaultValue ?? (defaultValueDynamic as bool? ?? false);
    final settingAsync = ref.watch(globalSettingByKeyProvider(settingKeyValue));

    return settingAsync.when(
      data: (stringValue) {
        final currentValue = SettingsParser.decodeValue<bool>(stringValue, fallback);
        return _buildTile(
          context,
          currentValue,
          enabled && !isLoading
              ? (newValue) {
                  ref.read(settingsManagerProvider.notifier).setGlobalSetting<bool>(settingKeyValue, newValue);
                  onChanged?.call(newValue);
                }
              : null,
          subtitleText,
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
