import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/email/admin_server_email_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_settings_pane_layout.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerEmailSettings extends StatelessWidget {
  const AdminServerEmailSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerEmail;

  @override
  Widget build(BuildContext context) {
    return AdminSettingsPaneLayout(
      title: context.l10n.navEmailEReader,
      maxWidth: 1040,
      child: const AdminServerEmailView(),
    );
  }
}
