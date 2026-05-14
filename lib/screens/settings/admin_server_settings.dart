import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/admin_item_metadata_utils_settings.dart';
import 'package:yaabsa/screens/layout_home.dart';
import 'package:yaabsa/screens/settings/admin_server_logs_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class AdminServerSettings extends ConsumerWidget {
  const AdminServerSettings({super.key});

  static const String routeName = '/settings/admin-server';

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'Admin Server Settings',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUserAsync.when(
          data: (currentUser) {
            if (currentUser == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('No active user. Sign in to open admin server settings.'),
              );
            }

            final isAdminUser = _isAdminType(currentUser.type);
            final serverUrl = currentUser.server?.url.trim();
            final managedServer = serverUrl == null || serverUrl.isEmpty ? 'unknown server' : serverUrl;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
                  child: Text(
                    'You currently are managing the server $managedServer',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SettingsNavigationSection(
                  title: 'Admin Subsettings',
                  topPadding: 0,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Logs',
                      subtitle: 'Open the admin logs page.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerLogsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.upload_file_outlined,
                      title: 'Upload',
                      subtitle: 'Open upload.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.go(LayoutHome.uploadModeLocation(tab: 'settings')) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.category_outlined,
                      title: 'Item Metadata Utils',
                      subtitle: 'Manage tags, genres and custom metadata providers.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminItemMetadataUtilsSettings.routeName) : null,
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Failed to load user settings: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
