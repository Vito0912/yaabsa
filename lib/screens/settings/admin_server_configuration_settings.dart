import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/admin_server_configuration_view.dart';
import 'package:yaabsa/screens/settings/admin_server_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class AdminServerConfigurationSettings extends StatelessWidget {
  const AdminServerConfigurationSettings({super.key});

  static const String routeName = '/settings/admin-server/configuration';

  @override
  Widget build(BuildContext context) {
    return const SettingsPageScaffold(
      title: 'Admin Server Configuration',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: AdminServerSettings.routeName,
      children: [AdminServerConfigurationView()],
    );
  }
}
