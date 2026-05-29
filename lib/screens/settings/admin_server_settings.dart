import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/admin_server_api_keys_settings.dart';
import 'package:yaabsa/screens/settings/admin_item_metadata_utils_settings.dart';
import 'package:yaabsa/screens/layout_home.dart';
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
                      icon: Icons.settings_suggest_outlined,
                      title: 'Server Configuration',
                      subtitle: 'Manage scanner, metadata storage, sorting, and security settings.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerConfigurationSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.library_add_outlined,
                      title: 'Libraries',
                      subtitle: 'Add, edit, scan, reorder, and delete server libraries.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerLibrariesSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.insert_chart_outlined_rounded,
                      title: 'Library Stats',
                      subtitle: 'View top genres, authors, and size/runtime rankings per library.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerLibraryStatsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.receipt_long_outlined,
                      title: 'Logs',
                      subtitle: 'Open the admin logs page.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerLogsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.backup_table_outlined,
                      title: 'Backups',
                      subtitle: 'Create, upload, download, restore, and configure backup retention.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerBackupsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.group_outlined,
                      title: 'Users',
                      subtitle: 'Create, edit, disable, unlink OpenID, and delete users.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerUsersSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.key_outlined,
                      title: 'API Keys',
                      subtitle: 'Create, edit, and delete API keys for integrations and automation.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerApiKeysSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.query_stats_rounded,
                      title: 'Sessions',
                      subtitle: 'Browse and manage listening sessions.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerSessionsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.rss_feed_rounded,
                      title: 'RSS Feeds',
                      subtitle: 'Inspect and close server RSS feeds.',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerRssFeedsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.alternate_email_rounded,
                      title: 'E-Mail / E-Reader',
                      subtitle: 'Configure send-to-device',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerEmailSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.verified_user_outlined,
                      title: 'Authentication',
                      subtitle: 'Configure local and OpenID authentication methods',
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : 'Requires an admin account.',
                      onTap: isAdminUser ? () => context.push(AdminServerAuthenticationSettings.routeName) : null,
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
