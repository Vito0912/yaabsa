import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/settings_manager.dart';
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
      title: 'Caching - General',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: '/settings/caching',
      children: [
        SettingsNavigationSection(
          title: 'Caching Options',
          topPadding: 0,
          settings: [
            const SettingSwitchTile(label: 'Enable caching', settingKey: SettingKeys.caching),
            SettingSwitchTile(
              label: 'Speedup mode',
              subtitle: 'Combine caching with background refreshes to load faster',
              disabledReason: 'Enable response caching to use speedup mode',
              settingKey: SettingKeys.boostLoading,
              enabled: isCachingEnabled,
            ),
          ],
        ),
      ],
    );
  }
}
