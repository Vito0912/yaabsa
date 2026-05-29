import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/admin_server_api_keys_settings.dart';
import 'package:yaabsa/screens/settings/admin_item_metadata_utils_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_backups_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_authentication_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_configuration_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_email_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_library_stats_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_libraries_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_logs_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_rss_feeds_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_sessions_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_users_settings.dart';
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
                SettingsNavigationSection(
                  title: 'Settings for $managedServer',
                  topPadding: 0,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.settings_outlined,
                      title: 'Server Configuration',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerConfigurationSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.library_add_outlined,
                      title: 'Libraries',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerLibrariesSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Logs',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerLogsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.backup_table_outlined,
                      title: 'Backups',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerBackupsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.group_outlined,
                      title: 'Users',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerUsersSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.key_outlined,
                      title: 'API Keys',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerApiKeysSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.query_stats_rounded,
                      title: 'Sessions',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerSessionsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.rss_feed_rounded,
                      title: 'RSS Feeds',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerRssFeedsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.alternate_email_rounded,
                      title: 'E-Mail / E-Reader',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerEmailSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.verified_user_outlined,
                      title: 'Authentication',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerAuthenticationSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.category_outlined,
                      title: 'Item Metadata Utils',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminItemMetadataUtilsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.insert_chart_outlined_rounded,
                      title: 'Library Stats',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerLibraryStatsSettings.routeName) : null,
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
