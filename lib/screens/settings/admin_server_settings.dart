import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/presentation/declarative_settings_page.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';

class AdminServerSettings extends StatelessWidget {
  const AdminServerSettings({super.key});

  static const String routeName = SettingsRoutes.adminServer;

  @override
  Widget build(BuildContext context) {
    return const DeclarativeSettingsPage(pageId: 'server.admin');
  }
}
