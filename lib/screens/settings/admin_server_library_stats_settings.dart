import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/admin_server_library_stats_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerLibraryStatsSettings extends StatelessWidget {
  const AdminServerLibraryStatsSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerLibraryStats;

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.navLibraryStats,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: SettingsRoutes.adminServer,
      maxWidth: 1280,
      children: const [AdminServerLibraryStatsView()],
    );
  }
}
