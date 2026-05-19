import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/admin_server_users_view.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class AdminServerUsersSettings extends StatelessWidget {
  const AdminServerUsersSettings({super.key});

  static const String routeName = '/settings/admin-server/users';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: S.current.screensSettingsAdminServerUsersSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: AdminServerSettings.routeName,
      children: const [AdminServerUsersView()],
    );
  }
}
