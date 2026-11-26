import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/rss_feeds/admin_server_rss_feeds_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_settings_pane_layout.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerRssFeedsSettings extends StatelessWidget {
  const AdminServerRssFeedsSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerRssFeeds;

  @override
  Widget build(BuildContext context) {
    return AdminSettingsPaneLayout(
      title: context.l10n.navRssFeeds,
      maxWidth: 1040,
      child: const AdminServerRssFeedsView(),
    );
  }
}
