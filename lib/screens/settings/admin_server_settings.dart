import 'package:material_ui/material_ui.dart';
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
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

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
      title: context.l10n.headingAdminServerSettings,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUserAsync.when(
          data: (currentUser) {
            if (currentUser == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(context.l10n.promptSignInToManageSettings),
              );
            }

            final isAdminUser = _isAdminType(currentUser.type);
            final serverUrl = currentUser.server?.url.trim();
            final managedServer = serverUrl == null || serverUrl.isEmpty ? context.l10n.statusUnknownServer : serverUrl;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsNavigationSection(
                  title: context.l10n.adminSettingsForServer(managedServer),
                  topPadding: 0,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.settings_outlined,
                      title: context.l10n.navServerConfiguration,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerConfigurationSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.library_add_outlined,
                      title: context.l10n.navLibraries,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerLibrariesSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.receipt_long_outlined,
                      title: context.l10n.settingsCategoryLogs,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerLogsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.backup_table_outlined,
                      title: context.l10n.navBackups,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerBackupsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.group_outlined,
                      title: context.l10n.labelUsers,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerUsersSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.key_outlined,
                      title: context.l10n.navApiKeys,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerApiKeysSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.query_stats_rounded,
                      title: context.l10n.fieldSessions,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerSessionsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.rss_feed_rounded,
                      title: context.l10n.navRssFeeds,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerRssFeedsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.alternate_email_rounded,
                      title: context.l10n.navEmailEReader,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerEmailSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.verified_user_outlined,
                      title: context.l10n.navAuthentication,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerAuthenticationSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.category_outlined,
                      title: context.l10n.navItemMetadataUtils,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminItemMetadataUtilsSettings.routeName) : null,
                    ),
                    SettingsNavigationItem(
                      icon: Icons.insert_chart_outlined_rounded,
                      title: context.l10n.navLibraryStats,
                      enabled: isAdminUser,
                      disabledReason: isAdminUser ? null : context.l10n.errorAdminRequired,
                      onTap: isAdminUser ? () => context.push(AdminServerLibraryStatsSettings.routeName) : null,
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: YaabsaCircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              context.l10n.errorOperationFailed(context.l10n.operationLoadSettings, error.toString()),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
