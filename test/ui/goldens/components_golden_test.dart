import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/ui/previews/library_previews.dart';
import 'package:yaabsa/ui/previews/library_grid_preview.dart';
import 'package:yaabsa/ui/previews/library_management_previews.dart';
import 'package:yaabsa/ui/previews/player_previews.dart';
import 'package:yaabsa/ui/previews/admin_previews.dart';
import 'package:yaabsa/ui/previews/statistics_previews.dart';
import 'package:yaabsa/ui/previews/settings_previews.dart';
import 'package:yaabsa/ui/previews/upload_previews.dart';
import 'package:yaabsa/ui/previews/input_previews.dart';
import 'package:yaabsa/ui/previews/list_controls_preview.dart';
import 'package:yaabsa/ui/previews/dialog_previews.dart';
import 'package:yaabsa/ui/previews/media_previews.dart';
import 'package:yaabsa/ui/previews/mini_player_previews.dart';
import 'package:yaabsa/ui/previews/reader_previews.dart';
import 'package:yaabsa/ui/previews/wear_previews.dart';
import 'package:yaabsa/ui/theme/wear_theme.dart';
import 'package:yaabsa/components/app/item/item_more_actions_button.dart';
import 'package:yaabsa/components/app/item/set_library_item_progress_dialog.dart';
import 'package:yaabsa/features/library/widgets/library_item_card.dart';
import 'package:yaabsa/ui/components/inputs/styled_form_fields.dart';
import 'package:yaabsa/ui/components/menus/yaabsa_context_menu_button.dart';
import 'package:yaabsa/ui/previews/material_3_controls_preview.dart';
import 'package:yaabsa/ui/previews/preview_theme.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';

