import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/authentication/admin_server_authentication_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_settings_pane_layout.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerAuthenticationSettings extends StatelessWidget {
  const AdminServerAuthenticationSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerAuthentication;

  @override
  Widget build(BuildContext context) {
    return AdminSettingsPaneLayout(
      title: context.l10n.navAuthentication,
      maxWidth: 1040,
      child: const AdminServerAuthenticationView(),
    );
  }
}
