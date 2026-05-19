import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class CachingGeneralSettings extends ConsumerWidget {
  const CachingGeneralSettings({super.key});

  static const String routeName = '/settings/caching/general';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachingSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.caching)).asData?.value;
    final cachingDefault = defaultSettings[SettingKeys.caching] as bool? ?? true;
    final isCachingEnabled = SettingsParser.decodeValue<bool>(cachingSetting, cachingDefault);

    return SettingsPageScaffold(
      title: S.current.screensSettingsCachingGeneralSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: '/settings/caching',
      children: [
        SettingSwitchTile(
          label: S.current.screensSettingsCachingGeneralSettingsEnableCaching,
          settingKey: SettingKeys.caching,
        ),
        SettingSwitchTile(
          label: S.current.screensSettingsCachingGeneralSettingsSpeedupMode,
          subtitle: S.current.screensSettingsCachingGeneralSettingsSpeedupModeDescription,
          disabledReason: S.current.screensSettingsCachingGeneralSettingsEnableCachingDisabledReason,
          settingKey: SettingKeys.boostLoading,
          enabled: isCachingEnabled,
        ),
      ],
    );
  }
}
