import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/admin_server_configuration_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerConfigurationSettings extends StatelessWidget {
  const AdminServerConfigurationSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerConfiguration;

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.navServerConfiguration,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: SettingsRoutes.adminServer,
      children: [AdminServerConfigurationView()],
    );
  }
}
