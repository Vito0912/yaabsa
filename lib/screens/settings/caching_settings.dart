import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/caching/caching_general_settings.dart';
import 'package:yaabsa/screens/settings/caching/caching_route_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
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
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: 'Caching Subsettings',
          items: [
            SettingsNavigationItem(
              icon: Icons.tune_rounded,
              title: 'General',
              subtitle: 'Enable/disable caching and configure speedup mode behavior.',
              onTap: () => context.push(CachingGeneralSettings.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.route_rounded,
              title: 'Route Rules',
              subtitle: isCachingEnabled
                  ? 'Configure endpoint-level cache behavior.'
                  : 'Open route rules (editing is disabled until caching is enabled).',
              onTap: () => context.push(CachingRouteSettings.routeName),
            ),
          ],
        ),
      ],
    );
  }
}
