import 'dart:async';

import 'package:yaabsa/components/changelog/changelog_dialog.dart';

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/magic/magic_config.dart';
import 'package:yaabsa/components/common/desktop_page_shortcuts.dart';
import 'package:yaabsa/components/settings/admin_users/magic_config_dialog.dart';
import 'package:yaabsa/components/settings/management_settings_section.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_scope_invalidation.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_backup_settings.dart';
import 'package:yaabsa/screens/settings/android_auto_settings.dart';
import 'package:yaabsa/screens/settings/appearance_settings.dart';
import 'package:yaabsa/screens/settings/caching_settings.dart';
import 'package:yaabsa/screens/settings/player/global_player_settings.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/player/player_settings_compatibility.dart';
import 'package:yaabsa/screens/settings/library_settings.dart';
import 'package:yaabsa/screens/settings/download_settings.dart';
import 'package:yaabsa/screens/settings/license_settings.dart';
import 'package:yaabsa/screens/settings/log_view.dart';
import 'package:yaabsa/screens/settings/reader_settings.dart';
import 'package:yaabsa/screens/settings/server_connection_settings.dart';
import 'package:yaabsa/screens/settings/server_management_settings.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/auth/account_removal.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class SettingsSearchItem {
  final String title;
  final String description;
  final String categoryPath;
  final String route;

  const SettingsSearchItem({
    required this.title,
    required this.description,
    required this.categoryPath,
    required this.route,
  });
}

