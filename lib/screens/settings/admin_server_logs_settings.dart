import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/admin_server_logs_view.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class AdminServerLogsSettings extends StatelessWidget {
  const AdminServerLogsSettings({super.key});

  static const String routeName = '/settings/admin-server/logs';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Admin Logs',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: AdminServerSettings.routeName,
      children: const [AdminServerLogsView()],
    );
  }
}
