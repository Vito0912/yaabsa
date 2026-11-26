import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/admin_server_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/path_tag_genre_update_settings.dart';
import 'package:yaabsa/screens/settings/server_connection_settings.dart';
import 'package:yaabsa/screens/settings/tools/force_metadata_refresh_tool_settings.dart';
import 'package:yaabsa/screens/settings/tools/match_audiobook_chapters_tool_settings.dart';

List<SettingsPageSpec> buildServerSettingsPages() {
  return <SettingsPageSpec>[
    _buildServerConnectionPage(),
    _buildServerActionsPage(),
    _buildToolsPage(),
    _buildPathTagGenreUpdatePage(),
    _buildForceMetadataRefreshPage(),
    _buildMatchAudiobookChaptersPage(),
    ...buildAdminServerSettingsPages(),
  ];
}

SettingsPageSpec _buildServerConnectionPage() {
  return SettingsPageSpec(
    id: 'server.connection',
    route: SettingsRoutes.serverConnection,
    scope: SettingScope.server,
    icon: Icons.dns_outlined,
    title: (ctx) => ctx.l10n.settingsServerConnection,
    subtitle: (ctx) => ctx.l10n.settingsServerConnectionDescription,
    requiresSignIn: true,
    customPageBuilder: (context, {focusEntryId}) => const ServerConnectionSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'server_connection_meta',
        title: (ctx) => ctx.l10n.settingsServerConnection,
        description: (ctx) => ctx.l10n.settingsServerConnectionDescription,
        keywords: (l10n) => <String>[
          l10n.fieldServer,
          l10n.fieldServerAddress,
          'server',
          'url',
          'host',
          'local',
          'headers',
          'connection',
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildServerActionsPage() {
  return SettingsPageSpec(
    id: 'server.actions',
    route: SettingsRoutes.serverManagement,
    scope: SettingScope.account,
    icon: Icons.admin_panel_settings_outlined,
    title: (ctx) => ctx.l10n.settingsServerActions,
    subtitle: (ctx) => ctx.l10n.settingsServerActionsDescription,
    requiresSignIn: true,
    availability: (ctx) {
      if (ctx.isAaos || !ctx.hasAnyServerManagementPermission) {
        return const SettingsAvailability.hidden();
      }

      return const SettingsAvailability.available();
    },
    sections: [
      SettingsSectionSpec(
        id: 'server.actions.visibility',
        title: (ctx) => ctx.l10n.headingPermissionVisibility,
        entries: [
          SettingsToggleEntry(
            id: 'server_management_collections',
            title: (ctx) => ctx.l10n.permissionCollections,
            description: (ctx) => ctx.l10n.permissionCollectionsDescription,
            keywords: (l10n) => <String>[l10n.settingsServerActions, 'collections', 'permissions'],
            definition: AppSettingDefs.serverManagementCollections,
            availability: (ctx) {
              if (ctx.currentUser?.permissions.update ?? false) {
                return const SettingsAvailability.available();
              }

              return SettingsAvailability.disabled(ctx.l10n.permissionRequiresEditItems);
            },
          ),
          SettingsToggleEntry(
            id: 'server_management_edit_items',
            title: (ctx) => ctx.l10n.permissionEditItems,
            description: (ctx) => ctx.l10n.permissionEditItemsDescription,
            keywords: (l10n) => <String>[l10n.settingsServerActions, 'edit', 'metadata', 'permissions'],
            definition: AppSettingDefs.serverManagementEditItems,
            availability: (ctx) {
              if (ctx.currentUser?.permissions.update ?? false) {
                return const SettingsAvailability.available();
              }

              return SettingsAvailability.disabled(ctx.l10n.permissionRequiresEditItems);
            },
          ),
          SettingsToggleEntry(
            id: 'server_management_delete_items',
            title: (ctx) => ctx.l10n.permissionDeleteItems,
            description: (ctx) => ctx.l10n.permissionDeleteItemsDescription,
            keywords: (l10n) => <String>[l10n.settingsServerActions, 'delete', 'permissions'],
            definition: AppSettingDefs.serverManagementDeleteItems,
            availability: (ctx) {
              if (ctx.currentUser?.permissions.delete ?? false) {
                return const SettingsAvailability.available();
              }

              return SettingsAvailability.disabled(ctx.l10n.permissionRequiresDeleteItems);
            },
          ),
          SettingsToggleEntry(
            id: 'server_management_edit_chapters',
            title: (ctx) => ctx.l10n.permissionEditChapters,
            description: (ctx) => ctx.l10n.permissionEditChaptersDescription,
            keywords: (l10n) => <String>[l10n.settingsServerActions, 'chapters', 'edit'],
            definition: AppSettingDefs.serverManagementEditChapters,
            availability: (ctx) {
              if (ctx.currentUser?.permissions.update ?? false) {
                return const SettingsAvailability.available();
              }

              return SettingsAvailability.disabled(ctx.l10n.permissionRequiresEditItems);
            },
          ),
          SettingsToggleEntry(
            id: 'server_management_upload_items',
            title: (ctx) => ctx.l10n.permissionUpload,
            description: (ctx) => ctx.l10n.permissionUploadDescription,
            keywords: (l10n) => <String>[l10n.settingsServerActions, 'upload', 'permissions'],
            definition: AppSettingDefs.serverManagementUploadItems,
            availability: (ctx) {
              if (ctx.currentUser?.permissions.upload ?? false) {
                return const SettingsAvailability.available();
              }

              return SettingsAvailability.disabled(ctx.l10n.permissionRequiresUpload);
            },
          ),
          SettingsToggleEntry(
            id: 'server_management_matches',
            title: (ctx) => ctx.l10n.permissionMatches,
            description: (ctx) => ctx.l10n.permissionMatchesDescription,
            keywords: (l10n) => <String>[l10n.settingsServerActions, 'match', 'quick match', 'metadata'],
            definition: AppSettingDefs.serverManagementAllowMatchesQuickMatches,
            availability: (ctx) {
              final canUpdate = ctx.currentUser?.permissions.update ?? false;
              if (!canUpdate) {
                return SettingsAvailability.disabled(ctx.l10n.permissionRequiresEditItems);
              }

              final editItemsEnabled = ctx.readSetting(AppSettingDefs.serverManagementEditItems);
              if (!editItemsEnabled) {
                return SettingsAvailability.disabled(ctx.l10n.promptEnableSettingFirst(ctx.l10n.permissionEditItems));
              }

              return const SettingsAvailability.available();
            },
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildToolsPage() {
  return SettingsPageSpec(
    id: 'server.tools',
    route: SettingsRoutes.tools,
    scope: SettingScope.account,
    icon: Icons.handyman_outlined,
    title: (ctx) => ctx.l10n.settingsCategoryTools,
    subtitle: (ctx) => ctx.l10n.settingsToolsDescription,
    requiresSignIn: true,
    availability: (ctx) {
      if (ctx.isAaos || !ctx.hasAnyServerManagementPermission) {
        return const SettingsAvailability.hidden();
      }

      return const SettingsAvailability.available();
    },
    sections: [
      SettingsSectionSpec(
        id: 'server.tools.subpages',
        title: (ctx) => ctx.l10n.headingToolSubpages,
        entries: [
          SettingsCustomEntry(
            id: 'tools_info_banner',
            title: (ctx) => ctx.l10n.settingsCategoryTools,
            searchable: false,
            builder: (context, ref, settingsContext) => SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Text(
                  settingsContext.l10n.messageAdditionalToolsInfo,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ),
          SettingsNavEntry(
            id: 'tools_path_tag_genre_nav',
            title: (ctx) => ctx.l10n.headingPathTagGenreUpdate,
            icon: Icons.route_outlined,
            targetRoute: SettingsRoutes.toolsPathTagGenreUpdate,
            targetPageId: 'server.tools.path_tag_genre',
          ),
          SettingsNavEntry(
            id: 'tools_force_metadata_refresh_nav',
            title: (ctx) => ctx.l10n.settingForceMetadataRefresh,
            icon: Icons.refresh_outlined,
            targetRoute: SettingsRoutes.toolsForceMetadataRefresh,
            targetPageId: 'server.tools.force_metadata_refresh',
          ),
          SettingsNavEntry(
            id: 'tools_match_audiobook_chapters_nav',
            title: (ctx) => ctx.l10n.headingMatchAudiobookChapters,
            icon: Icons.auto_fix_high_outlined,
            targetRoute: SettingsRoutes.toolsMatchAudiobookChapters,
            targetPageId: 'server.tools.match_audiobook_chapters',
            availability: (ctx) {
              if (!ctx.readSetting(AppSettingDefs.toolsMatchAudiobookChapters)) {
                return const SettingsAvailability.hidden();
              }

              return const SettingsAvailability.available();
            },
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'server.tools.experimental',
        title: (ctx) => ctx.l10n.headingExperimentalTools,
        entries: [
          SettingsToggleEntry(
            id: 'tools_remove_authors_without_books',
            title: (ctx) => ctx.l10n.actionRemoveAuthorsWithoutBooks,
            description: (ctx) => ctx.l10n.settingRemoveAuthorsWithoutBooksDescription,
            keywords: (l10n) => <String>[l10n.settingsCategoryTools, 'authors', 'cleanup'],
            definition: AppSettingDefs.toolsRemoveAuthorsWithoutBooks,
          ),
          SettingsToggleEntry(
            id: 'tools_match_audiobook_chapters',
            title: (ctx) => ctx.l10n.settingMatchAudiobookChapters,
            keywords: (l10n) => <String>[l10n.settingsCategoryTools, 'chapters', 'match'],
            definition: AppSettingDefs.toolsMatchAudiobookChapters,
          ),
          SettingsToggleEntry(
            id: 'tools_split_genres_tags',
            title: (ctx) => ctx.l10n.settingSplitGenresAndTags,
            description: (ctx) => ctx.l10n.settingSplitGenresAndTagsDescription,
            keywords: (l10n) => <String>[l10n.settingsCategoryTools, 'genres', 'tags', 'split'],
            definition: AppSettingDefs.toolsSplitGenresTags,
          ),
          SettingsToggleEntry(
            id: 'tools_rename_series',
            title: (ctx) => ctx.l10n.settingRenameSeries,
            description: (ctx) => ctx.l10n.settingRenameSeriesDescription,
            keywords: (l10n) => <String>[l10n.settingsCategoryTools, 'series', 'rename'],
            definition: AppSettingDefs.toolsRenameSeries,
          ),
          SettingsToggleEntry(
            id: 'tools_delete_long_listening_sessions',
            title: (ctx) => ctx.l10n.settingDeleteLongListeningSessions,
            description: (ctx) => ctx.l10n.settingDeleteLongListeningSessionsDescription,
            keywords: (l10n) => <String>[l10n.settingsCategoryTools, 'sessions', 'listening', 'stats'],
            definition: AppSettingDefs.toolsDeleteLongListeningSessions,
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildPathTagGenreUpdatePage() {
  return SettingsPageSpec(
    id: 'server.tools.path_tag_genre',
    parentId: 'server.tools',
    route: SettingsRoutes.toolsPathTagGenreUpdate,
    scope: SettingScope.account,
    icon: Icons.route_outlined,
    title: (ctx) => ctx.l10n.headingPathTagGenreUpdate,
    requiresSignIn: true,
    availability: (ctx) {
      if (ctx.isAaos || !ctx.hasAnyServerManagementPermission) {
        return const SettingsAvailability.hidden();
      }

      return const SettingsAvailability.available();
    },
    customPageBuilder: (context, {focusEntryId}) => const PathTagGenreUpdateSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'tools_path_tag_genre_meta',
        title: (ctx) => ctx.l10n.headingPathTagGenreUpdate,
        description: (ctx) => ctx.l10n.settingsToolsDescription,
        keywords: (l10n) => <String>[l10n.settingsCategoryTools, 'path', 'tag', 'genre', 'metadata'],
      ),
    ],
  );
}

SettingsPageSpec _buildForceMetadataRefreshPage() {
  return SettingsPageSpec(
    id: 'server.tools.force_metadata_refresh',
    parentId: 'server.tools',
    route: SettingsRoutes.toolsForceMetadataRefresh,
    scope: SettingScope.account,
    icon: Icons.refresh_outlined,
    title: (ctx) => ctx.l10n.settingForceMetadataRefresh,
    requiresSignIn: true,
    availability: (ctx) {
      if (ctx.isAaos || !ctx.hasAnyServerManagementPermission) {
        return const SettingsAvailability.hidden();
      }

      return const SettingsAvailability.available();
    },
    customPageBuilder: (context, {focusEntryId}) => const ForceMetadataRefreshToolSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'tools_force_metadata_refresh_meta',
        title: (ctx) => ctx.l10n.settingForceMetadataRefresh,
        keywords: (l10n) => <String>[l10n.settingsCategoryTools, 'metadata', 'refresh'],
      ),
    ],
  );
}

SettingsPageSpec _buildMatchAudiobookChaptersPage() {
  return SettingsPageSpec(
    id: 'server.tools.match_audiobook_chapters',
    parentId: 'server.tools',
    route: SettingsRoutes.toolsMatchAudiobookChapters,
    scope: SettingScope.account,
    icon: Icons.auto_fix_high_outlined,
    title: (ctx) => ctx.l10n.headingMatchAudiobookChapters,
    requiresSignIn: true,
    availability: (ctx) {
      if (ctx.isAaos ||
          !ctx.hasAnyServerManagementPermission ||
          !ctx.readSetting(AppSettingDefs.toolsMatchAudiobookChapters)) {
        return const SettingsAvailability.hidden();
      }

      return const SettingsAvailability.available();
    },
    customPageBuilder: (context, {focusEntryId}) => const MatchAudiobookChaptersToolSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'tools_match_audiobook_chapters_meta',
        title: (ctx) => ctx.l10n.headingMatchAudiobookChapters,
        keywords: (l10n) => <String>[l10n.settingsCategoryTools, 'chapters', 'match', 'audible', 'asin'],
      ),
    ],
  );
}