import 'load_sdk_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final MemoryImage coverArtwork;
  setUpAll(() async {
    await loadSdkFonts();
    final imageBytes = await File('assets/logo_blue_fill.png').readAsBytes();
    coverArtwork = MemoryImage(imageBytes);
  });
  final componentGoldens = <({String name, String fileName, Size size, Widget Function() build})>[
    (
      name: 'administration user table',
      fileName: 'admin_users_table',
      size: const Size(1280, 500),
      build: () => const AdminUsersTablePreview(),
    ),
    (
      name: 'administration access selector',
      fileName: 'admin_access_selector',
      size: const Size(520, 460),
      build: () => const AdminAccessSelectorPreview(),
    ),
    (
      name: 'reader annotation details',
      fileName: 'reader_annotation_details',
      size: const Size(520, 340),
      build: () => const ReaderAnnotationDetailsPreview(),
    ),
    (
      name: 'library grid',
      fileName: 'library_grid',
      size: const Size(720, 520),
      build: () => const LibraryGridLabPreview(),
    ),
    (
      name: 'search and dropdown presentation',
      fileName: 'search_dropdown',
      size: const Size(390, 380),
      build: () => const SearchAndSortPreview(),
    ),
    (
      name: 'set progress dialog',
      fileName: 'set_progress_dialog',
      size: const Size(480, 480),
      build: () => SetLibraryItemProgressDialog(
        initialProgress: 1,
        durationSeconds: 14340,
        initialStartedDate: DateTime(2026, 10, 16),
        initialFinishedDate: DateTime(2026, 10, 17),
        onCancel: _ignoreDialogAction,
        onSave: _ignoreProgressAction,
      ),
    ),
    (
      name: 'listening sessions empty page on phone',
      fileName: 'listening_sessions_empty_phone',
      size: const Size(520, 520),
      build: listeningSessionsEmptyPreview,
    ),
    (
      name: 'listening sessions populated page on desktop',
      fileName: 'listening_sessions_populated_desktop',
      size: const Size(1280, 620),
      build: listeningSessionsPopulatedPreview,
    ),
    (
      name: 'library sort controls',
      fileName: 'library_sort_controls',
      size: const Size(390, 844),
      build: librarySortSheetPreview,
    ),
    (
      name: 'library filter controls',
      fileName: 'library_filter_controls',
      size: const Size(390, 844),
      build: libraryFilterSheetPreview,
    ),
    (
      name: 'collection detail on phone',
      fileName: 'collection_detail_phone',
      size: const Size(390, 844),
      build: () => const ManagedListDetailPreview(),
    ),
    (
      name: 'playlist detail on desktop',
      fileName: 'playlist_detail_desktop',
      size: const Size(1280, 800),
      build: () => const ManagedListDetailPreview(),
    ),
    (
      name: 'collection and playlist headers on phone',
      fileName: 'managed_list_headers_phone',
      size: const Size(390, 320),
      build: managedListLandingHeaderPreview,
    ),
    (
      name: 'collection and playlist create actions at tablet width',
      fileName: 'managed_list_headers_breakpoint',
      size: const Size(512, 320),
      build: managedListLandingHeaderPreview,
    ),
    (
      name: 'shared cover image states',
      fileName: 'cover_images',
      size: const Size(520, 300),
      build: () => CoverImagesPreview(artwork: coverArtwork),
    ),
    (
      name: 'input variants and states',
      fileName: 'input_variants',
      size: const Size(640, 1000),
      build: () => const InputStatesPreview(),
    ),
    (
      name: 'Material 3 Expressive controls',
      fileName: 'material_3_controls',
      size: const Size(640, 520),
      build: () => const Material3ExpressiveControlsPreview(),
    ),
    (
      name: 'playback button states',
      fileName: 'playback_states',
      size: const Size(390, 220),
      build: playbackStatesPreview,
    ),
    (
      name: 'podcast header actions',
      fileName: 'podcast_header_actions',
      size: const Size(1120, 340),
      build: podcastHeaderActionsPreview,
    ),
    (
      name: 'shared media play buttons',
      fileName: 'shared_media_play_buttons',
      size: const Size(560, 200),
      build: sharedMediaPlayButtonsPreview,
    ),
    (
      name: 'series and narrator sort headers on phone',
      fileName: 'sort_header_controls_phone',
      size: const Size(390, 260),
      build: sortHeaderControlsPreview,
    ),
    (
      name: 'series and narrator sort headers on desktop',
      fileName: 'sort_header_controls_desktop',
      size: const Size(1280, 260),
      build: sortHeaderControlsPreview,
    ),
    (
      name: 'podcast episode filter controls at 750 pixels',
      fileName: 'podcast_episode_filters_medium',
      size: const Size(750, 200),
      build: podcastEpisodeFiltersPreview,
    ),
    (
      name: 'book metadata and file path actions',
      fileName: 'book_metadata_actions',
      size: const Size(640, 620),
      build: bookMetadataActionsPreview,
    ),
    (
      name: 'podcast header and episode controls',
      fileName: 'podcast_episode_controls',
      size: const Size(1280, 960),
      build: podcastEpisodeControlsPreview,
    ),
    (
      name: 'podcast episode controls at medium width',
      fileName: 'podcast_episode_controls_medium',
      size: const Size(750, 520),
      build: podcastEpisodeControlsPreview,
    ),
    (
      name: 'podcast episode controls on phone',
      fileName: 'podcast_episode_controls_phone',
      size: const Size(390, 844),
      build: podcastEpisodeControlsPreview,
    ),
    (
      name: 'mini player compact presentation',
      fileName: 'mini_player_compact',
      size: const Size(390, 180),
      build: () => const MiniPlayerPresentationPreview(compact: true),
    ),
    (
      name: 'mini player desktop presentation',
      fileName: 'mini_player_desktop',
      size: const Size(980, 180),
      build: () => const MiniPlayerPresentationPreview(compact: false),
    ),
    (
      name: 'seek timeline and markers',
      fileName: 'seek_timeline',
      size: const Size(720, 260),
      build: () => const Padding(padding: EdgeInsets.all(20), child: SeekTimelinePreview()),
    ),
    (
      name: 'horizontal volume control',
      fileName: 'volume_horizontal',
      size: const Size(640, 220),
      build: () => const VolumeSliderCardPreview(axis: Axis.horizontal),
    ),
    (
      name: 'vertical volume control',
      fileName: 'volume_vertical',
      size: const Size(320, 300),
      build: () => const VolumeSliderCardPreview(axis: Axis.vertical),
    ),
    (
      name: 'statistics metrics',
      fileName: 'statistics_metrics',
      size: const Size(960, 460),
      build: () => const StatisticsMetricsPreview(),
    ),
    (
      name: 'statistics seven day chart',
      fileName: 'statistics_chart_seven_days',
      size: const Size(960, 520),
      build: () => const StatisticsRangeChartPreview(initialRange: 7),
    ),
    (
      name: 'statistics one year chart',
      fileName: 'statistics_chart_year',
      size: const Size(960, 520),
      build: () => const StatisticsRangeChartPreview(initialRange: 365),
    ),
    (
      name: 'statistics monthly activity map',
      fileName: 'statistics_heatmap_recent',
      size: const Size(520, 1080),
      build: () => const StatisticsHeatmapPreview(days: 84),
    ),
    (
      name: 'statistics annual activity map',
      fileName: 'statistics_heatmap_year',
      size: const Size(960, 440),
      build: () => const StatisticsHeatmapPreview(days: 365),
    ),
    (
      name: 'statistics ranked list',
      fileName: 'statistics_ranked',
      size: const Size(720, 620),
      build: () => const StatisticsRankedPreview(),
    ),
    (
      name: 'empty statistics list',
      fileName: 'statistics_empty',
      size: const Size(560, 320),
      build: () => const StatisticsEmptyPreview(),
    ),
    (
      name: 'statistics feedback messages',
      fileName: 'statistics_messages',
      size: const Size(560, 520),
      build: () => const StatisticsMessagesPreview(),
    ),
    (
      name: 'statistics asynchronous error and retry states',
      fileName: 'statistics_async_errors',
      size: const Size(640, 900),
      build: () => const StatisticsAsyncErrorStatesPreview(),
    ),
    (
      name: 'settings controls',
      fileName: 'settings_controls',
      size: const Size(640, 680),
      build: () => const SettingsControlsPreview(),
    ),
    (
      name: 'reusable tables and lists',
      fileName: 'list_controls',
      size: const Size(960, 820),
      build: () => const ReusableListControlsPreview(),
    ),
    (
      name: 'player metadata presentation',
      fileName: 'player_metadata',
      size: const Size(720, 340),
      build: () => const PlayerMediaMetadataPreview(),
    ),
    (
      name: 'player action bar',
      fileName: 'player_action_bar',
      size: const Size(720, 180),
      build: () => const PlayerActionBarPreview(),
    ),
    (
      name: 'player queue and chapter items',
      fileName: 'player_collections',
      size: const Size(720, 720),
      build: () => const PlayerCollectionsPreview(),
    ),
    (
      name: 'player collection empty states',
      fileName: 'player_collection_empty',
      size: const Size(560, 500),
      build: () => const PlayerCollectionEmptyPreview(),
    ),
    (
      name: 'player bookmark states',
      fileName: 'player_bookmarks',
      size: const Size(640, 480),
      build: () => const PlayerBookmarksPreview(),
    ),
    (
      name: 'player transport buttons',
      fileName: 'player_transport_buttons',
      size: const Size(540, 180),
      build: () => const PlayerTransportButtonsPreview(),
    ),
    (
      name: 'sleep timer active and paused states',
      fileName: 'player_sleep_timer',
      size: const Size(560, 260),
      build: () => const SleepTimerStatesPreview(),
    ),
    (
      name: 'playback speed controls',
      fileName: 'player_speed_settings',
      size: const Size(560, 460),
      build: () => const PlaybackSpeedSettingsPreview(),
    ),
    (
      name: 'player subtitle presentation states',
      fileName: 'player_subtitles',
      size: const Size(720, 300),
      build: () => const PlayerSubtitlePreview(),
    ),
    (
      name: 'player casting controls',
      fileName: 'player_cast_controls',
      size: const Size(560, 220),
      build: () => const PlayerCastPreview(),
    ),
    (
      name: 'reusable surface cards',
      fileName: 'surface_cards',
      size: const Size(600, 420),
      build: () => const StatisticsSurfaceCardsPreview(),
    ),
    (
      name: 'statistics navigation and expandable panels',
      fileName: 'statistics_panel_controls',
      size: const Size(560, 220),
      build: () => const StatisticsPanelControlsPreview(),
    ),
    (
      name: 'compact upload queue controls',
      fileName: 'upload_controls_compact',
      size: const Size(390, 280),
      build: () => const UploadQueueActionsPreview(),
    ),
    (
      name: 'upload drop zone',
      fileName: 'upload_drop_zone',
      size: const Size(720, 260),
      build: () => const UploadDropZonePreview(),
    ),
    (
      name: 'upload workspace',
      fileName: 'upload_workspace',
      size: const Size(1086, 800),
      build: () => const UploadWorkspacePreview(),
    ),
    (
      name: 'upload path conflict dialog',
      fileName: 'upload_path_conflicts',
      size: const Size(640, 520),
      build: uploadPathConflictsPreview,
    ),
    (
      name: 'medium upload workspace',
      fileName: 'upload_workspace_medium',
      size: const Size(800, 800),
      build: () => const UploadWorkspacePreview(),
    ),
    (
      name: 'wide upload queue controls',
      fileName: 'upload_controls_wide',
      size: const Size(800, 220),
      build: () => const UploadQueueActionsPreview(),
    ),
    (
      name: 'compact upload bulk fields',
      fileName: 'upload_bulk_fields_compact',
      size: const Size(390, 420),
      build: () => const UploadBulkMetadataPreview(),
    ),
    (
      name: 'wide upload bulk fields',
      fileName: 'upload_bulk_fields_wide',
      size: const Size(800, 260),
      build: () => const UploadBulkMetadataPreview(),
    ),
    (
      name: 'compact upload item card',
      fileName: 'upload_item_compact',
      size: const Size(480, 720),
      build: () => const UploadItemCardPreview(compact: true),
    ),
    (
      name: 'narrow upload item card',
      fileName: 'upload_item_narrow',
      size: const Size(390, 720),
      build: () => const UploadItemCardPreview(compact: true),
    ),
    (
      name: 'upload item card at its responsive breakpoint',
      fileName: 'upload_item_breakpoint',
      size: const Size(504, 720),
      build: () => const UploadItemCardPreview(compact: true, maxWidth: 472),
    ),
    (
      name: 'wide upload item card',
      fileName: 'upload_item_wide',
      size: const Size(960, 620),
      build: () => const UploadItemCardPreview(compact: false),
    ),
    (
      name: 'compact upload advanced settings',
      fileName: 'upload_advanced_compact',
      size: const Size(640, 620),
      build: () => const UploadAdvancedOptionsPreview(),
    ),
    (
      name: 'stacked wide upload advanced settings',
      fileName: 'upload_advanced_stacked_wide',
      size: const Size(1000, 620),
      build: () => const UploadAdvancedOptionsPreview(),
    ),
    (
      name: 'wide upload advanced settings',
      fileName: 'upload_advanced_wide',
      size: const Size(1086, 520),
      build: () => const UploadAdvancedOptionsPreview(),
    ),
    (
      name: 'dialog confirmation actions',
      fileName: 'dialog_actions',
      size: const Size(640, 480),
      build: () => const DialogActionsPreview(),
    ),
    (
      name: 'destructive dialog actions',
      fileName: 'dialog_actions_destructive',
      size: const Size(640, 480),
      build: () => const DialogActionsPreview(destructive: true),
    ),
    (
      name: 'custom mobile player layout',
      fileName: 'player_layout_mobile',
      size: const Size(390, 844),
      build: () => const PlayerGridLayoutPreview(screenSize: PlayerLayoutScreenSize.mobile),
    ),
    (
      name: 'custom tablet player layout',
      fileName: 'player_layout_tablet',
      size: const Size(800, 1100),
      build: () => const PlayerGridLayoutPreview(screenSize: PlayerLayoutScreenSize.tablet),
    ),
    (
      name: 'custom desktop player layout',
      fileName: 'player_layout_desktop',
      size: const Size(1280, 800),
      build: () => const PlayerGridLayoutPreview(screenSize: PlayerLayoutScreenSize.desktop),
    ),
    (
      name: 'player component settings',
      fileName: 'player_component_settings',
      size: const Size(420, 720),
      build: () => const PlayerComponentSettingsPreview(),
    ),
    (
      name: 'advanced statistics dashboard',
      fileName: 'statistics_advanced_dashboard',
      size: const Size(960, 1400),
      build: () => const StatisticsAdvancedDashboardPreview(),
    ),
    (
      name: 'statistics achievements',
      fileName: 'statistics_achievements',
      size: const Size(960, 900),
      build: () => const StatisticsAchievementsPreview(),
    ),
    (
      name: 'year in review',
      fileName: 'statistics_year_rewind',
      size: const Size(960, 900),
      build: () => const StatisticsYearRewindPreview(),
    ),
    (
      name: 'statistics activity totals',
      fileName: 'statistics_activity_totals',
      size: const Size(720, 360),
      build: () => const StatisticsActivityTotalsPreview(),
    ),
    (
      name: 'statistics sessions and weekdays',
      fileName: 'statistics_sessions_weekdays',
      size: const Size(720, 1300),
      build: () => const StatisticsSessionsAndWeekdaysPreview(),
    ),
    (
      name: 'compact statistics dashboard',
      fileName: 'statistics_dashboard_compact',
      size: const Size(390, 1450),
      build: () => const StatisticsCompactDashboardPreview(),
    ),
    (
      name: 'statistics loading states',
      fileName: 'statistics_loading_states',
      size: const Size(720, 1080),
      build: () => const StatisticsLoadingStatesPreview(),
    ),
    (
      name: 'statistics without activity',
      fileName: 'statistics_no_activity',
      size: const Size(640, 1080),
      build: () => const StatisticsNoActivityPreview(),
    ),
  ];

  for (final appearance in ['light', 'dark', 'amoled']) {
    testWidgets('library presentation states $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(800, 620);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();
      await tester.pumpWidget(
        YaabsaPreviewApp(
          brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
          amoled: appearance == 'amoled',
          child: RepaintBoundary(
            key: boundary,
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Theme(
                  data: theme.copyWith(textTheme: theme.textTheme.apply(fontFamily: 'Roboto')),
                  child: Material(color: theme.scaffoldBackgroundColor, child: const LibraryCardsPreview()),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(find.byKey(boundary), matchesGoldenFile(_goldenBaselinePath('library_cards_$appearance.png')));
    });

    testWidgets('library entity row cards $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(640, 380);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();
      await tester.pumpWidget(
        YaabsaPreviewApp(
          brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
          amoled: appearance == 'amoled',
          child: RepaintBoundary(
            key: boundary,
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Theme(
                  data: theme.copyWith(textTheme: theme.textTheme.apply(fontFamily: 'Roboto')),
                  child: Material(color: theme.scaffoldBackgroundColor, child: const LibraryEntityCardsPreview()),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('library_entity_cards_$appearance.png')),
      );
    });

    testWidgets('player control states $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(720, 720);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();
      await tester.pumpWidget(
        YaabsaPreviewApp(
          brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
          amoled: appearance == 'amoled',
          child: RepaintBoundary(
            key: boundary,
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Theme(
                  data: theme.copyWith(textTheme: theme.textTheme.apply(fontFamily: 'Roboto')),
                  child: Material(color: theme.scaffoldBackgroundColor, child: const PlayerControlsPreview()),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('player_controls_$appearance.png')),
      );
    });

    testWidgets('statistics dashboard states $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(960, 1800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();
      await tester.pumpWidget(
        YaabsaPreviewApp(
          brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
          amoled: appearance == 'amoled',
          child: RepaintBoundary(
            key: boundary,
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Theme(
                  data: theme.copyWith(textTheme: theme.textTheme.apply(fontFamily: 'Roboto')),
                  child: Material(color: theme.scaffoldBackgroundColor, child: const StatisticsDashboardPreview()),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('statistics_dashboard_$appearance.png')),
      );
    });

    for (final componentGolden in componentGoldens) {
      testWidgets('${componentGolden.name} $appearance', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = componentGolden.size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final boundary = GlobalKey();
        await tester.pumpWidget(
          YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: RepaintBoundary(
              key: boundary,
              child: Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  return Theme(
                    data: theme.copyWith(textTheme: theme.textTheme.apply(fontFamily: 'Roboto')),
                    child: Material(color: theme.scaffoldBackgroundColor, child: componentGolden.build()),
                  );
                },
              ),
            ),
          ),
        );
        if (componentGolden.fileName == 'playback_states' ||
            componentGolden.fileName == 'settings_controls' ||
            componentGolden.fileName == 'player_bookmarks' ||
            componentGolden.fileName == 'player_collection_empty' ||
            componentGolden.fileName == 'statistics_loading_states' ||
            componentGolden.fileName == 'material_3_controls' ||
            componentGolden.fileName == 'shared_media_play_buttons' ||
            componentGolden.fileName.startsWith('podcast_episode_controls')) {
          await tester.pump(const Duration(milliseconds: 400));
        } else {
          if (componentGolden.fileName == 'cover_images') {
            await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
          }
          await tester.pumpAndSettle();
        }
        expect(tester.takeException(), isNull, reason: componentGolden.name);
        if (componentGolden.fileName == 'cover_images') {
          final rawImage = tester.widget<RawImage>(find.byType(RawImage));
          expect(rawImage.image, isNotNull, reason: 'The local cover fixture must decode in the golden.');
        }
        await expectLater(
          find.byKey(boundary),
          matchesGoldenFile(_goldenBaselinePath('${componentGolden.fileName}_$appearance.png')),
        );
      });
    }

    testWidgets('Material 3 Expressive dropdown open $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(640, 520);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Material(
                  color: theme.scaffoldBackgroundColor,
                  child: const Material3ExpressiveControlsPreview(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      final dropdownField = find.byType(M3EDropdownMenu<String>);
      await tester.tapAt(tester.getCenter(dropdownField));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Author'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('m3e_dropdown_open_$appearance.png')),
      );
    });

    testWidgets('Material 3 Expressive context menu open $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(640, 520);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Material(
                  color: theme.scaffoldBackgroundColor,
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: YaabsaContextMenuButton<String>(
                        tooltip: 'More actions',
                        icon: const Icon(Icons.more_vert_rounded),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      final contextMenuTrigger = find.byTooltip('More actions');
      await tester.ensureVisible(contextMenuTrigger);
      await tester.tap(contextMenuTrigger);
      await tester.pumpAndSettle();
      expect(find.text('Edit'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('m3e_context_menu_open_$appearance.png')),
      );
    });

    testWidgets('desktop library item context menu open $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: const LibraryItemActionsDesktopPreview(),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byTooltip('More actions'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Progress'), findsOneWidget);
      expect(find.text('Delete Audiobook'), findsOneWidget);
      expect(find.text('Play History'), findsOneWidget);
      final menu = tester.widget<M3EMenuPopup<ItemMoreAction>>(find.byType(M3EMenuPopup<ItemMoreAction>));
      expect(menu.variant, M3EMenuVariant.baseline);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('library_item_menu_open_$appearance.png')),
      );
    });

    testWidgets('desktop library item progress submenu open $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: const LibraryItemActionsDesktopPreview(),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byTooltip('More actions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Progress'));
      await tester.pumpAndSettle();

      expect(find.text('Mark As Finished'), findsOneWidget);
      expect(find.text('Mark As Unfinished'), findsOneWidget);
      expect(find.text('Set progress'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('library_item_menu_progress_submenu_open_$appearance.png')),
      );
    });

    for (final state in [
      (name: 'unstarted', showFinished: true, showUnfinished: false, expected: 'Mark As Finished'),
      (name: 'finished', showFinished: false, showUnfinished: true, expected: 'Mark As Unfinished'),
    ]) {
      testWidgets('desktop library item progress submenu ${state.name} state $appearance', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(1280, 800);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final boundary = GlobalKey();

        await tester.pumpWidget(
          RepaintBoundary(
            key: boundary,
            child: YaabsaPreviewApp(
              brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
              amoled: appearance == 'amoled',
              child: LibraryItemActionsDesktopPreview(
                showMarkAsFinished: state.showFinished,
                showMarkAsUnfinished: state.showUnfinished,
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.tap(find.byTooltip('More actions'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Progress'));
        await tester.pumpAndSettle();

        expect(find.text(state.expected), findsOneWidget);
        expect(
          find.text(state.expected == 'Mark As Finished' ? 'Mark As Unfinished' : 'Mark As Finished'),
          findsNothing,
        );
        expect(find.text('Set progress'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(boundary),
          matchesGoldenFile(_goldenBaselinePath('library_item_menu_progress_${state.name}_$appearance.png')),
        );
      });
    }

    testWidgets('desktop library card right-click context menu open $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(640, 520);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: const LibraryItemContextMenuDesktopPreview(),
          ),
        ),
      );
      await tester.pump();
      final contextPosition = tester.getCenter(find.byType(LibraryItemCard));
      final gesture = await tester.startGesture(
        contextPosition,
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryMouseButton,
      );
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.byType(M3EMenuPopup<ItemMoreAction>), findsOneWidget);
      expect(find.text('Progress'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('library_item_right_click_menu_open_$appearance.png')),
      );
    });

    testWidgets('desktop library item edit submenu open $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: const LibraryItemActionsDesktopPreview(),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byTooltip('More actions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      expect(find.text('Edit item'), findsOneWidget);
      expect(find.text('Quick Match'), findsOneWidget);
      expect(find.text('Manual Match'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('library_item_menu_edit_submenu_open_$appearance.png')),
      );
    });

    testWidgets('desktop library item add-to submenu open $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundary = GlobalKey();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundary,
          child: YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: const LibraryItemActionsDesktopPreview(),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byTooltip('More actions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to'));
      await tester.pumpAndSettle();

      expect(find.text('Add To Playlist'), findsOneWidget);
      expect(find.text('Add To Collection'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('library_item_menu_add_to_submenu_open_$appearance.png')),
      );
    });
  }

  for (final appearance in ['light', 'dark', 'amoled']) {
    testWidgets('book metadata and media path actions compact phone enlarged text $appearance', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 640);
      tester.platformDispatcher.textScaleFactorTestValue = 1.8;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      final boundary = GlobalKey();
      await tester.pumpWidget(
        YaabsaPreviewApp(
          brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
          amoled: appearance == 'amoled',
          child: RepaintBoundary(
            key: boundary,
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Theme(
                  data: theme.copyWith(textTheme: theme.textTheme.apply(fontFamily: 'Roboto')),
                  child: Material(color: theme.scaffoldBackgroundColor, child: const BookMetadataActionsPreview()),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(boundary),
        matchesGoldenFile(_goldenBaselinePath('book_metadata_actions_phone_accessibility_$appearance.png')),
      );
    });
  }

  for (final appearance in ['light', 'dark', 'amoled']) {
    for (final layout in [(name: 'compact', size: const Size(640, 900)), (name: 'wide', size: const Size(1100, 560))]) {
      testWidgets('upload advanced options ${layout.name} enlarged text $appearance', (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = layout.size;
        tester.platformDispatcher.textScaleFactorTestValue = 1.8;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final boundary = GlobalKey();
        await tester.pumpWidget(
          YaabsaPreviewApp(
            brightness: appearance == 'light' ? Brightness.light : Brightness.dark,
            amoled: appearance == 'amoled',
            child: RepaintBoundary(
              key: boundary,
              child: Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  return Theme(
                    data: theme.copyWith(textTheme: theme.textTheme.apply(fontFamily: 'Roboto')),
                    child: Material(color: theme.scaffoldBackgroundColor, child: const UploadAdvancedOptionsPreview()),
                  );
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        if (layout.name == 'compact') {
          expect(find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')), findsNothing);
          expect(find.byKey(const ValueKey<String>('uploadBulkFieldStacked')), findsNWidgets(2));
        } else {
          expect(find.byKey(const ValueKey<String>('uploadAdvancedOptionsSideBySide')), findsOneWidget);
          expect(find.byKey(const ValueKey<String>('uploadBulkFieldInline')), findsNWidgets(2));

          final fieldRect = tester.getRect(find.byType(StyledTextField).first);
          final buttonRect = tester.getRect(find.widgetWithText(FilledButton, 'Apply author'));
          expect(buttonRect.top, fieldRect.top);
        }

        expect(tester.takeException(), isNull);
        await expectLater(
          find.byKey(boundary),
          matchesGoldenFile(_goldenBaselinePath('upload_advanced_${layout.name}_accessibility_$appearance.png')),
        );
      });
    }
  }

  final wearGoldens = <({String name, String fileName, String shape, Widget Function() build})>[
    (
      name: 'wear browse curved round',
      fileName: 'wear_browse_curved_amoled',
      shape: 'round',
      build: () => const WearBrowsePreview(flatScrolling: false),
    ),
    (
      name: 'wear browse flat round',
      fileName: 'wear_browse_flat_amoled',
      shape: 'round',
      build: () => const WearBrowsePreview(flatScrolling: true),
    ),
    (
      name: 'wear browse square',
      fileName: 'wear_browse_square_amoled',
      shape: 'square',
      build: () => const WearBrowsePreview(flatScrolling: false),
    ),
    (
      name: 'wear cover grid',
      fileName: 'wear_cover_grid_amoled',
      shape: 'round',
      build: () => const WearCoverGridPreview(),
    ),
    (
      name: 'wear player controls and scalloped play button',
      fileName: 'wear_player_controls_amoled',
      shape: 'round',
      build: () => const WearPlayerControlsPreview(),
    ),
    (
      name: 'wear volume control',
      fileName: 'wear_volume_amoled',
      shape: 'round',
      build: () => const WearVolumePreview(),
    ),
    (name: 'wear settings', fileName: 'wear_settings_amoled', shape: 'round', build: () => const WearSettingsPreview()),
    (
      name: 'wear confirmation',
      fileName: 'wear_confirmation_amoled',
      shape: 'round',
      build: () => const WearConfirmationPreview(),
    ),
    (
      name: 'wear ambient with metadata',
      fileName: 'wear_ambient_metadata_amoled',
      shape: 'round',
      build: () => const WearAmbientPreview(showMetadata: true),
    ),
    (
      name: 'wear ambient clock only',
      fileName: 'wear_ambient_clock_amoled',
      shape: 'round',
      build: () => const WearAmbientPreview(showMetadata: false),
    ),
    (
      name: 'wear account details',
      fileName: 'wear_account_amoled',
      shape: 'round',
      build: () => const WearAccountPreview(),
    ),
  ];

  for (final golden in wearGoldens) {
    testWidgets('${golden.name} amoled', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(227, 227);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const wearChannel = MethodChannel('wear');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(wearChannel, (call) async {
        if (call.method == 'getShape') {
          return golden.shape;
        }
        if (call.method == 'isAmbient') {
          return false;
        }
        return null;
      });
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(wearChannel, null);
      });

      final boundary = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildWearTheme(ThemeData.dark(useMaterial3: true)),
          home: RepaintBoundary(
            key: boundary,
            child: Builder(
              builder: (context) {
                final theme = Theme.of(context);
                return Theme(
                  data: theme.copyWith(textTheme: theme.textTheme.apply(fontFamily: 'Roboto')),
                  child: golden.build(),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      await expectLater(find.byKey(boundary), matchesGoldenFile(_goldenBaselinePath('${golden.fileName}.png')));
    });
  }
}

String _goldenBaselinePath(String fileName) {
  final configuredDirectory = Platform.environment['YAABSA_GOLDEN_DIR'];
  if (configuredDirectory != null && configuredDirectory.isNotEmpty) {
    return '$configuredDirectory/$fileName';
  }

  return 'baselines/$fileName';
}

void _ignoreDialogAction() {}

void _ignoreProgressAction(SetLibraryItemProgressSelection _) {}
