import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_category.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/setting_key.dart';

class CachingSettings extends ConsumerWidget {
  const CachingSettings({super.key});

  static const String routeName = '/settings/caching';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachingSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.caching)).asData?.value;
    final cachingDefault = defaultSettings[SettingKeys.caching] as bool? ?? true;
    final isCachingEnabled = SettingsParser.decodeValue<bool>(cachingSetting, cachingDefault);

    return SettingsPageScaffold(
      title: 'Caching Settings',
      children: [
        const SettingsCategory(title: 'Cache Controls', icon: Icons.tune_rounded, topPadding: 10),
        const SettingSwitchTile(label: 'Enable caching', settingKey: SettingKeys.caching),
        SettingSwitchTile(
          label: 'Speedup mode',
          subtitle:
              'Combines caching with refresing the cache after each request. This can give you stale data, but after one refresh the newest data will be loaded',
          disabledReason: 'Enable response caching to use speedup mode.',
          settingKey: SettingKeys.boostLoading,
          enabled: isCachingEnabled,
        ),
        const SettingsCategory(
          title: 'Caching',
          description: 'Choose exactly which endpoints are cacheable.',
          icon: Icons.route_rounded,
        ),
        ...cacheRouteDefinitions.map((route) {
          final subtitle = route.aggressiveCache
              ? '${route.pathPattern}\nWarning: Enabling this could lead to weird behaviour with multiple devices'
              : route.pathPattern;

          return SettingSwitchTile(
            label: route.label,
            subtitle: subtitle,
            disabledReason: 'Enable response caching to configure route-level caching.',
            settingKey: route.settingKey,
            enabled: isCachingEnabled,
          );
        }),
      ],
    );
  }
}