List<SettingsSearchItem> searchableSettings(AppLocalizations l10n) {
  return [
    SettingsSearchItem(
      title: l10n.settingsBackupTitle,
      description: l10n.settingsBackupDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryApplicationSettings),
      route: SettingsBackupSettings.routeName,
    ),
    SettingsSearchItem(
      title: l10n.settingRefreshProgressOnResume,
      description: l10n.settingRefreshProgressOnResumeDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navLibrary),
      route: LibrarySettings.routeName,
    ),
    if (PlayerSettingsCompatibility.isSupported)
      SettingsSearchItem(
        title: l10n.settingDisableFdkAacDecoder,
        description: l10n.settingDisableFdkAacDecoderDescription,
        categoryPath: _settingsCategoryPath(
          l10n,
          section: l10n.settingsCategoryPlayer,
          subsection: l10n.settingsCategoryCompatibility,
        ),
        route: PlayerSettingsCompatibility.routeName,
      ),
    SettingsSearchItem(
      title: l10n.settingServerManagement,
      description: l10n.settingServerManagementDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryManagement),
      route: '/settings/server-management',
    ),
    SettingsSearchItem(
      title: l10n.fieldTimelineMode,
      description: l10n.settingTimelineModeDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.fieldCoverSize,
      description: l10n.settingCoverSizeDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.fieldImmersivePlayerColors,
      description: l10n.settingImmersivePlayerColorsDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.settingTimelineMarkers,
      description: l10n.settingTimelineMarkersDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.fieldFastForwardInterval,
      description: l10n.settingFastForwardIntervalDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.fieldRewindInterval,
      description: l10n.settingRewindIntervalDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.settingRememberPlaybackSpeedPerBook,
      description: l10n.settingRememberPlaybackSpeedPerBookDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.settingAutoQueue,
      description: l10n.settingAutoQueueDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.settingAutoQueueEverywhere,
      description: l10n.settingAutoQueueEverywhereDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryGeneral,
      ),
      route: '/settings/player/general',
    ),
    SettingsSearchItem(
      title: l10n.settingSmartRewind,
      description: l10n.settingSmartRewindDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingSmartRewind,
      ),
      route: '/settings/player/smart-rewind',
    ),
    SettingsSearchItem(
      title: l10n.settingShortPauseThreshold,
      description: l10n.settingShortPauseThresholdDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingSmartRewind,
      ),
      route: '/settings/player/smart-rewind',
    ),
    SettingsSearchItem(
      title: l10n.settingLongPauseThreshold,
      description: l10n.settingLongPauseThresholdDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingSmartRewind,
      ),
      route: '/settings/player/smart-rewind',
    ),
    SettingsSearchItem(
      title: l10n.settingShortRewindAmount,
      description: l10n.settingShortRewindAmountDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingSmartRewind,
      ),
      route: '/settings/player/smart-rewind',
    ),
    SettingsSearchItem(
      title: l10n.settingMediumRewindAmount,
      description: l10n.settingMediumRewindAmountDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingSmartRewind,
      ),
      route: '/settings/player/smart-rewind',
    ),
    SettingsSearchItem(
      title: l10n.settingLongRewindAmount,
      description: l10n.settingLongRewindAmountDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingSmartRewind,
      ),
      route: '/settings/player/smart-rewind',
    ),
    SettingsSearchItem(
      title: l10n.settingSleepTimerEndAction,
      description: l10n.settingSleepTimerEndActionDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playbackSleepTimer,
      ),
      route: '/settings/player/sleep-timer',
    ),
    SettingsSearchItem(
      title: l10n.settingSleepTimerEndRewind,
      description: l10n.settingSleepTimerEndRewindDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playbackSleepTimer,
      ),
      route: '/settings/player/sleep-timer',
    ),
    SettingsSearchItem(
      title: l10n.settingFadeAudio,
      description: l10n.settingFadeAudioDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playbackSleepTimer,
      ),
      route: '/settings/player/sleep-timer',
    ),
    SettingsSearchItem(
      title: l10n.settingShowSleepTimerMarker,
      description: l10n.settingShowSleepTimerMarkerDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playbackSleepTimer,
      ),
      route: '/settings/player/sleep-timer',
    ),
    SettingsSearchItem(
      title: l10n.settingAutoRestartTimerOnPlaybackStart,
      description: l10n.settingAutoRestartTimerOnPlaybackStartDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playbackSleepTimer,
      ),
      route: '/settings/player/sleep-timer',
    ),
    SettingsSearchItem(
      title: l10n.settingAutoRestartDuringTimeRange,
      description: l10n.settingAutoRestartDuringTimeRangeDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playbackSleepTimer,
      ),
      route: '/settings/player/sleep-timer',
    ),
    SettingsSearchItem(
      title: l10n.settingAutoRestartRangeStart,
      description: l10n.settingAutoRestartRangeStartDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playbackSleepTimer,
      ),
      route: '/settings/player/sleep-timer',
    ),
    SettingsSearchItem(
      title: l10n.settingAutoRestartRangeEnd,
      description: l10n.settingAutoRestartRangeEndDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playbackSleepTimer,
      ),
      route: '/settings/player/sleep-timer',
    ),
    SettingsSearchItem(
      title: l10n.settingEnableSubtitles,
      description: l10n.settingEnableSubtitlesDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playerComponentSubtitles,
      ),
      route: '/settings/player/subtitles',
    ),
    SettingsSearchItem(
      title: l10n.settingHighlightSpeakerLabels,
      description: l10n.settingHighlightSpeakerLabelsDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playerComponentSubtitles,
      ),
      route: '/settings/player/subtitles',
    ),
    SettingsSearchItem(
      title: l10n.settingEnableReadAlong,
      description: l10n.settingEnableReadAlongDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.playerComponentSubtitles,
      ),
      route: '/settings/player/subtitles',
    ),
    SettingsSearchItem(
      title: l10n.settingShakeToResetSleepTimer,
      description: l10n.settingShakeToResetSleepTimerDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryShakeControls,
      ),
      route: '/settings/player/shake-controls',
    ),
    SettingsSearchItem(
      title: l10n.settingShakeToRewind,
      description: l10n.settingShakeToRewindDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryShakeControls,
      ),
      route: '/settings/player/shake-controls',
    ),
    SettingsSearchItem(
      title: l10n.settingShakeSensitivity,
      description: l10n.settingShakeSensitivityDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryShakeControls,
      ),
      route: '/settings/player/shake-controls',
    ),
    SettingsSearchItem(
      title: l10n.settingShakeVibrationFeedback,
      description: l10n.settingShakeVibrationFeedbackDescription,
      categoryPath: _settingsCategoryPath(
        l10n,
        section: l10n.settingsCategoryPlayer,
        subsection: l10n.settingsCategoryShakeControls,
      ),
      route: '/settings/player/shake-controls',
    ),
    SettingsSearchItem(
      title: l10n.settingShelfSections,
      description: l10n.settingShelfSectionsDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navLibrary),
      route: '/settings/library',
    ),
    SettingsSearchItem(
      title: l10n.settingLibraryGridScale,
      description: l10n.settingLibraryGridScaleDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navLibrary),
      route: '/settings/library',
    ),
    SettingsSearchItem(
      title: l10n.settingCollapseSeries,
      description: l10n.settingCollapseSeriesDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navLibrary),
      route: '/settings/library',
    ),
    SettingsSearchItem(
      title: l10n.settingViewSubtitles,
      description: l10n.settingViewSubtitlesDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navLibrary, subsection: l10n.settingViewSubtitles),
      route: '/settings/library/view-subtitles',
    ),
    SettingsSearchItem(
      title: l10n.settingShowShelfPlayButton,
      description: l10n.settingShowShelfPlayButtonDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navLibrary),
      route: '/settings/library',
    ),
    SettingsSearchItem(
      title: l10n.settingShowShuffleButton,
      description: l10n.settingShowShuffleButtonDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navLibrary),
      route: '/settings/library',
    ),
    SettingsSearchItem(
      title: l10n.settingCheckServerUpdates,
      description: l10n.settingCheckServerUpdatesDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navLibrary),
      route: '/settings/library',
    ),
    SettingsSearchItem(
      title: l10n.settingDownloadLocation,
      description: l10n.settingDownloadLocationDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navDownloads),
      route: '/settings/downloads',
    ),
    SettingsSearchItem(
      title: l10n.settingDownloadOnlyOnWiFi,
      description: l10n.settingDownloadOnlyOnWiFiDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navDownloads),
      route: '/settings/downloads',
    ),
    SettingsSearchItem(
      title: l10n.settingMaximumParallelDownloads,
      description: l10n.settingMaximumParallelDownloadsDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navDownloads),
      route: '/settings/downloads',
    ),
    SettingsSearchItem(
      title: l10n.settingSmartDownloads,
      description: l10n.settingSmartDownloadsDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.navDownloads),
      route: '/settings/library/smart-downloads',
    ),
    SettingsSearchItem(
      title: l10n.themeSettingsTitle,
      description: l10n.themeSettingsSubtitle,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryAppearance),
      route: '/settings/appearance/theme',
    ),
    SettingsSearchItem(
      title: l10n.navigationSettingsTitle,
      description: l10n.navigationSettingsSubtitle,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryAppearance),
      route: '/settings/appearance/navigation',
    ),
    SettingsSearchItem(
      title: l10n.fieldLanguage,
      description: l10n.settingLanguageDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryAppearance),
      route: '/settings/appearance',
    ),
    SettingsSearchItem(
      title: l10n.settingMaxBufferSize,
      description: l10n.settingMaxBufferSizeDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryGlobalPlayer),
      route: '/settings/global-player',
    ),
    SettingsSearchItem(
      title: l10n.settingKeepScreenOn,
      description: l10n.settingKeepScreenOnDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryGlobalPlayer),
      route: '/settings/global-player',
    ),
    SettingsSearchItem(
      title: l10n.settingLockMediaNotification,
      description: l10n.settingLockMediaNotificationDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryGlobalPlayer),
      route: '/settings/global-player',
    ),
    SettingsSearchItem(
      title: l10n.settingMediaNotificationType,
      description: l10n.settingMediaNotificationTypeDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryGlobalPlayer),
      route: '/settings/global-player',
    ),
    if (defaultTargetPlatform == TargetPlatform.android)
      SettingsSearchItem(
        title: l10n.settingMediaNotificationActions,
        description: l10n.settingMediaNotificationActionsDescription,
        categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryGlobalPlayer),
        route: '/settings/player/notification',
      ),
    SettingsSearchItem(
      title: l10n.settingAutoPlayLastPlayedOnAppStart,
      description: l10n.settingAutoPlayLastPlayedOnAppStartDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryGlobalPlayer),
      route: '/settings/global-player',
    ),
    SettingsSearchItem(
      title: l10n.settingAlwaysShowMiniPlayer,
      description: l10n.settingAlwaysShowMiniPlayerDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryGlobalPlayer),
      route: '/settings/global-player',
    ),
    SettingsSearchItem(
      title: l10n.settingKeepWebSocketActiveInBackground,
      description: l10n.settingKeepWebSocketActiveInBackgroundDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryGlobalPlayer),
      route: '/settings/global-player',
    ),
    SettingsSearchItem(
      title: l10n.settingEnableCaching,
      description: l10n.settingEnableCachingDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryCaching),
      route: '/settings/caching/general',
    ),
    SettingsSearchItem(
      title: l10n.settingSpeedupMode,
      description: l10n.settingSpeedupModeDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryCaching),
      route: '/settings/caching/general',
    ),
    SettingsSearchItem(
      title: l10n.actionRemoveAuthorsWithoutBooks,
      description: l10n.settingRemoveAuthorsWithoutBooksDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryTools),
      route: '/settings/tools',
    ),
    SettingsSearchItem(
      title: l10n.settingForceMetadataRefresh,
      description: l10n.settingForceMetadataRefreshDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryTools),
      route: '/settings/tools',
    ),
    SettingsSearchItem(
      title: l10n.settingMatchAudiobookChapters,
      description: l10n.settingMatchAudiobookChaptersDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryTools),
      route: '/settings/tools',
    ),
    SettingsSearchItem(
      title: l10n.settingSplitGenresAndTags,
      description: l10n.settingSplitGenresAndTagsDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryTools),
      route: '/settings/tools',
    ),
    SettingsSearchItem(
      title: l10n.settingLogLevel,
      description: l10n.settingLogLevelDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryLogs),
      route: '/settings/logs',
    ),
    SettingsSearchItem(
      title: l10n.settingReaderTheme,
      description: l10n.settingReaderThemeDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryReader),
      route: '/settings/reader',
    ),
    SettingsSearchItem(
      title: l10n.readerFieldTextSize,
      description: l10n.settingReaderFontSizeDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryReader),
      route: '/settings/reader',
    ),
    SettingsSearchItem(
      title: l10n.readerFieldLineSpacing,
      description: l10n.settingReaderLineSpacingDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryReader),
      route: '/settings/reader',
    ),
    SettingsSearchItem(
      title: l10n.readerFieldPageLayout,
      description: l10n.settingReaderLayoutModeDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryReader),
      route: '/settings/reader',
    ),
    SettingsSearchItem(
      title: l10n.readerHideMiniPlayer,
      description: l10n.readerHideMiniPlayerDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryReader),
      route: '/settings/reader',
    ),
    SettingsSearchItem(
      title: l10n.settingStartSessionWhenReading,
      description: l10n.settingStartSessionWhenReadingDescription,
      categoryPath: _settingsCategoryPath(l10n, section: l10n.settingsCategoryReader),
      route: '/settings/reader',
    ),
  ];
}

