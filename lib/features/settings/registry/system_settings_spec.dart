import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/components/changelog/changelog_dialog.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/license_settings.dart';
import 'package:yaabsa/screens/settings/log_view.dart';
import 'package:yaabsa/screens/settings/settings_backup_settings.dart';
import 'package:yaabsa/screens/settings/theme_settings.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/l10n.dart';

final Uri _githubRepoUri = Uri.parse('https://github.com/Vito0912/yaabsa/');
final Uri _githubIssueUri = Uri.parse('https://github.com/Vito0912/yaabsa/issues');
final Uri _githubSponsorUri = Uri.parse('https://github.com/sponsors/Vito0912');

Future<void> _openSupportLink(BuildContext context, Uri uri, String label) async {
  try {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (opened || !context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.settingsOpenLinkFailed(label))));
  } catch (_) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.settingsOpenLinkFailed(label))));
  }
}

String _languageEndonym(AppLocalizations l10n, Locale locale) {
  return switch (locale.languageCode) {
    'en' => l10n.localeEnglishName,
    _ => locale.toLanguageTag(),
  };
}

List<SettingsPageSpec> buildSystemSettingsPages() {
  return <SettingsPageSpec>[
    _buildAppearancePage(),
    _buildThemePage(),
    _buildCachingPage(),
    _buildCachingRoutesPage(),
    _buildBackupPage(),
    _buildUpdatesPage(),
    _buildLogsPage(),
    _buildAboutPage(),
    _buildSponsorPage(),
  ];
}

