import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/account_car_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/download_settings.dart';
import 'package:yaabsa/screens/settings/library_order_settings.dart';
import 'package:yaabsa/screens/settings/library_shelf_settings.dart';
import 'package:yaabsa/screens/settings/library_view_subtitle_settings.dart';
import 'package:yaabsa/screens/settings/library_views_settings.dart';
import 'package:yaabsa/screens/settings/smart_downloads_settings.dart';
import 'package:yaabsa/util/layout_sizes.dart';

List<SettingsPageSpec> buildAccountSettingsPages() {
  return <SettingsPageSpec>[
    _buildLibraryPage(),
    _buildLibraryOrderPage(),
    _buildLibraryViewsPage(),
    _buildLibraryShelfPage(),
    _buildLibraryViewSubtitlesPage(),
    _buildDownloadsPage(),
    _buildSmartDownloadsPage(),
    ...buildAccountCarSettingsPages(),
  ];
}

SettingsPageSpec _buildLibraryPage() {
  return SettingsPageSpec(
    id: 'account.library',
    route: SettingsRoutes.library,
    scope: SettingScope.account,
    icon: Icons.library_books_outlined,
    title: (ctx) => ctx.l10n.navLibrary,
    subtitle: (ctx) => ctx.l10n.settingsLibrarySettingsDescription,
    requiresSignIn: true,
    sections: [
      SettingsSectionSpec(
        id: 'account.library.views',
        title: (ctx) => ctx.l10n.navLibraries,
        entries: [
          SettingsNavEntry(
            id: 'library_order_nav',
            title: (ctx) => ctx.l10n.navLibraries,
            description: (ctx) => ctx.l10n.settingsLibraryOrderDescription,
            icon: Icons.sort_rounded,
            targetRoute: SettingsRoutes.libraryOrder,
            targetPageId: 'account.library.order',
          ),
          SettingsNavEntry(
            id: 'library_views_nav',
            title: (ctx) => ctx.l10n.navigationSettingsTitle,
            description: (ctx) => ctx.l10n.navigationSettingsSubtitle,
            icon: Icons.tune_rounded,
            targetRoute: SettingsRoutes.libraryViews,
            targetPageId: 'account.library.views',
          ),
          SettingsNavEntry(
            id: 'library_shelf_nav',
            title: (ctx) => ctx.l10n.settingShelfSections,
            description: (ctx) => ctx.l10n.settingShelfSectionsDescription,
            icon: Icons.view_carousel_outlined,
            targetRoute: SettingsRoutes.libraryShelf,
            targetPageId: 'account.library.shelf',
          ),
          SettingsNavEntry(
            id: 'library_view_subtitles_nav',
            title: (ctx) => ctx.l10n.settingViewSubtitles,
            description: (ctx) => ctx.l10n.settingViewSubtitlesDescription,
            icon: Icons.subtitles_outlined,
            targetRoute: SettingsRoutes.libraryViewSubtitles,
            targetPageId: 'account.library.view_subtitles',
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'account.library.display',
        title: (ctx) => ctx.l10n.settingsDisplayTitle,
        entries: [
          SettingsSliderEntry<double>(
            id: 'library_grid_scale',
            title: (ctx) => ctx.l10n.settingLibraryGridScale,
            description: (ctx) => ctx.l10n.settingLibraryGridScaleDescription,
            keywords: (l10n) => <String>[l10n.navLibrary, 'grid', 'scale', 'cover', 'size'],
            definition: AppSettingDefs.libraryGridScale,
            scopeOverride: SettingScope.app,
            values: appLibraryGridScaleOptions,
            labelForValue: (ctx, value) => '${(value * 100).round()}%',
          ),
          SettingsToggleEntry(
            id: 'collapse_series',
            title: (ctx) => ctx.l10n.settingCollapseSeries,
            description: (ctx) => ctx.l10n.settingCollapseSeriesDescription,
            keywords: (l10n) => <String>['series', 'collapse', 'group'],
            definition: AppSettingDefs.collapseSeries,
          ),
          SettingsToggleEntry(
            id: 'show_shelf_play_button',
            title: (ctx) => ctx.l10n.settingShowShelfPlayButton,
            description: (ctx) => ctx.l10n.settingShowShelfPlayButtonDescription,
            keywords: (l10n) => <String>['shelf', 'home', 'play button'],
            definition: AppSettingDefs.personalizedShelfShowPlayVisibleButton,
            scopeOverride: SettingScope.app,
          ),
          SettingsToggleEntry(
            id: 'show_shuffle_button',
            title: (ctx) => ctx.l10n.settingShowShuffleButton,
            description: (ctx) => ctx.l10n.settingShowShuffleButtonDescription,
            keywords: (l10n) => <String>['shuffle', 'random', 'library'],
            definition: AppSettingDefs.showShuffleButton,
          ),
          SettingsToggleEntry(
            id: 'refresh_progress_on_resume',
            title: (ctx) => ctx.l10n.settingRefreshProgressOnResume,
            description: (ctx) => ctx.l10n.settingRefreshProgressOnResumeDescription,
            keywords: (l10n) => <String>['progress', 'sync', 'refresh', 'resume'],
            definition: AppSettingDefs.refreshProgressOnAppResume,
            scopeOverride: SettingScope.app,
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildLibraryOrderPage() {
  return SettingsPageSpec(
    id: 'account.library.order',
    parentId: 'account.library',
    route: SettingsRoutes.libraryOrder,
    scope: SettingScope.account,
    icon: Icons.sort_rounded,
    title: (ctx) => ctx.l10n.navLibraries,
    subtitle: (ctx) => ctx.l10n.settingsLibraryOrderDescription,
    requiresSignIn: true,
    customPageBuilder: (context, {focusEntryId}) => const LibraryOrderSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'library_order_meta',
        title: (ctx) => ctx.l10n.navLibraries,
        description: (ctx) => ctx.l10n.settingsLibraryOrderDescription,
        keywords: (l10n) => <String>[l10n.navLibrary, 'order', 'sort', 'libraries'],
      ),
    ],
  );
}

SettingsPageSpec _buildLibraryViewsPage() {
  return SettingsPageSpec(
    id: 'account.library.views',
    parentId: 'account.library',
    route: SettingsRoutes.libraryViews,
    scope: SettingScope.account,
    icon: Icons.tune_rounded,
    title: (ctx) => ctx.l10n.navigationSettingsTitle,
    subtitle: (ctx) => ctx.l10n.navigationSettingsSubtitle,
    requiresSignIn: true,
    customPageBuilder: (context, {focusEntryId}) => const LibraryViewsSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'library_views_meta',
        title: (ctx) => ctx.l10n.navigationSettingsTitle,
        description: (ctx) => ctx.l10n.navigationSettingsSubtitle,
        keywords: (l10n) => <String>[l10n.navLibrary, 'tabs', 'navigation', 'default view', 'views'],
      ),
    ],
  );
}

SettingsPageSpec _buildLibraryShelfPage() {
  return SettingsPageSpec(
    id: 'account.library.shelf',
    parentId: 'account.library',
    route: SettingsRoutes.libraryShelf,
    scope: SettingScope.account,
    icon: Icons.view_carousel_outlined,
    title: (ctx) => ctx.l10n.settingShelfSections,
    subtitle: (ctx) => ctx.l10n.settingShelfSectionsDescription,
    requiresSignIn: true,
    customPageBuilder: (context, {focusEntryId}) => const LibraryShelfSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'library_shelf_meta',
        title: (ctx) => ctx.l10n.settingShelfSections,
        description: (ctx) => ctx.l10n.settingShelfSectionsDescription,
        keywords: (l10n) => <String>[l10n.navLibrary, 'shelf', 'home', 'sections'],
      ),
    ],
  );
}

SettingsPageSpec _buildLibraryViewSubtitlesPage() {
  return SettingsPageSpec(
    id: 'account.library.view_subtitles',
    parentId: 'account.library',
    route: SettingsRoutes.libraryViewSubtitles,
    scope: SettingScope.account,
    icon: Icons.subtitles_outlined,
    title: (ctx) => ctx.l10n.settingViewSubtitles,
    subtitle: (ctx) => ctx.l10n.settingViewSubtitlesDescription,
    requiresSignIn: true,
    customPageBuilder: (context, {focusEntryId}) => const LibraryViewSubtitleSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'library_view_subtitles_meta',
        title: (ctx) => ctx.l10n.settingViewSubtitles,
        description: (ctx) => ctx.l10n.settingViewSubtitlesDescription,
        keywords: (l10n) => <String>[l10n.navLibrary, 'subtitle', 'card', 'metadata'],
      ),
    ],
  );
}

