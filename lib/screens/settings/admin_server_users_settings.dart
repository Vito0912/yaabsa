import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/admin_server_users_view.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class AdminServerUsersSettings extends StatelessWidget {
  const AdminServerUsersSettings({super.key});

  static const String routeName = '/settings/admin-server/users';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Manage Users',
      maxWidth: 1100,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: AdminServerSettings.routeName,
      children: const [AdminServerUsersView()],
    );
  }
}
