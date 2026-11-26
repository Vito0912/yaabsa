import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/libraries/admin_server_libraries_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_settings_pane_layout.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerLibrariesSettings extends StatelessWidget {
  const AdminServerLibrariesSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerLibraries;

  @override
  Widget build(BuildContext context) {
    return AdminSettingsPaneLayout(
      title: context.l10n.navLibraries,
      maxWidth: 1040,
      child: const AdminServerLibrariesView(),
    );
  }
}
