import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/screens/settings/caching/caching_general_settings.dart';
import 'package:yaabsa/screens/settings/caching/caching_route_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';

class CachingSettings extends StatelessWidget {
  const CachingSettings({super.key});

  static const String routeName = '/settings/caching';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.settingsCategoryCaching,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: context.l10n.settingsCategoryCaching,
          items: [
            SettingsNavigationItem(
              icon: Icons.tune_rounded,
              title: context.l10n.settingsCategoryGeneral,
              subtitle: context.l10n.messageCachingGeneral,
              onTap: () => context.push(CachingGeneralSettings.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.route_rounded,
              title: context.l10n.navCacheRouteRules,
              subtitle: context.l10n.messageCacheRouteRules,
              onTap: () => context.push(CachingRouteSettings.routeName),
            ),
          ],
        ),
      ],
    );
  }
}
