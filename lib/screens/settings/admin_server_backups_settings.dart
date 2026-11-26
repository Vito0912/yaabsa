import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/admin_server_backups_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_settings_pane_layout.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerBackupsSettings extends StatelessWidget {
  const AdminServerBackupsSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerBackups;

  @override
  Widget build(BuildContext context) {
    return AdminSettingsPaneLayout(
      title: context.l10n.navBackups,
      maxWidth: 700,
      child: const AdminServerBackupsView(),
    );
  }
}