String _settingsCategoryPath(AppLocalizations l10n, {required String section, String? subsection}) {
  final category = subsection ?? 'none';

  return l10n.settingsCategoryPath(l10n.navSettings, section, category);
}

class MainSettingsScreen extends ConsumerStatefulWidget {
  const MainSettingsScreen({super.key});

  static const String routeName = '/settings';

  @override
  ConsumerState<MainSettingsScreen> createState() => _MainSettingsScreenState();
}

class _MainSettingsScreenState extends ConsumerState<MainSettingsScreen> {
  static final Uri _githubRepoUri = Uri.parse('https://github.com/Vito0912/yaabsa/');
  static final Uri _githubIssueUri = Uri.parse('https://github.com/Vito0912/yaabsa/issues');
  static final Uri _githubSponsorUri = Uri.parse('https://github.com/sponsors/Vito0912');

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(debugLabel: 'settings-search');
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  IconData _getIconForRoute(String route) {
    if (route.contains('/player')) {
      return Icons.play_circle_outline_rounded;
    }
    if (route.contains('/downloads') || route.contains('/smart-downloads')) {
      return Icons.download_for_offline_outlined;
    }
    if (route.contains('/library')) {
      return Icons.library_books_outlined;
    }
    if (route.contains('/appearance')) {
      return Icons.palette_outlined;
    }
    if (route.contains('/android-auto') || route.contains('/aaos')) {
      return Icons.directions_car_filled_outlined;
    }
    if (route.contains('/caching')) {
      return Icons.cached_outlined;
    }
    if (route.contains('/tools')) {
      return Icons.construction_rounded;
    }
    if (route.contains('/logs')) {
      return Icons.article_outlined;
    }
    return Icons.settings_outlined;
  }

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

