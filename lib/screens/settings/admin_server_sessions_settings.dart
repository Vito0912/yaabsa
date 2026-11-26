import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/admin_server_sessions_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_settings_pane_layout.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerSessionsSettings extends StatelessWidget {
  const AdminServerSessionsSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerSessions;

  @override
  Widget build(BuildContext context) {
    return AdminSettingsPaneLayout(
      title: context.l10n.headingListeningSessions,
      maxWidth: 1100,
      child: const AdminServerSessionsView(),
    );
  }
}
