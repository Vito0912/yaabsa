import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/setting_key.dart';

class CachingRouteSettings extends ConsumerWidget {
  const CachingRouteSettings({super.key});

  static const String routeName = '/settings/caching/routes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachingSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.caching)).asData?.value;
    final cachingDefault = defaultSettings[SettingKeys.caching] as bool? ?? true;
    final isCachingEnabled = SettingsParser.decodeValue<bool>(cachingSetting, cachingDefault);

    return SettingsPageScaffold(
      title: 'Caching - Routes',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: '/settings/caching',
      children: [
        SettingsNavigationSection(
          title: 'Route Cache Rules',
          topPadding: 0,
          settings: cacheRouteDefinitions.map((route) {
            final subtitle = route.aggressiveCache
                ? '${route.pathPattern}\nWarning: Enabling this could lead to odd behavior with multiple devices'
                : route.pathPattern;

            return SettingSwitchTile(
              label: route.label,
              subtitle: subtitle,
              disabledReason: 'Enable response caching to change route-level cache behavior',
              settingKey: route.settingKey,
              enabled: isCachingEnabled,
            );
          }).toList(),
        ),
      ],
    );
  }
}
