import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';
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
      title: context.l10n.settingsCategoryGeneral,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: '/settings/caching',
      children: [
        SettingsNavigationSection(
          title: context.l10n.settingsCategoryCaching,
          topPadding: 0,
          settings: [
            SettingSwitchTile(
              label: context.l10n.settingEnableCaching,
              subtitle: context.l10n.settingEnableCachingDescription,
              settingKey: SettingKeys.caching,
            ),
            SettingSwitchTile(
              label: context.l10n.settingSpeedupMode,
              subtitle: context.l10n.settingSpeedupModeDescription,
              disabledReason: context.l10n.permissionCachingRequired,
              settingKey: SettingKeys.boostLoading,
              enabled: isCachingEnabled,
            ),
          ],
        ),
      ],
    );
  }
}
