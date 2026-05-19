import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/admin_server_library_stats_view.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class AdminServerLibraryStatsSettings extends StatelessWidget {
  const AdminServerLibraryStatsSettings({super.key});

  static const String routeName = '/settings/admin-server/library-stats';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: S.current.screensSettingsAdminServerLibraryStatsSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: AdminServerSettings.routeName,
      maxWidth: 1100,
      children: const [AdminServerLibraryStatsView()],
    );
  }
}
