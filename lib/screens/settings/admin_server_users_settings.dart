import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/admin_server_users_view.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerUsersSettings extends StatelessWidget {
  const AdminServerUsersSettings({super.key});

  static const String routeName = '/settings/admin-server/users';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.headingManageUsers,
      maxWidth: 1100,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: AdminServerSettings.routeName,
      children: const [AdminServerUsersView()],
    );
  }
}
