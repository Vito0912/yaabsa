import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/admin_item_metadata_utils_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_api_keys_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_authentication_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_backups_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_configuration_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_email_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_libraries_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_library_stats_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_logs_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_rss_feeds_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_sessions_settings.dart';
import 'package:yaabsa/screens/settings/admin_server_users_settings.dart';

SettingsAvailability _adminServerAvailability(SettingsContext ctx) {
  if (ctx.isAaos || !ctx.isAdminUser) {
    return const SettingsAvailability.hidden();
  }

  return const SettingsAvailability.available();
}

String _managedServerLabel(SettingsContext ctx) {
  final serverUrl = ctx.currentUser?.server?.url.trim();
  if (serverUrl == null || serverUrl.isEmpty) {
    return ctx.l10n.statusUnknownServer;
  }

  return serverUrl;
}

List<SettingsPageSpec> buildAdminServerSettingsPages() {
  return <SettingsPageSpec>[
    _buildAdminServerHubPage(),
    _buildAdminSubpage(
      id: 'server.admin.configuration',
      route: SettingsRoutes.adminServerConfiguration,
      icon: Icons.settings_outlined,
      title: (ctx) => ctx.l10n.navServerConfiguration,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerConfigurationSettings(),
      metaId: 'admin_configuration_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navServerConfiguration,
        'admin',
        'server',
        'configuration',
        'scanner',
        'watcher',
        'backups',
        'logs',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.libraries',
      route: SettingsRoutes.adminServerLibraries,
      icon: Icons.library_add_outlined,
      title: (ctx) => ctx.l10n.navLibraries,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerLibrariesSettings(),
      metaId: 'admin_libraries_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navLibraries,
        'admin',
        'libraries',
        'folders',
        'scan',
        'provider',
        'books',
        'podcasts',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.logs',
      route: SettingsRoutes.adminServerLogs,
      icon: Icons.receipt_long_outlined,
      title: (ctx) => ctx.l10n.settingsCategoryLogs,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerLogsSettings(),
      metaId: 'admin_logs_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.settingsCategoryLogs,
        'admin',
        'server logs',
        'logs',
        'diagnostics',
        'errors',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.backups',
      route: SettingsRoutes.adminServerBackups,
      icon: Icons.backup_table_outlined,
      title: (ctx) => ctx.l10n.navBackups,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerBackupsSettings(),
      metaId: 'admin_backups_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navBackups,
        'admin',
        'backups',
        'backup',
        'restore',
        'schedule',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.users',
      route: SettingsRoutes.adminServerUsers,
      icon: Icons.group_outlined,
      title: (ctx) => ctx.l10n.labelUsers,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerUsersSettings(),
      metaId: 'admin_users_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.labelUsers,
        l10n.headingManageUsers,
        l10n.actionManageUsers,
        'admin',
        'users',
        'accounts',
        'permissions',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.api_keys',
      route: SettingsRoutes.adminServerApiKeys,
      icon: Icons.key_outlined,
      title: (ctx) => ctx.l10n.navApiKeys,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerApiKeysSettings(),
      metaId: 'admin_api_keys_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navApiKeys,
        'admin',
        'api key',
        'api keys',
        'token',
        'tokens',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.sessions',
      route: SettingsRoutes.adminServerSessions,
      icon: Icons.query_stats_rounded,
      title: (ctx) => ctx.l10n.fieldSessions,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerSessionsSettings(),
      metaId: 'admin_sessions_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.fieldSessions,
        l10n.headingListeningSessions,
        'admin',
        'sessions',
        'listening sessions',
        'playback',
        'share',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.rss_feeds',
      route: SettingsRoutes.adminServerRssFeeds,
      icon: Icons.rss_feed_rounded,
      title: (ctx) => ctx.l10n.navRssFeeds,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerRssFeedsSettings(),
      metaId: 'admin_rss_feeds_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navRssFeeds,
        'admin',
        'rss',
        'rss feeds',
        'podcast',
        'feed',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.email',
      route: SettingsRoutes.adminServerEmail,
      icon: Icons.alternate_email_rounded,
      title: (ctx) => ctx.l10n.navEmailEReader,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerEmailSettings(),
      metaId: 'admin_email_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navEmailEReader,
        'admin',
        'smtp',
        'email',
        'e-mail',
        'ereader',
        'e-reader',
        'kindle',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.authentication',
      route: SettingsRoutes.adminServerAuthentication,
      icon: Icons.verified_user_outlined,
      title: (ctx) => ctx.l10n.navAuthentication,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerAuthenticationSettings(),
      metaId: 'admin_authentication_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navAuthentication,
        'admin',
        'oidc',
        'openid',
        'auth',
        'authentication',
        'sso',
        'login',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.item_metadata_utils',
      route: SettingsRoutes.adminItemMetadataUtils,
      icon: Icons.category_outlined,
      title: (ctx) => ctx.l10n.navItemMetadataUtils,
      customPageBuilder: (context, {focusEntryId}) => const AdminItemMetadataUtilsSettings(),
      metaId: 'admin_item_metadata_utils_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navItemMetadataUtils,
        'admin',
        'metadata',
        'genres',
        'tags',
        'utilities',
      ],
    ),
    _buildAdminSubpage(
      id: 'server.admin.library_stats',
      route: SettingsRoutes.adminServerLibraryStats,
      icon: Icons.insert_chart_outlined_rounded,
      title: (ctx) => ctx.l10n.navLibraryStats,
      customPageBuilder: (context, {focusEntryId}) => const AdminServerLibraryStatsSettings(),
      metaId: 'admin_library_stats_meta',
      keywords: (l10n) => <String>[
        l10n.headingAdminServerSettings,
        l10n.navLibraryStats,
        'admin',
        'stats',
        'statistics',
        'library stats',
        'authors',
        'genres',
      ],
    ),
  ];
}

