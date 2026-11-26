import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/admin_item_metadata_utils_view.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_settings_pane_layout.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminItemMetadataUtilsSettings extends StatelessWidget {
  const AdminItemMetadataUtilsSettings({super.key});

  static const String routeName = SettingsRoutes.adminItemMetadataUtils;

  @override
  Widget build(BuildContext context) {
    return AdminSettingsPaneLayout(
      title: context.l10n.navItemMetadataUtils,
      maxWidth: 700,
      child: const AdminItemMetadataUtilsView(),
    );
  }
}
