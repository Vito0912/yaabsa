import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/screens/settings/tools_settings.dart';

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

    return SettingsNavigationSection(
      title: S.current.componentsSettingsManagementSettingsSectionManagement,
      items: [
        if (isAdminUser)
          SettingsNavigationItem(
            icon: Icons.admin_panel_settings_outlined,
            title: S.current.componentsSettingsManagementSettingsSectionAdminServerSettings,
            enabled: isAdminUser,
            onTap: isAdminUser ? () => context.push(AdminServerSettings.routeName) : null,
          ),
        SettingsNavigationItem(
          icon: Icons.handyman_outlined,
          title: S.current.componentsSettingsManagementSettingsSectionTools,
          onTap: () => context.push(ToolsSettings.routeName),
        ),
      ],
    );
  }
}