  Future<void> _deleteUser(BuildContext context, WidgetRef ref, User user) async {
    final db = ref.read(appDatabaseProvider);

    try {
      final wasActiveUser = await removeStoredAccount(db: db, user: user);

      if (wasActiveUser) {
        final remainingUsers = await db.getAllStoredUsers();
        if (remainingUsers.isNotEmpty) {
          await db.setActiveUserId(remainingUsers.first.id);
        } else {
          await db.clearActiveUserId();
        }
      }

      ref.invalidate(allStoredUsersProvider);
      ref.invalidate(currentUserProvider);
      invalidateUserScopedProviders(ref);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.settingsAccountRemoved(user.username))));
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.settingsAccountRemovalFailed(user.username))));
    }
  }

  bool _hasAnyServerManagementPermission(User user) {
    final permissions = user.permissions;
    return permissions.update || permissions.delete || permissions.upload;
  }

  Future<MagicConfigKeyMarker?> _readAuthenticationCodeKey() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    try {
      final status = (await api.getMeApi().getStatus()).data;
      final customMessage = status?.authFormData?.authLoginCustomMessage;
      return MagicConfigKeyMarker.extract(customMessage) ??
          MagicConfigKeyMarker.fromSerializedName(MagicConfigKeyMarker.extractFromSanitizedHtml(customMessage));
    } catch (error, stackTrace) {
      logger(
        'Could not read the Authentication Code key from server status: $error\n$stackTrace',
        tag: 'MainSettingsScreen',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  Future<void> _showOwnMagicConfig(BuildContext context, User user) async {
    final server = user.server;
    if (server == null || server.url.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.settingsNoServerAddress)));
      return;
    }

    await showMagicConfigDialog(
      context,
      serverUrl: server.url,
      localServerUrl: server.localUrl,
      username: user.username,
      password: null,
      headers: Map<String, String>.from(server.headers ?? const <String, String>{}),
      allowPassword: false,
      ensureMarker: _readAuthenticationCodeKey,
    );
  }

  Future<void> _switchActiveUser(BuildContext context, WidgetRef ref, User user) async {
    final db = ref.read(appDatabaseProvider);

    await db.setActiveUserId(user.id);
    ref.invalidate(currentUserProvider);
    ref.invalidate(allStoredUsersProvider);
    invalidateUserScopedProviders(ref);

    try {
      await db
          .watchGlobalSetting('activeUserId')
          .map((setting) => setting?.value)
          .firstWhere((activeUserId) => activeUserId == user.id)
          .timeout(const Duration(seconds: 2));
    } on TimeoutException {
      logger(
        'Timed out waiting for activeUserId to publish ${user.id} after account switch.',
        tag: 'MainSettingsScreen',
        level: InfoLevel.debug,
      );
    }

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.settingsAccountSwitched(user.username))));
  }

  void _showDeleteUserConfirmationDialog(BuildContext context, User user, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(context.l10n.settingsRemoveAccountTitle),
          content: Text(context.l10n.settingsRemoveAccountPrompt(user.username)),
          actions: <Widget>[
            TextButton(child: Text(context.l10n.actionCancel), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: Text(context.l10n.actionRemove, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteUser(context, ref, user);
              },
            ),
          ],
        );
      },
    );
  }

  void _showSignOutCurrentUserConfirmationDialog(BuildContext context, User user, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(context.l10n.actionSignOut),
          content: Text(context.l10n.settingsSignOutPrompt(user.username)),
          actions: <Widget>[
            TextButton(child: Text(context.l10n.actionCancel), onPressed: () => Navigator.of(dialogContext).pop()),
            TextButton(
              child: Text(context.l10n.actionSignOut, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteUser(context, ref, user);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserManagementSection(BuildContext context, WidgetRef ref) {
    final asyncCurrentUser = ref.watch(currentUserProvider);
    final asyncAllUsers = ref.watch(allStoredUsersProvider);

    return asyncCurrentUser.when(
      data: (currentUser) {
        final allUsersList = asyncAllUsers.asData?.value ?? [];
        final otherUsers = currentUser != null
            ? allUsersList.where((user) => user.id != currentUser.id).toList()
            : allUsersList;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                context.l10n.settingsActiveAccount,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: currentUser != null
                      ? Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                currentUser.username.substring(0, 1).toUpperCase(),
                                style: TextStyle(fontSize: 24, color: Theme.of(context).colorScheme.onPrimary),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentUser.username,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  Text(
                                    currentUser.server?.url ?? context.l10n.errorConnectionUnavailable,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _showOwnMagicConfig(context, currentUser),
                              icon: const Icon(Icons.qr_code_2_rounded),
                              tooltip: context.l10n.settingsCreateAuthenticationCode,
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              tooltip: context.l10n.settingsServerConnection,
                              icon: const Icon(Icons.dns_outlined),
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                              onPressed: () => context.push(ServerConnectionSettings.routeName),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            context.l10n.errorNoActiveUser,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.manage_accounts_outlined),
                      label: Text(context.l10n.settingsManageAccounts),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: () {
                        _showManageAccountsBottomSheet(context, ref, currentUser, otherUsers);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                      label: Text(context.l10n.settingsAddAccount),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      onPressed: () {
                        if (AaosService.instance.currentState.isAutomotiveDevice) {
                          context.go('/add-user');
                          return;
                        }

                        context.push('/add-user');
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (currentUser != null) ...[
              SettingsNavigationSection(
                title: context.l10n.settingsAccountPreferences(currentUser.username),
                items: [
                  if (!AaosService.instance.currentState.isAutomotiveDevice &&
                      _hasAnyServerManagementPermission(currentUser))
                    SettingsNavigationItem(
                      icon: Icons.admin_panel_settings_outlined,
                      title: context.l10n.settingServerManagement,
                      onTap: () => context.push(ServerManagementSettings.routeName),
                    ),
                  SettingsNavigationItem(
                    icon: Icons.play_circle_outline_rounded,
                    title: context.l10n.settingsPlayerSettings,
                    onTap: () => context.push(PlayerSettings.routeName),
                  ),
                  if (!AaosService.instance.currentState.isAutomotiveDevice)
                    SettingsNavigationItem(
                      icon: Icons.menu_book_rounded,
                      title: context.l10n.readerSettingsTitle,
                      onTap: () => context.push(ReaderSettings.routeName),
                    ),
                ],
              ),
            ],
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: YaabsaCircularProgressIndicator()),
      ),
      error: (e, st) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(context.l10n.errorCouldNotLoadUser, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }

  void _showManageAccountsBottomSheet(BuildContext context, WidgetRef ref, User? currentUser, List<User> otherUsers) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext bottomSheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(context.l10n.settingsManageAccounts, style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          if (currentUser != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                              child: Text(
                                context.l10n.settingsCurrentAccount,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          if (currentUser != null)
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                child: Text(currentUser.username.substring(0, 1).toUpperCase()),
                              ),
                              title: Text(currentUser.username),
                              subtitle: Text(currentUser.server?.url ?? context.l10n.errorConnectionUnavailable),
                              trailing: IconButton(
                                icon: Icon(Icons.logout_rounded, color: Theme.of(context).colorScheme.error),
                                tooltip: context.l10n.actionSignOut,
                                onPressed: () {
                                  Navigator.pop(bottomSheetContext);
                                  _showSignOutCurrentUserConfirmationDialog(context, currentUser, ref);
                                },
                              ),
                            ),
                          if (currentUser != null) const Divider(height: 1),
                          if (otherUsers.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                              child: Text(
                                context.l10n.settingsOtherAccounts,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          if (otherUsers.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                context.l10n.settingsNoOtherAccounts,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ...otherUsers.map((user) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                child: Text(user.username.substring(0, 1).toUpperCase()),
                              ),
                              title: Text(user.username),
                              subtitle: Text(user.server?.url ?? context.l10n.statusServerAddressUnavailable),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.swap_horiz_rounded, color: Theme.of(context).colorScheme.primary),
                                    tooltip: context.l10n.settingsSwitchToUser,
                                    onPressed: () async {
                                      Navigator.pop(bottomSheetContext);
                                      await _switchActiveUser(context, ref, user);
                                    },
                                  ),
                                  YaabsaDeleteIconButton(
                                    tooltip: context.l10n.actionRemove,
                                    onPressed: () {
                                      Navigator.pop(bottomSheetContext);
                                      _showDeleteUserConfirmationDialog(context, user, ref);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    final showCarIntegrationSettings = isAndroid || isIOS;

    final searchQuery = _searchQuery.trim().toLowerCase();
    final filteredSettings = searchableSettings(context.l10n).where((item) {
      if (searchQuery.isEmpty) {
        return false;
      }

      return item.title.toLowerCase().contains(searchQuery) || item.description.toLowerCase().contains(searchQuery);
    }).toList();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SearchBar(
            focusNode: _searchFocusNode,
            leading: const Icon(Icons.search),
            hintText: context.l10n.settingsSearchHint,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            trailing: _searchQuery.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  ]
                : null,
            controller: _searchController,
            elevation: const WidgetStatePropertyAll<double>(1.0),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: <Widget>[
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: _searchQuery.trim().isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (filteredSettings.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        size: 48,
                                        color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        context.l10n.searchNoResultsFor(_searchQuery),
                                        style: Theme.of(context).textTheme.titleMedium
                                            ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              SettingsNavigationSection(
                                title: context.l10n.searchResults,
                                topPadding: 12,
                                items: filteredSettings.map((item) {
                                  return SettingsNavigationItem(
                                    icon: _getIconForRoute(item.route),
                                    title: item.title,
                                    subtitle: '${item.categoryPath}\n${item.description}',
                                    onTap: () {
                                      if (item.route == '/settings/logs') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LogView()),
                                        );
                                      } else {
                                        context.push(item.route);
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildUserManagementSection(context, ref),
                            StreamBuilder<AaosTelemetryState>(
                              stream: AaosService.instance.stream,
                              initialData: AaosService.instance.currentState,
                              builder: (context, snapshot) {
                                final aaosState = snapshot.data ?? AaosService.instance.currentState;
                                final isAaos = aaosState.isAutomotiveDevice;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    if (isAaos)
                                      SettingsNavigationSection(
                                        title: context.l10n.settingsCarIntegration,
                                        items: [
                                          SettingsNavigationItem(
                                            icon: Icons.play_circle_outline,
                                            title: context.l10n.aaosOpenMediaCenter,
                                            onTap: () async {
                                              await AaosService.instance.launchMediaCenter(finishActivity: true);
                                            },
                                          ),
                                        ],
                                      ),
                                    SettingsNavigationSection(
                                      title: context.l10n.settingsCategoryApplicationSettings,
                                      items: [
                                        SettingsNavigationItem(
                                          icon: Icons.library_books_outlined,
                                          title: context.l10n.navLibrary,
                                          onTap: () => context.push(LibrarySettings.routeName),
                                        ),
                                        SettingsNavigationItem(
                                          icon: Icons.download_for_offline_outlined,
                                          title: context.l10n.navDownloads,
                                          onTap: () => context.push(DownloadSettings.routeName),
                                        ),
                                        SettingsNavigationItem(
                                          icon: Icons.palette_outlined,
                                          title: context.l10n.settingsCategoryAppearance,
                                          onTap: () => context.push(AppearanceSettings.routeName),
                                        ),
                                        SettingsNavigationItem(
                                          icon: Icons.play_circle_outline_outlined,
                                          title: context.l10n.settingsCategoryGlobalPlayer,
                                          onTap: () => context.push(GlobalPlayerSettings.routeName),
                                        ),
                                        if (showCarIntegrationSettings)
                                          SettingsNavigationItem(
                                            icon: Icons.directions_car_filled_outlined,
                                            title: aaosState.isAutomotiveDevice
                                                ? context.l10n.settingsAndroidAutomotive
                                                : (isIOS
                                                      ? context.l10n.settingsCarPlay
                                                      : context.l10n.settingsAndroidAuto),
                                            onTap: () => context.push(AndroidAutoSettings.routeName),
                                          ),
                                        SettingsNavigationItem(
                                          icon: Icons.cached_outlined,
                                          title: context.l10n.settingsCategoryCaching,
                                          onTap: () => context.push(CachingSettings.routeName),
                                        ),
                                        SettingsNavigationItem(
                                          icon: Icons.settings_backup_restore_rounded,
                                          title: context.l10n.settingsBackupTitle,
                                          onTap: () => context.push(SettingsBackupSettings.routeName),
                                        ),
                                        SettingsNavigationItem(
                                          icon: Icons.menu_book_outlined,
                                          title: context.l10n.readerSettingsTitle,
                                          onTap: () => context.push(ReaderSettings.routeName),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            ref
                                .watch(currentUserProvider)
                                .when(
                                  data: (currentUser) {
                                    if (currentUser == null || AaosService.instance.currentState.isAutomotiveDevice) {
                                      return const SizedBox.shrink();
                                    }

                                    return ManagementSettingsSection(currentUser: currentUser);
                                  },
                                  loading: () => const SizedBox.shrink(),
                                  error: (error, stackTrace) => const SizedBox.shrink(),
                                ),
                            SettingsNavigationSection(
                              title: context.l10n.settingsAboutSupport,
                              items: [
                                SettingsNavigationItem(
                                  icon: Icons.code_rounded,
                                  title: context.l10n.settingsViewOnGitHub,
                                  onTap: () =>
                                      _openSupportLink(context, _githubRepoUri, context.l10n.settingsGitHubRepository),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.bug_report_outlined,
                                  title: context.l10n.settingsReportIssue,
                                  onTap: () =>
                                      _openSupportLink(context, _githubIssueUri, context.l10n.settingsIssueTracker),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.favorite_outline,
                                  title: context.l10n.settingsSponsor,
                                  subtitle: context.l10n.settingsSponsorDescription,
                                  onTap: () =>
                                      _openSupportLink(context, _githubSponsorUri, context.l10n.settingsGitHubSponsors),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.article_outlined,
                                  title: context.l10n.settingsCategoryLogs,
                                  onTap: () =>
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LogView())),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.info_outline_rounded,
                                  title: context.l10n.settingsInformationTitle,
                                  subtitle: context.l10n.settingsInformationDescription,
                                  onTap: () => LicenseSettings.showLicensePage(context: context),
                                ),
                                SettingsNavigationItem(
                                  icon: Icons.history_rounded,
                                  title: context.l10n.changelogTitle,
                                  onTap: () => showChangelogDialog(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return DesktopPageShortcuts(
      onSearch: () {
        _searchFocusNode.requestFocus();
        _searchController.selection = TextSelection(baseOffset: 0, extentOffset: _searchController.text.length);
      },
      onDismiss: () {
        if (!_searchFocusNode.hasFocus) return false;
        _searchController.clear();
        setState(() {
          _searchQuery = '';
        });
        _searchFocusNode.unfocus();
        return true;
      },
      child: content,
    );
  }
}