SettingsPageSpec _buildAdminServerHubPage() {
  return SettingsPageSpec(
    id: 'server.admin',
    route: SettingsRoutes.adminServer,
    scope: SettingScope.server,
    icon: Icons.admin_panel_settings_outlined,
    title: (ctx) => ctx.l10n.headingAdminServerSettings,
    subtitle: (ctx) => ctx.l10n.settingsAdminServerDescription(_managedServerLabel(ctx)),
    requiresSignIn: true,
    registerRoute: true,
    availability: _adminServerAvailability,
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'admin_server_meta',
        title: (ctx) => ctx.l10n.headingAdminServerSettings,
        description: (ctx) => ctx.l10n.settingsAdminServerDescription(_managedServerLabel(ctx)),
        keywords: (l10n) => <String>[
          l10n.fieldServer,
          l10n.headingAdminServerSettings,
          'admin',
          'server',
          'users',
          'libraries',
          'sessions',
          'api keys',
        ],
      ),
    ],
    sections: [
      SettingsSectionSpec(
        id: 'server.admin.sections',
        title: (ctx) => ctx.l10n.adminSettingsForServer(_managedServerLabel(ctx)),
        entries: [
          SettingsNavEntry(
            id: 'admin_configuration_nav',
            title: (ctx) => ctx.l10n.navServerConfiguration,
            icon: Icons.settings_outlined,
            targetRoute: SettingsRoutes.adminServerConfiguration,
            targetPageId: 'server.admin.configuration',
          ),
          SettingsNavEntry(
            id: 'admin_libraries_nav',
            title: (ctx) => ctx.l10n.navLibraries,
            icon: Icons.library_add_outlined,
            targetRoute: SettingsRoutes.adminServerLibraries,
            targetPageId: 'server.admin.libraries',
          ),
          SettingsNavEntry(
            id: 'admin_logs_nav',
            title: (ctx) => ctx.l10n.settingsCategoryLogs,
            icon: Icons.receipt_long_outlined,
            targetRoute: SettingsRoutes.adminServerLogs,
            targetPageId: 'server.admin.logs',
          ),
          SettingsNavEntry(
            id: 'admin_backups_nav',
            title: (ctx) => ctx.l10n.navBackups,
            icon: Icons.backup_table_outlined,
            targetRoute: SettingsRoutes.adminServerBackups,
            targetPageId: 'server.admin.backups',
          ),
          SettingsNavEntry(
            id: 'admin_users_nav',
            title: (ctx) => ctx.l10n.labelUsers,
            icon: Icons.group_outlined,
            targetRoute: SettingsRoutes.adminServerUsers,
            targetPageId: 'server.admin.users',
          ),
          SettingsNavEntry(
            id: 'admin_api_keys_nav',
            title: (ctx) => ctx.l10n.navApiKeys,
            icon: Icons.key_outlined,
            targetRoute: SettingsRoutes.adminServerApiKeys,
            targetPageId: 'server.admin.api_keys',
          ),
          SettingsNavEntry(
            id: 'admin_sessions_nav',
            title: (ctx) => ctx.l10n.fieldSessions,
            icon: Icons.query_stats_rounded,
            targetRoute: SettingsRoutes.adminServerSessions,
            targetPageId: 'server.admin.sessions',
          ),
          SettingsNavEntry(
            id: 'admin_rss_feeds_nav',
            title: (ctx) => ctx.l10n.navRssFeeds,
            icon: Icons.rss_feed_rounded,
            targetRoute: SettingsRoutes.adminServerRssFeeds,
            targetPageId: 'server.admin.rss_feeds',
          ),
          SettingsNavEntry(
            id: 'admin_email_nav',
            title: (ctx) => ctx.l10n.navEmailEReader,
            icon: Icons.alternate_email_rounded,
            targetRoute: SettingsRoutes.adminServerEmail,
            targetPageId: 'server.admin.email',
          ),
          SettingsNavEntry(
            id: 'admin_authentication_nav',
            title: (ctx) => ctx.l10n.navAuthentication,
            icon: Icons.verified_user_outlined,
            targetRoute: SettingsRoutes.adminServerAuthentication,
            targetPageId: 'server.admin.authentication',
          ),
          SettingsNavEntry(
            id: 'admin_item_metadata_utils_nav',
            title: (ctx) => ctx.l10n.navItemMetadataUtils,
            icon: Icons.category_outlined,
            targetRoute: SettingsRoutes.adminItemMetadataUtils,
            targetPageId: 'server.admin.item_metadata_utils',
          ),
          SettingsNavEntry(
            id: 'admin_library_stats_nav',
            title: (ctx) => ctx.l10n.navLibraryStats,
            icon: Icons.insert_chart_outlined_rounded,
            targetRoute: SettingsRoutes.adminServerLibraryStats,
            targetPageId: 'server.admin.library_stats',
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildAdminSubpage({
  required String id,
  required String route,
  required IconData icon,
  required SettingsTextBuilder title,
  required Widget Function(BuildContext context, {String? focusEntryId}) customPageBuilder,
  required String metaId,
  required SettingsKeywordsBuilder keywords,
}) {
  return SettingsPageSpec(
    id: id,
    parentId: 'server.admin',
    route: route,
    scope: SettingScope.server,
    icon: icon,
    title: title,
    requiresSignIn: true,
    registerRoute: true,
    availability: _adminServerAvailability,
    customPageBuilder: customPageBuilder,
    searchableMetadata: [
      SettingsSearchMetadata(
        id: metaId,
        title: title,
        description: (ctx) => ctx.l10n.headingAdminServerSettings,
        keywords: keywords,
      ),
    ],
  );
}