SettingsPageSpec _buildAppearancePage() {
  return SettingsPageSpec(
    id: 'system.appearance',
    route: SettingsRoutes.appearance,
    scope: SettingScope.app,
    icon: Icons.palette_outlined,
    title: (ctx) => ctx.l10n.settingsCategoryAppearance,
    subtitle: (ctx) => ctx.l10n.settingsAppearanceDescription,
    sections: [
      SettingsSectionSpec(
        id: 'system.appearance.display',
        title: (ctx) => ctx.l10n.settingsDisplayTitle,
        entries: [
          SettingsNavEntry(
            id: 'theme_nav',
            title: (ctx) => ctx.l10n.themeSettingsTitle,
            description: (ctx) => ctx.l10n.themeSettingsSubtitle,
            icon: Icons.palette_outlined,
            targetRoute: SettingsRoutes.theme,
            targetPageId: 'system.appearance.theme',
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'system.appearance.other',
        title: (ctx) => ctx.l10n.settingsOtherTitle,
        entries: [
          SettingsChoiceEntry<String>(
            id: 'app_language',
            title: (ctx) => ctx.l10n.fieldLanguage,
            description: (ctx) => ctx.l10n.settingLanguageDescription,
            keywords: (l10n) => <String>[l10n.fieldLanguage, 'language', 'locale', 'translation'],
            definition: AppSettingDefs.language,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(value: 'system', label: ctx.l10n.optionSystemDefault),
              for (final locale in AppLocalizations.supportedLocales)
                SettingsChoiceOption(value: locale.toLanguageTag(), label: _languageEndonym(ctx.l10n, locale)),
            ],
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildThemePage() {
  return SettingsPageSpec(
    id: 'system.appearance.theme',
    parentId: 'system.appearance',
    route: SettingsRoutes.theme,
    scope: SettingScope.app,
    icon: Icons.palette_outlined,
    title: (ctx) => ctx.l10n.themeSettingsTitle,
    subtitle: (ctx) => ctx.l10n.themeSettingsSubtitle,
    customPageBuilder: (context, {focusEntryId}) => const ThemeSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'theme_meta',
        title: (ctx) => ctx.l10n.themeSettingsTitle,
        description: (ctx) => ctx.l10n.themeSettingsSubtitle,
        keywords: (l10n) => <String>[
          l10n.headingThemeMode,
          l10n.headingThemePresets,
          l10n.themeModeName('light'),
          l10n.themeModeName('dark'),
          l10n.themeModeName('amoled'),
          'theme',
          'dark mode',
          'light mode',
          'amoled',
          'accent color',
          'color',
          'palette',
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildCachingPage() {
  return SettingsPageSpec(
    id: 'system.caching',
    route: SettingsRoutes.caching,
    scope: SettingScope.app,
    icon: Icons.cached_outlined,
    title: (ctx) => ctx.l10n.settingsCategoryCaching,
    subtitle: (ctx) => ctx.l10n.settingsCachingDescription,
    sections: [
      SettingsSectionSpec(
        id: 'system.caching.general',
        title: (ctx) => ctx.l10n.settingsCategoryGeneral,
        entries: [
          SettingsToggleEntry(
            id: 'caching_enabled',
            title: (ctx) => ctx.l10n.settingEnableCaching,
            description: (ctx) => ctx.l10n.settingEnableCachingDescription,
            keywords: (l10n) => <String>['cache', 'caching', 'offline', 'performance'],
            definition: AppSettingDefs.caching,
          ),
          SettingsToggleEntry(
            id: 'boost_loading',
            title: (ctx) => ctx.l10n.settingSpeedupMode,
            description: (ctx) => ctx.l10n.settingSpeedupModeDescription,
            keywords: (l10n) => <String>['cache', 'speedup', 'performance', 'loading'],
            definition: AppSettingDefs.boostLoading,
            availability: (ctx) {
              if (ctx.readSetting(AppSettingDefs.caching)) {
                return const SettingsAvailability.available();
              }

              return SettingsAvailability.disabled(ctx.l10n.permissionCachingRequired);
            },
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'system.caching.routes',
        title: (ctx) => ctx.l10n.navCacheRouteRules,
        entries: [
          SettingsNavEntry(
            id: 'caching_routes_nav',
            title: (ctx) => ctx.l10n.navCacheRouteRules,
            description: (ctx) => ctx.l10n.messageCacheRouteRules,
            icon: Icons.route_rounded,
            targetRoute: SettingsRoutes.cachingRoutes,
            targetPageId: 'system.caching.routes',
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildCachingRoutesPage() {
  SettingsAvailability requireCaching(SettingsContext ctx) {
    if (ctx.readSetting(AppSettingDefs.caching)) {
      return const SettingsAvailability.available();
    }

    return SettingsAvailability.disabled(ctx.l10n.permissionCachingRequired);
  }

  return SettingsPageSpec(
    id: 'system.caching.routes',
    parentId: 'system.caching',
    route: SettingsRoutes.cachingRoutes,
    scope: SettingScope.app,
    icon: Icons.route_rounded,
    title: (ctx) => ctx.l10n.navCacheRouteRules,
    subtitle: (ctx) => ctx.l10n.messageCacheRouteRules,
    sections: [
      SettingsSectionSpec(
        id: 'system.caching.routes.list',
        title: (ctx) => ctx.l10n.navCacheRouteRules,
        entries: [
          for (final route in cacheRouteDefinitions)
            SettingsToggleEntry(
              id: 'cache_route_${route.settingKey}',
              title: (ctx) => route.label,
              description: (ctx) => route.aggressiveCache
                  ? '${route.pathPattern}\n${ctx.l10n.warningCacheMayAffectMultipleDevices}'
                  : route.pathPattern,
              keywords: (l10n) => <String>['cache', 'route', route.pathPattern],
              definition: SettingDefinition<bool>(
                key: route.settingKey,
                scope: SettingScope.app,
                defaultValue: !route.aggressiveCache,
              ),
              availability: requireCaching,
            ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildBackupPage() {
  return SettingsPageSpec(
    id: 'system.backup',
    route: SettingsRoutes.backup,
    scope: SettingScope.app,
    icon: Icons.settings_backup_restore_rounded,
    title: (ctx) => ctx.l10n.settingsBackupTitle,
    subtitle: (ctx) => ctx.l10n.settingsBackupDescription,
    customPageBuilder: (context, {focusEntryId}) => const SettingsBackupSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'settings_backup_meta',
        title: (ctx) => ctx.l10n.settingsBackupTitle,
        description: (ctx) => ctx.l10n.settingsBackupDescription,
        keywords: (l10n) => <String>[
          l10n.actionExport,
          l10n.actionImport,
          'backup',
          'restore',
          'export',
          'import',
          'json',
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildUpdatesPage() {
  return SettingsPageSpec(
    id: 'system.updates',
    route: SettingsRoutes.updates,
    scope: SettingScope.app,
    icon: Icons.system_update_outlined,
    title: (ctx) => ctx.l10n.settingsUpdatesTitle,
    subtitle: (ctx) => ctx.l10n.settingsUpdatesDescription,
    sections: [
      SettingsSectionSpec(
        id: 'system.updates.checks',
        title: (ctx) => ctx.l10n.settingsUpdatesTitle,
        entries: [
          SettingsToggleEntry(
            id: 'check_for_app_updates',
            title: (ctx) => ctx.l10n.settingCheckForAppUpdates,
            description: (ctx) => ctx.l10n.settingCheckForAppUpdatesDescription,
            keywords: (l10n) => <String>['update', 'updates', 'version', 'release', 'app'],
            definition: AppSettingDefs.checkForAppUpdates,
            availability: (ctx) {
              if (ctx.isAppUpdateCheckEligible) {
                return const SettingsAvailability.available();
              }

              return const SettingsAvailability.hidden();
            },
          ),
          SettingsToggleEntry(
            id: 'check_for_server_updates',
            title: (ctx) => ctx.l10n.settingCheckServerUpdates,
            description: (ctx) => ctx.l10n.settingCheckServerUpdatesDescription,
            keywords: (l10n) => <String>[l10n.fieldServer, 'update', 'updates', 'version'],
            definition: AppSettingDefs.checkForServerUpdates,
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildLogsPage() {
  return SettingsPageSpec(
    id: 'system.logs',
    route: SettingsRoutes.logs,
    scope: SettingScope.app,
    icon: Icons.article_outlined,
    title: (ctx) => ctx.l10n.settingsCategoryLogs,
    subtitle: (ctx) => ctx.l10n.settingsLogsDescription,
    customPageBuilder: (context, {focusEntryId}) => const LogView(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'log_level_meta',
        title: (ctx) => ctx.l10n.settingLogLevel,
        description: (ctx) => ctx.l10n.settingLogLevelDescription,
        keywords: (l10n) => <String>[
          l10n.settingsCategoryLogs,
          l10n.actionExportLogs,
          'logs',
          'logging',
          'debug',
          'diagnostics',
          'export',
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildAboutPage() {
  return SettingsPageSpec(
    id: 'about',
    route: SettingsRoutes.about,
    scope: SettingScope.app,
    icon: Icons.info_outline_rounded,
    title: (ctx) => ctx.l10n.settingsAboutSupport,
    sections: [
      SettingsSectionSpec(
        id: 'about.links',
        title: (ctx) => ctx.l10n.settingsAboutSupport,
        entries: [
          SettingsNavEntry(
            id: 'about_github',
            title: (ctx) => ctx.l10n.settingsViewOnGitHub,
            keywords: (l10n) => <String>['github', 'source', 'repository'],
            icon: Icons.code_rounded,
            targetRoute: SettingsRoutes.about,
            onTapOverride: (context, ref) =>
                _openSupportLink(context, _githubRepoUri, context.l10n.settingsGitHubRepository),
          ),
          SettingsNavEntry(
            id: 'about_issue',
            title: (ctx) => ctx.l10n.settingsReportIssue,
            keywords: (l10n) => <String>['bug', 'issue', 'feedback', 'github'],
            icon: Icons.bug_report_outlined,
            targetRoute: SettingsRoutes.about,
            onTapOverride: (context, ref) =>
                _openSupportLink(context, _githubIssueUri, context.l10n.settingsIssueTracker),
          ),
          SettingsNavEntry(
            id: 'about_licenses',
            title: (ctx) => ctx.l10n.settingsInformationTitle,
            description: (ctx) => ctx.l10n.settingsInformationDescription,
            keywords: (l10n) => <String>['licenses', 'version', 'about', 'info'],
            icon: Icons.info_outline_rounded,
            targetRoute: SettingsRoutes.about,
            onTapOverride: (context, ref) => LicenseSettings.showLicensePage(context: context),
          ),
          SettingsNavEntry(
            id: 'about_changelog',
            title: (ctx) => ctx.l10n.changelogTitle,
            keywords: (l10n) => <String>['changelog', 'release notes', 'history'],
            icon: Icons.history_rounded,
            targetRoute: SettingsRoutes.about,
            onTapOverride: (context, ref) => showChangelogDialog(context),
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildSponsorPage() {
  return SettingsPageSpec(
    id: 'about.sponsor',
    route: SettingsRoutes.about,
    scope: SettingScope.app,
    icon: Icons.favorite_outline,
    title: (ctx) => ctx.l10n.settingsSponsor,
    subtitle: (ctx) => ctx.l10n.settingsSponsorDescription,
    registerRoute: false,
    onExternalTap: (context) => _openSupportLink(context, _githubSponsorUri, context.l10n.settingsGitHubSponsors),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'about_sponsor',
        title: (ctx) => ctx.l10n.settingsSponsor,
        description: (ctx) => ctx.l10n.settingsSponsorDescription,
        keywords: (l10n) => <String>['sponsor', 'donate', 'support', 'github'],
      ),
    ],
  );
}
