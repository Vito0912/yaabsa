import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/screens/settings/tools_settings.dart';
import 'package:yaabsa/util/l10n.dart';

class ManagementSettingsSection extends StatelessWidget {
  const ManagementSettingsSection({super.key, required this.currentUser});

  final User currentUser;

  bool get _isAdminUser {
    final normalizedType = currentUser.type.trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  @override
  Widget build(BuildContext context) {
    final isAdminUser = _isAdminUser;

    final items = <SettingsNavigationItem>[
      if (isAdminUser)
        SettingsNavigationItem(
          icon: Icons.admin_panel_settings_outlined,
          title: context.l10n.headingAdminServerSettings,
          enabled: isAdminUser,
          onTap: isAdminUser ? () => context.push(AdminServerSettings.routeName) : null,
        ),
      if (currentUser.permissions.update || currentUser.permissions.delete || currentUser.permissions.upload)
        SettingsNavigationItem(
          icon: Icons.handyman_outlined,
          title: context.l10n.settingsCategoryTools,
          onTap: () => context.push(ToolsSettings.routeName),
        ),
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SettingsNavigationSection(title: context.l10n.settingsCategoryManagement, items: items);
  }
}