SettingsPageSpec _buildDownloadsPage() {
  return SettingsPageSpec(
    id: 'account.downloads',
    route: SettingsRoutes.downloads,
    scope: SettingScope.account,
    icon: Icons.download_for_offline_outlined,
    title: (ctx) => ctx.l10n.navDownloads,
    subtitle: (ctx) => ctx.l10n.settingsDownloadsDescription,
    requiresSignIn: true,
    customPageBuilder: (context, {focusEntryId}) => const DownloadSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'download_location_meta',
        title: (ctx) => ctx.l10n.settingDownloadLocation,
        description: (ctx) => ctx.l10n.settingDownloadLocationDescription,
        keywords: (l10n) => <String>[l10n.navDownloads, l10n.actionDownload, 'folder', 'storage', 'path'],
        availability: (ctx) {
          if (ctx.supportsCustomDownloadLocation) {
            return const SettingsAvailability.available();
          }

          return const SettingsAvailability.hidden();
        },
      ),
      SettingsSearchMetadata(
        id: 'download_preference_meta',
        title: (ctx) => ctx.l10n.settingDownloadPreference,
        description: (ctx) => ctx.l10n.settingDownloadPreferenceDescription,
        keywords: (l10n) => <String>[l10n.navDownloads, l10n.actionDownload, 'format', 'preference'],
      ),
      SettingsSearchMetadata(
        id: 'download_all_audio_meta',
        title: (ctx) => ctx.l10n.settingDownloadAllAudioFiles,
        description: (ctx) => ctx.l10n.settingDownloadAllAudioFilesDescription,
        keywords: (l10n) => <String>[l10n.navDownloads, l10n.actionDownload, 'audio', 'tracks'],
      ),
      SettingsSearchMetadata(
        id: 'download_wifi_only_meta',
        title: (ctx) => ctx.l10n.settingDownloadOnlyOnWiFi,
        description: (ctx) => ctx.l10n.settingDownloadOnlyOnWiFiDescription,
        keywords: (l10n) => <String>[l10n.navDownloads, l10n.actionDownload, 'wifi', 'wi-fi', 'cellular', 'network'],
      ),
      SettingsSearchMetadata(
        id: 'download_max_parallel_meta',
        title: (ctx) => ctx.l10n.settingMaximumParallelDownloads,
        description: (ctx) => ctx.l10n.settingMaximumParallelDownloadsDescription,
        keywords: (l10n) => <String>[l10n.navDownloads, l10n.actionDownload, 'parallel', 'concurrent'],
      ),
    ],
  );
}

SettingsPageSpec _buildSmartDownloadsPage() {
  return SettingsPageSpec(
    id: 'account.downloads.smart',
    parentId: 'account.downloads',
    route: SettingsRoutes.smartDownloads,
    scope: SettingScope.account,
    icon: Icons.download_for_offline_rounded,
    title: (ctx) => ctx.l10n.settingSmartDownloads,
    subtitle: (ctx) => ctx.l10n.settingSmartDownloadsDescription,
    requiresSignIn: true,
    customPageBuilder: (context, {focusEntryId}) => const SmartDownloadsSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'smart_downloads_meta',
        title: (ctx) => ctx.l10n.settingSmartDownloads,
        description: (ctx) => ctx.l10n.settingSmartDownloadsDescription,
        keywords: (l10n) => <String>[l10n.navDownloads, l10n.actionDownload, 'smart', 'auto download', 'queue'],
      ),
    ],
  );
}
