import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/theme/app_theme.dart';
import 'package:yaabsa/ui/theme/theme_selection.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/util/globals.dart';

import 'input_previews.dart';
import 'admin_previews.dart';
import 'dialog_previews.dart';
import 'list_controls_preview.dart';
import 'library_previews.dart';
import 'material_3_controls_preview.dart';
import 'library_grid_preview.dart';
import 'media_previews.dart';
import 'search_preview.dart';
import 'player_previews.dart';
import 'mini_player_previews.dart';
import 'settings_previews.dart';
import 'statistics_previews.dart';
import 'upload_previews.dart';
import 'library_management_previews.dart';
import 'reader_previews.dart';

import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';

class UiLab extends StatefulWidget {
  const UiLab({super.key, this.initialScenario = 'Inputs'});

  final String initialScenario;

  @override
  State<UiLab> createState() => _UiLabState();
}

class _UiLabState extends State<UiLab> {
  AppThemeMode _mode = AppThemeMode.light;
  late String _scenario;
  bool _playing = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scenario = widget.initialScenario;
  }

  Widget _buildScenario(BuildContext context) {
    switch (_scenario) {
      case 'Player':
        return PlayerControlsPreview(
          isPlaying: _playing,
          isLoading: _loading,
          showSimulationControls: true,
          onPlaybackChanged: (value) => setState(() => _playing = value),
          onLoadingChanged: (value) => setState(() => _loading = value),
        );
      case 'Mini player':
        return MiniPlayerPresentationPreview(compact: context.isMobile);
      case 'Player collections':
        return const PlayerCollectionsPreview();
      case 'Player empty states':
        return const PlayerCollectionEmptyPreview();
      case 'Player timer':
        return const SleepTimerStatesPreview();
      case 'Player speed':
        return const PlaybackSpeedSettingsPreview();
      case 'Player subtitles':
        return const PlayerSubtitlePreview();
      case 'Player casting':
        return const PlayerCastPreview();
      case 'Player bookmarks':
        return const PlayerBookmarksPreview();
      case 'Player actions':
        return const PlayerActionBarPreview();
      case 'Player metadata':
        return const PlayerMediaMetadataPreview();
      case 'Player transport buttons':
        return const PlayerTransportButtonsPreview();
      case 'Playback states':
        return playbackStatesPreview();
      case 'Player seek timeline':
        return seekTimelinePreview();
      case 'Player horizontal volume':
        return horizontalVolumeSliderPreview();
      case 'Player vertical volume':
        return verticalVolumeSliderPreview();
      case 'Shared side actions':
        return sharedSideActionsPreview();
      case 'Series and narrator sort headers':
        return const SortHeaderControlsPreview();
      case 'Shared buttons':
        return sharedButtonsPreview();
      case 'Prominent library playback':
        return prominentLibraryPlaybackActionsPreview();
      case 'Player layout':
        return LayoutBuilder(
          builder: (context, constraints) {
            return PlayerGridLayoutPreview(screenSize: PlayerLayoutScreenSize.fromBreakpoint(context.breakpoint));
          },
        );
      case 'Player component settings':
        return const PlayerComponentSettingsPreview();
      case 'Settings':
        return const SettingsControlsPreview();
      case 'Administration users':
        return const AdminUsersTablePreview();
      case 'Administration access':
        return const AdminAccessSelectorPreview();
      case 'Reader annotations':
        return const ReaderAnnotationDetailsPreview();
      case 'Statistics':
        return const StatisticsDashboardPreview();
      case 'Statistics states':
        return const StatisticsAsyncErrorStatesPreview();
      case 'Statistics compact':
        return const StatisticsCompactDashboardPreview();
      case 'Statistics loading':
        return const StatisticsLoadingStatesPreview();
      case 'Statistics without activity':
        return const StatisticsNoActivityPreview();
      case 'Statistics achievements':
        return const StatisticsAchievementsPreview();
      case 'Statistics advanced':
        return const StatisticsAdvancedDashboardPreview();
      case 'Statistics year in review':
        return const StatisticsYearRewindPreview();
      case 'Statistics sessions':
        return const StatisticsSessionsAndWeekdaysPreview();
      case 'Statistics totals':
        return const StatisticsActivityTotalsPreview();
      case 'Statistics panels':
        return const StatisticsPanelControlsPreview();
      case 'Statistics metrics':
        return const SingleChildScrollView(child: StatisticsMetricsPreview());
      case 'Statistics 7 day chart':
        return const SingleChildScrollView(child: StatisticsRangeChartPreview(initialRange: 7));
      case 'Statistics year chart':
        return const SingleChildScrollView(child: StatisticsRangeChartPreview(initialRange: 365));
      case 'Statistics recent activity map':
        return const SingleChildScrollView(child: StatisticsHeatmapPreview(days: 84));
      case 'Statistics year activity map':
        return const SingleChildScrollView(child: StatisticsHeatmapPreview(days: 365));
      case 'Statistics ranked listening':
        return const SingleChildScrollView(child: StatisticsRankedPreview());
      case 'Statistics empty states':
        return const SingleChildScrollView(child: StatisticsEmptyPreview());
      case 'Statistics messages':
        return const SingleChildScrollView(child: StatisticsMessagesPreview());
      case 'Statistics surface cards':
        return const SingleChildScrollView(child: StatisticsSurfaceCardsPreview());
      case 'Upload controls':
        return const UploadQueueActionsPreview();
      case 'Add book files':
        return const UploadWorkspacePreview(addToBook: true);
      case 'Add book files queue':
        return itemUploadQueuePreview();
      case 'Upload workspace':
        return const UploadWorkspacePreview();
      case 'Upload drop zone':
        return const UploadDropZonePreview();
      case 'Upload metadata':
        return const UploadBulkMetadataPreview();
      case 'Upload item':
        return const UploadItemCardPreview(compact: true);
      case 'Upload path conflicts':
        return const UploadPathConflictDialogLauncher();
      case 'Upload advanced options':
        return const UploadAdvancedOptionsPreview();
      case 'Dialogs':
        return const DialogActionsPreview();
      case 'Library':
        return const LibraryCardsPreview();
      case 'Search results':
        return const SearchResultsPreview();
      case 'Library grid':
        return const LibraryGridLabPreview();
      case 'Loading covers':
        return const LoadingCoverCardsPreview();
      case 'Shared play buttons':
        return const SharedMediaPlayButtonsPreview();
      case 'Book information actions':
        return const BookMetadataActionsPreview();
      case 'Podcast header':
        return podcastHeaderActionsPreview();
      case 'Podcast episode controls':
        return const PodcastEpisodeControlsPreview();
      case 'Podcast filter controls':
        return const PodcastEpisodeFiltersPreview();
      case 'Library playback actions':
        return prominentLibraryPlaybackActionsPreview();
      case 'Library sorting':
        return librarySortSheetPreview();
      case 'Library filters':
        return libraryFilterSheetPreview();
      case 'Collections & playlists':
        return const ManagedListDetailPreview();
      case 'Collections & playlists lists':
        return managedListLandingHeaderPreview();
      case 'Library entities':
        return const LibraryEntityCardsPreview();
      case 'Lists & tables':
        return const ReusableListControlsPreview();
      case 'Listening sessions':
        return const ListeningSessionsPagePreview();
      default:
        return const InputStatesPreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = _mode == AppThemeMode.light ? Brightness.light : Brightness.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppThemeData(
        brightness: brightness,
        preset: AppThemePreset.yaabsa,
        customSeedColor: const Color(0xFF0F766E),
        useAmoledDark: _mode == AppThemeMode.amoled,
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('UI Lab: $_scenario', maxLines: 1, overflow: TextOverflow.ellipsis),
              actions: [
                YaabsaContextMenuButton<AppThemeMode>(
                  key: const ValueKey('ui-lab.theme-selector'),
                  tooltip: 'Theme',
                  initialValue: _mode,
                  icon: const Icon(Icons.palette_outlined),
                  onSelected: (value) => setState(() => _mode = value),
                  itemBuilder: (context) => [
                    for (final mode in [AppThemeMode.light, AppThemeMode.dark, AppThemeMode.amoled])
                      PopupMenuItem(value: mode, child: Text(mode.label)),
                  ],
                ),
                YaabsaContextMenuButton<String>(
                  key: const ValueKey('ui-lab.scenario-selector'),
                  tooltip: 'Scenario',
                  initialValue: _scenario,
                  icon: const Icon(Icons.dashboard_outlined),
                  constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height - kToolbarHeight - 24),
                  onSelected: (value) => setState(() => _scenario = value),
                  itemBuilder: (context) => [
                    for (final scenario in [
                      'Inputs',
                      'Library',
                      'Library grid',
                      'Loading covers',
                      'Search results',
                      'Shared play buttons',
                      'Book information actions',
                      'Podcast header',
                      'Podcast episode controls',
                      'Podcast filter controls',
                      'Library playback actions',
                      'Library sorting',
                      'Library filters',
                      'Collections & playlists',
                      'Collections & playlists lists',
                      'Library entities',
                      'Lists & tables',
                      'Listening sessions',
                      'Player',
                      'Mini player',
                      'Player collections',
                      'Player empty states',
                      'Player timer',
                      'Player speed',
                      'Player subtitles',
                      'Player casting',
                      'Player bookmarks',
                      'Player actions',
                      'Player metadata',
                      'Player transport buttons',
                      'Playback states',
                      'Player seek timeline',
                      'Player horizontal volume',
                      'Player vertical volume',
                      'Shared side actions',
                      'Series and narrator sort headers',
                      'Shared buttons',
                      'Prominent library playback',
                      'Player layout',
                      'Player component settings',
                      'Settings',
                      'Administration users',
                      'Administration access',
                      'Reader annotations',
                      'Statistics',
                      'Statistics states',
                      'Statistics compact',
                      'Statistics loading',
                      'Statistics without activity',
                      'Statistics achievements',
                      'Statistics advanced',
                      'Statistics year in review',
                      'Statistics sessions',
                      'Statistics totals',
                      'Statistics panels',
                      'Statistics metrics',
                      'Statistics 7 day chart',
                      'Statistics year chart',
                      'Statistics recent activity map',
                      'Statistics year activity map',
                      'Statistics ranked listening',
                      'Statistics empty states',
                      'Statistics messages',
                      'Statistics surface cards',
                      'Upload workspace',
                      'Add book files',
                      'Add book files queue',
                      'Upload controls',
                      'Upload drop zone',
                      'Upload metadata',
                      'Upload item',
                      'Upload path conflicts',
                      'Upload advanced options',
                      'Dialogs',
                    ])
                      PopupMenuItem(value: scenario, child: Text(scenario)),
                  ],
                ),
              ],
            ),
            body: Builder(builder: (context) => _buildScenario(context)),
          );
        },
      ),
    );
  }
}
