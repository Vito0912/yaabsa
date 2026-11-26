import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/admin_server_api_keys_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_settings_pane_layout.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminServerApiKeysSettings extends StatelessWidget {
  const AdminServerApiKeysSettings({super.key});

  static const String routeName = SettingsRoutes.adminServerApiKeys;

  @override
  Widget build(BuildContext context) {
    return AdminSettingsPaneLayout(
      title: context.l10n.navApiKeys,
      maxWidth: 1040,
      child: const AdminServerApiKeysView(),
    );
  }
}
