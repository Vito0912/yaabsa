import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/components/app/item/library_item_view_components.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar_row.dart';
import 'package:yaabsa/components/player/common/seek_bar_slider.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';
import 'package:yaabsa/components/player/common/volume_slider_panel.dart';
import 'package:yaabsa/features/player/widgets/player_media_info_presentation.dart';
import 'package:yaabsa/features/player/widgets/player_cast_presentation.dart';
import 'package:yaabsa/features/player/widgets/player_collection_empty_presentation.dart';
import 'package:yaabsa/features/player/widgets/player_chapter_item_presentation.dart';
import 'package:yaabsa/features/player/widgets/player_queue_item_presentation.dart';
import 'package:yaabsa/features/player/widgets/playback_speed_sheet.dart';
import 'package:yaabsa/features/player/widgets/player_subtitle_presentation.dart';
import 'package:yaabsa/features/player/widgets/sleep_timer_active_presentation.dart';
import 'package:yaabsa/features/player/widgets/playback_button.dart';
import 'package:yaabsa/screens/player/components/player_cover_component.dart';
import 'package:yaabsa/screens/player/components/player_action_bar.dart';
import 'package:yaabsa/screens/player/components/bookmark_card.dart';
import 'package:yaabsa/screens/player/layout/player_component_settings_sheet.dart';
import 'package:yaabsa/screens/player/layout/player_grid_canvas.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/ui/components/settings/settings_switch_presentation.dart';
import 'package:yaabsa/ui/components/buttons/action_icon_button.dart';
import 'package:yaabsa/ui/components/buttons/playback_action_button.dart';
import 'package:yaabsa/util/handler/sleep_timer_data.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/subtitles/subtitle_parser.dart';

import 'preview_theme.dart';
import 'preview_fixtures.dart';

@Preview(name: 'Player media metadata / light', size: Size(720, 340), wrapper: yaabsaPreviewLight)
@Preview(name: 'Player media metadata / dark', size: Size(720, 340), wrapper: yaabsaPreviewDark)
@Preview(name: 'Player media metadata / AMOLED', size: Size(720, 340), wrapper: yaabsaPreviewAmoled)
Widget playerMediaMetadataPreview() => const PlayerMediaMetadataPreview();

@Preview(name: 'Player action bar / light', size: Size(720, 180), wrapper: yaabsaPreviewLight)
@Preview(name: 'Player action bar / dark', size: Size(720, 180), wrapper: yaabsaPreviewDark)
@Preview(name: 'Player action bar / AMOLED', size: Size(720, 180), wrapper: yaabsaPreviewAmoled)
Widget playerActionBarPreview() => const PlayerActionBarPreview();

@Preview(name: 'Player queue and chapters / light', size: Size(720, 720), wrapper: yaabsaPreviewLight)
@Preview(name: 'Player queue and chapters / dark', size: Size(720, 720), wrapper: yaabsaPreviewDark)
@Preview(name: 'Player queue and chapters / AMOLED', size: Size(720, 720), wrapper: yaabsaPreviewAmoled)
Widget playerCollectionsPreview() => const PlayerCollectionsPreview();

@Preview(name: 'Player empty states / light', size: Size(560, 500), wrapper: yaabsaPreviewLight)
@Preview(name: 'Player empty states / dark', size: Size(560, 500), wrapper: yaabsaPreviewDark)
@Preview(name: 'Player empty states / AMOLED', size: Size(560, 500), wrapper: yaabsaPreviewAmoled)
Widget playerCollectionEmptyPreview() => const PlayerCollectionEmptyPreview();

@Preview(name: 'Player bookmarks / light', size: Size(640, 480), wrapper: yaabsaPreviewLight)
@Preview(name: 'Player bookmarks / dark', size: Size(640, 480), wrapper: yaabsaPreviewDark)
@Preview(name: 'Player bookmarks / AMOLED', size: Size(640, 480), wrapper: yaabsaPreviewAmoled)
Widget playerBookmarksPreview() => const PlayerBookmarksPreview();

@Preview(name: 'Player transport buttons / light', size: Size(540, 180), wrapper: yaabsaPreviewLight)
@Preview(name: 'Player transport buttons / dark', size: Size(540, 180), wrapper: yaabsaPreviewDark)
@Preview(name: 'Player transport buttons / AMOLED', size: Size(540, 180), wrapper: yaabsaPreviewAmoled)
Widget playerTransportButtonsPreview() => const PlayerTransportButtonsPreview();

@Preview(name: 'Sleep timer states / light', size: Size(560, 260), wrapper: yaabsaPreviewLight)
@Preview(name: 'Sleep timer states / dark', size: Size(560, 260), wrapper: yaabsaPreviewDark)
@Preview(name: 'Sleep timer states / AMOLED', size: Size(560, 260), wrapper: yaabsaPreviewAmoled)
Widget sleepTimerStatesPreview() => const SleepTimerStatesPreview();

@Preview(name: 'Playback speed settings / light', size: Size(560, 420), wrapper: yaabsaPreviewLight)
@Preview(name: 'Playback speed settings / dark', size: Size(560, 420), wrapper: yaabsaPreviewDark)
@Preview(name: 'Playback speed settings / AMOLED', size: Size(560, 420), wrapper: yaabsaPreviewAmoled)
Widget playbackSpeedSettingsPreview() => const PlaybackSpeedSettingsPreview();

@Preview(name: 'Subtitle presentation / light', size: Size(720, 260), wrapper: yaabsaPreviewLight)
@Preview(name: 'Subtitle presentation / dark', size: Size(720, 260), wrapper: yaabsaPreviewDark)
@Preview(name: 'Subtitle presentation / AMOLED', size: Size(720, 260), wrapper: yaabsaPreviewAmoled)
Widget playerSubtitlePreview() => const PlayerSubtitlePreview();

@Preview(name: 'Casting controls / light', size: Size(560, 220), wrapper: yaabsaPreviewLight)
@Preview(name: 'Casting controls / dark', size: Size(560, 220), wrapper: yaabsaPreviewDark)
@Preview(name: 'Casting controls / AMOLED', size: Size(560, 220), wrapper: yaabsaPreviewAmoled)
Widget playerCastPreview() => const PlayerCastPreview();

@Preview(name: 'Custom player layout / mobile / light', size: Size(390, 844), wrapper: yaabsaPreviewLight)
@Preview(name: 'Custom player layout / mobile / dark', size: Size(390, 844), wrapper: yaabsaPreviewDark)
@Preview(name: 'Custom player layout / mobile / AMOLED', size: Size(390, 844), wrapper: yaabsaPreviewAmoled)
Widget playerGridMobilePreview() => const PlayerGridLayoutPreview(screenSize: PlayerLayoutScreenSize.mobile);

@Preview(name: 'Custom player layout / tablet / light', size: Size(800, 1100), wrapper: yaabsaPreviewLight)
@Preview(name: 'Custom player layout / tablet / dark', size: Size(800, 1100), wrapper: yaabsaPreviewDark)
@Preview(name: 'Custom player layout / tablet / AMOLED', size: Size(800, 1100), wrapper: yaabsaPreviewAmoled)
Widget playerGridTabletPreview() => const PlayerGridLayoutPreview(screenSize: PlayerLayoutScreenSize.tablet);

@Preview(name: 'Custom player layout / desktop / light', size: Size(1280, 800), wrapper: yaabsaPreviewLight)
@Preview(name: 'Custom player layout / desktop / dark', size: Size(1280, 800), wrapper: yaabsaPreviewDark)
@Preview(name: 'Custom player layout / desktop / AMOLED', size: Size(1280, 800), wrapper: yaabsaPreviewAmoled)
Widget playerGridDesktopPreview() => const PlayerGridLayoutPreview(screenSize: PlayerLayoutScreenSize.desktop);

@Preview(name: 'Player component settings / light', size: Size(420, 720), wrapper: yaabsaPreviewLight)
@Preview(name: 'Player component settings / dark', size: Size(420, 720), wrapper: yaabsaPreviewDark)
@Preview(name: 'Player component settings / AMOLED', size: Size(420, 720), wrapper: yaabsaPreviewAmoled)
Widget playerComponentSettingsPreview() => const PlayerComponentSettingsPreview();

@Preview(name: 'Playback states', size: Size(390, 180), wrapper: yaabsaPreviewLight)
@Preview(name: 'Playback states / dark', size: Size(390, 180), wrapper: yaabsaPreviewDark)
@Preview(name: 'Playback states / AMOLED', size: Size(390, 180), wrapper: yaabsaPreviewAmoled)
Widget playbackStatesPreview() {
  return Center(
    child: Wrap(
      spacing: 16,
      children: [
        PlaybackButton(isPlaying: false, isLoading: false, onPressed: () {}),
        PlaybackButton(isPlaying: true, isLoading: false, onPressed: () {}, prominent: true),
        const PlaybackButton(isPlaying: false, isLoading: true, onPressed: null),
        const PlaybackButton(isPlaying: false, isLoading: false, onPressed: null),
      ],
    ),
  );
}

@Preview(name: 'Shared side actions / light', size: Size(420, 100), wrapper: yaabsaPreviewLight)
@Preview(name: 'Shared side actions / dark', size: Size(420, 100), wrapper: yaabsaPreviewDark)
@Preview(name: 'Shared side actions / AMOLED', size: Size(420, 100), wrapper: yaabsaPreviewAmoled)
Widget sharedSideActionsPreview() {
  return const Center(
    child: Wrap(
      spacing: 12,
      children: [
        YaabsaActionIconButton(
          icon: Icons.download_rounded,
          tooltip: 'Download library item',
          onPressed: null,
          variant: YaabsaActionButtonVariant.filledTonal,
          shape: YaabsaActionButtonShape.rounded,
        ),
        YaabsaActionIconButton(
          icon: Icons.download_rounded,
          tooltip: 'Download podcast episode',
          onPressed: null,
          variant: YaabsaActionButtonVariant.filledTonal,
          shape: YaabsaActionButtonShape.rounded,
        ),
        YaabsaActionIconButton(
          icon: Icons.skip_previous_rounded,
          tooltip: 'Previous',
          onPressed: null,
          compact: false,
          buttonSize: 48,
        ),
      ],
    ),
  );
}

@Preview(name: 'Prominent library playback actions / light', size: Size(720, 160), wrapper: yaabsaPreviewLight)
@Preview(name: 'Prominent library playback actions / dark', size: Size(720, 160), wrapper: yaabsaPreviewDark)
@Preview(name: 'Prominent library playback actions / AMOLED', size: Size(720, 160), wrapper: yaabsaPreviewAmoled)
Widget prominentLibraryPlaybackActionsPreview() {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        buildItemActionButtons(
          hasAudio: true,
          hasBook: false,
          canDownload: false,
          downloadItemId: 'preview-book',
          isDownloaded: false,
          isQueued: false,
          isCurrentItem: false,
          isPlayingCurrentItem: false,
          isLoadingCurrentItem: false,
          prominentPlayback: true,
          playbackLabel: 'Play',
          onPlay: _ignorePlaybackAction,
          onPause: _ignorePlaybackAction,
          onQueueToggle: _ignorePlaybackAction,
          onRead: _ignorePlaybackAction,
          onDownload: _ignorePlaybackAction,
          onDeleteDownload: _ignorePlaybackAction,
        ),
        const YaabsaPlaybackActionButton(
          label: 'Pause',
          isPlaying: true,
          isLoading: false,
          onPressed: _ignorePlaybackAction,
        ),
        const YaabsaPlaybackActionButton(label: 'Loading', isPlaying: false, isLoading: true, onPressed: null),
      ],
    ),
  );
}

void _ignorePlaybackAction() {}

@Preview(name: 'Seek timeline / light', size: Size(720, 240), wrapper: yaabsaPreviewLight)
@Preview(name: 'Seek timeline / dark', size: Size(720, 240), wrapper: yaabsaPreviewDark)
@Preview(name: 'Seek timeline / AMOLED', size: Size(720, 240), wrapper: yaabsaPreviewAmoled)
Widget seekTimelinePreview() => const Padding(padding: EdgeInsets.all(20), child: SeekTimelinePreview());

@Preview(name: 'Volume slider / horizontal / light', size: Size(640, 220), wrapper: yaabsaPreviewLight)
@Preview(name: 'Volume slider / horizontal / dark', size: Size(640, 220), wrapper: yaabsaPreviewDark)
@Preview(name: 'Volume slider / horizontal / AMOLED', size: Size(640, 220), wrapper: yaabsaPreviewAmoled)
Widget horizontalVolumeSliderPreview() => const VolumeSliderCardPreview(axis: Axis.horizontal);

@Preview(name: 'Volume slider / vertical / light', size: Size(320, 300), wrapper: yaabsaPreviewLight)
@Preview(name: 'Volume slider / vertical / dark', size: Size(320, 300), wrapper: yaabsaPreviewDark)
@Preview(name: 'Volume slider / vertical / AMOLED', size: Size(320, 300), wrapper: yaabsaPreviewAmoled)
Widget verticalVolumeSliderPreview() => const VolumeSliderCardPreview(axis: Axis.vertical);

@Preview(name: 'Player controls / light', size: Size(720, 720), wrapper: yaabsaPreviewLight)
@Preview(name: 'Player controls / dark', size: Size(720, 720), wrapper: yaabsaPreviewDark)
@Preview(name: 'Player controls / AMOLED', size: Size(720, 720), wrapper: yaabsaPreviewAmoled)
Widget playerControlsPreview() => const PlayerControlsPreview();

class PlayerControlsPreview extends StatelessWidget {
  const PlayerControlsPreview({
    super.key,
    this.isPlaying = true,
    this.isLoading = false,
    this.onPlaybackChanged,
    this.onLoadingChanged,
    this.showSimulationControls = false,
  });

  final bool isPlaying;
  final bool isLoading;
  final ValueChanged<bool>? onPlaybackChanged;
  final ValueChanged<bool>? onLoadingChanged;
  final bool showSimulationControls;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Playback', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Center(
          child: Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SkipButtonPresentation(previous: true, onPressed: null),
              const JumpIcon(rewind: true, durationSeconds: 30, size: 36),
              PlaybackButton(
                isPlaying: isPlaying,
                isLoading: isLoading,
                onPressed: () => onPlaybackChanged?.call(!isPlaying),
                prominent: true,
              ),
              const JumpIcon(rewind: false, durationSeconds: 30, size: 36),
              const SkipButtonPresentation(previous: false, onPressed: null),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SeekTimelinePreview(),
        const SizedBox(height: 24),
        const VolumeSliderPresentation(axis: Axis.horizontal, volume: 1.3, maxVolume: 2.0, onChanged: _ignoreVolume),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Text('Volume control in a custom player column')),
            VolumeSliderPresentation(axis: Axis.vertical, volume: 0.7, maxVolume: 2.0, onChanged: _ignoreVolume),
          ],
        ),
        const Text('Current position: 57:18'),
        if (showSimulationControls)
          SettingsSwitchPresentation(label: 'Simulate buffering', value: isLoading, onChanged: onLoadingChanged),
      ],
    );
  }
}

class PlayerMediaMetadataPreview extends StatelessWidget {
  const PlayerMediaMetadataPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        spacing: 32,
        runSpacing: 24,
        children: [
          SizedBox(
            width: 300,
            child: PlayerMediaInfoPresentation(
              title: 'The Distant Shore',
              author: 'Mira Ellery',
              narrator: 'Read by Elena Mar',
              series: 'The Tidemark Stories',
              seriesPosition: '2',
              textAlignMode: PlayerMetadataTextAlign.start,
              fontScale: 1,
            ),
          ),
          SizedBox(
            width: 300,
            child: PlayerMediaInfoPresentation(
              title: 'Winter at Low Tide: A Story of Memory and Returning',
              author: 'Jonas Vale',
              series: 'Harbor Books',
              seriesPosition: '5',
              showNarrator: false,
              textAlignMode: PlayerMetadataTextAlign.center,
              fontScale: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerActionBarPreview extends StatelessWidget {
  const PlayerActionBarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = defaultFullPlayerActions;
    final overrides = <PlayerActionType, VoidCallback>{for (final action in actions) action: () {}};

    return Padding(
      padding: const EdgeInsets.all(16),
      child: PlayerActionBar(actions: actions, hasChapters: true, showLabels: true, actionOverrides: overrides),
    );
  }
}

class PlayerCollectionsPreview extends StatelessWidget {
  const PlayerCollectionsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Chapters', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const PlayerChapterItemPresentation(title: 'Prologue: The tide returns', timeRange: '00:00 - 08:42'),
        const PlayerChapterItemPresentation(
          title: '1. The northern harbor',
          timeRange: '08:42 - 31:18',
          selected: true,
        ),
        const PlayerChapterItemPresentation(title: '2. A house full of maps', timeRange: '31:18 - 58:03'),
        const SizedBox(height: 20),
        Text('Up next', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        PlayerQueueItemPresentation(
          title: 'Winter at Low Tide',
          subtitle: 'Jonas Vale',
          leading: Icon(Icons.drag_handle_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
          autoQueued: true,
          onRemove: () {},
        ),
        PlayerQueueItemPresentation(
          title: 'Field Notes: The Old Orchard',
          subtitle: 'Field Notes',
          leading: Icon(Icons.drag_handle_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
          onRemove: () {},
        ),
        PlayerQueueItemPresentation(
          title: 'Last Light',
          subtitle: 'Tamsin Rowe',
          leading: Icon(Icons.drag_handle_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
          onRemove: () {},
        ),
      ],
    );
  }
}

class PlayerCollectionEmptyPreview extends StatelessWidget {
  const PlayerCollectionEmptyPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        PlayerCollectionEmptyPresentation(
          icon: Icons.queue_music_rounded,
          title: 'Queue is empty',
          density: PlayerCollectionEmptyDensity.compact,
        ),
        SizedBox(height: 16),
        PlayerCollectionEmptyPresentation(icon: Icons.queue_music_rounded, title: 'Queue is empty', isLoading: true),
        SizedBox(height: 16),
        PlayerCollectionEmptyPresentation(
          icon: Icons.menu_book_outlined,
          title: 'No chapters available',
          subtitle: 'Winter at Low Tide',
        ),
      ],
    );
  }
}

class SleepTimerStatesPreview extends StatelessWidget {
  const SleepTimerStatesPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SleepTimerActivePresentation(isRunning: true, description: '15 min remaining'),
          SizedBox(height: 12),
          SleepTimerActivePresentation(isRunning: false, description: '2 chapters · 24 min remaining'),
        ],
      ),
    );
  }
}

class PlaybackSpeedSettingsPreview extends StatelessWidget {
  const PlaybackSpeedSettingsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: PlaybackSpeedSheet(initialSpeed: 1.2, onApplySpeed: _ignoreSpeed),
    );
  }
}

class PlayerSubtitlePreview extends StatelessWidget {
  const PlayerSubtitlePreview({super.key});

  static final ParsedSubtitleDocument _document = ParsedSubtitleDocument(
    format: SubtitleDocumentFormat.webvtt,
    cues: [
      ParsedSubtitleCue(
        start: Duration.zero,
        end: const Duration(seconds: 5),
        text: 'The rain reached the far end of the platform.',
        segments: const [
          ParsedSubtitleSegment(start: Duration.zero, end: Duration(seconds: 2), text: 'The rain reached '),
          ParsedSubtitleSegment(
            start: Duration(seconds: 2),
            end: Duration(seconds: 5),
            text: 'the far end of the platform.',
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Read along', style: Theme.of(context).textTheme.titleMedium),
        PlayerSubtitleCuePresentation(
          document: _document,
          cueIndex: 0,
          currentPosition: const Duration(seconds: 3),
          readAlongEnabled: true,
        ),
        const SizedBox(height: 12),
        Text('Compact player subtitle', style: Theme.of(context).textTheme.titleSmall),
        PlayerSubtitleCuePresentation(
          document: _document,
          cueIndex: 0,
          currentPosition: const Duration(seconds: 3),
          readAlongEnabled: false,
          compact: true,
        ),
        const SizedBox(height: 12),
        const PlayerSubtitleEmptyPresentation(compact: true),
      ],
    );
  }
}

class PlayerCastPreview extends StatelessWidget {
  const PlayerCastPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cast controls', style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              PlayerCastButtonPresentation(connected: false, onPressed: _ignorePlayerAction),
              PlayerCastButtonPresentation(connected: true, onPressed: _ignorePlayerAction),
            ],
          ),
          const SizedBox(height: 12),
          const PlayerCastStatusPresentation(fallbackTitle: 'The Distant Shore'),
          const SizedBox(height: 12),
          PlayerCastStatusPresentation(
            fallbackTitle: 'The Distant Shore',
            deviceName: 'Living Room Speaker',
            onPressed: _ignorePlayerAction,
          ),
        ],
      ),
    );
  }
}

class PlayerBookmarksPreview extends StatelessWidget {
  const PlayerBookmarksPreview({super.key});

  static const _bookmark = Bookmark(
    libraryItemId: 'preview-book',
    title: 'The lantern appears beyond the fog',
    time: 3438,
    createdAt: 1735689600,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Bookmarks', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        BookmarkCard(
          bookmark: _bookmark,
          isBusy: false,
          onSeek: _ignorePlayerAction,
          onEdit: _ignorePlayerAction,
          onDelete: _ignorePlayerAction,
          onSelect: _ignorePlayerAction,
          onLongPress: _ignorePlayerAction,
        ),
        const SizedBox(height: 8),
        BookmarkCard(
          bookmark: _bookmark.copyWith(title: ''),
          isBusy: false,
          selectionMode: true,
          isSelected: true,
          onSeek: _ignorePlayerAction,
          onEdit: _ignorePlayerAction,
          onDelete: _ignorePlayerAction,
          onSelect: _ignorePlayerAction,
          onLongPress: _ignorePlayerAction,
        ),
        const SizedBox(height: 8),
        BookmarkCard(
          bookmark: _bookmark.copyWith(title: 'Saving bookmark'),
          isBusy: true,
          onSeek: _ignorePlayerAction,
          onEdit: _ignorePlayerAction,
          onDelete: _ignorePlayerAction,
          onSelect: _ignorePlayerAction,
          onLongPress: _ignorePlayerAction,
        ),
      ],
    );
  }
}

class PlayerTransportButtonsPreview extends StatelessWidget {
  const PlayerTransportButtonsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        children: [
          const SkipButtonPresentation(previous: true, onPressed: null),
          const JumpIcon(rewind: true, durationSeconds: 5, size: 36),
          const JumpIcon(rewind: true, durationSeconds: 30, size: 42),
          const PlaybackButton(isPlaying: true, isLoading: false, prominent: true, onPressed: null),
          const JumpIcon(rewind: false, durationSeconds: 15, size: 42),
          const JumpIcon(rewind: false, durationSeconds: 30, size: 36),
          SkipButtonPresentation(previous: false, onPressed: () {}),
        ],
      ),
    );
  }
}

class PlayerGridLayoutPreview extends StatelessWidget {
  const PlayerGridLayoutPreview({super.key, this.screenSize = PlayerLayoutScreenSize.desktop});

  final PlayerLayoutScreenSize screenSize;

  @override
  Widget build(BuildContext context) {
    final media = previewInternalMedia();
    final profile = PlayerLayoutProfile.defaults(screenSize);
    final utilityActions = defaultMiniPlayerActions;
    final utilityOverrides = <PlayerActionType, VoidCallback>{for (final action in utilityActions) action: () {}};

    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: PlayerGridCanvas(
        screenSize: screenSize,
        profile: profile,
        editMode: false,
        isPlacementVisible: (placement) => placement.visible,
        componentBuilder: (placement) {
          switch (placement.type) {
            case PlayerComponentType.cover:
              return PlayerCoverComponent(api: null, media: media, fitMode: placement.coverFitMode);
            case PlayerComponentType.mediaInfo:
              return PlayerMediaInfoPresentation(
                title: media.title,
                author: media.author,
                narrator: media.narrator,
                series: media.series,
                seriesPosition: media.seriesPosition,
                showAuthor: placement.showAuthor,
                showNarrator: placement.showNarrator,
                showSeries: placement.showSeries,
                textAlignMode: placement.textAlign,
                fontScale: placement.mediaInfoFontScale,
              );
            case PlayerComponentType.seekBar:
              return const SeekTimelinePreview(compact: true);
            case PlayerComponentType.controls:
              return LayoutBuilder(
                builder: (context, constraints) {
                  final buttonSize = constraints.maxHeight < 56 ? 40.0 : 48.0;
                  final iconSize = buttonSize < 48 ? 26.0 : 30.0;
                  return Center(
                    child: Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SkipButtonPresentation(previous: true, onPressed: null, buttonSize: buttonSize),
                        JumpIcon(rewind: true, durationSeconds: 30, size: iconSize),
                        PlaybackButton(
                          isPlaying: true,
                          isLoading: false,
                          onPressed: () {},
                          prominent: true,
                          iconSize: iconSize,
                          buttonSize: buttonSize,
                        ),
                        JumpIcon(rewind: false, durationSeconds: 30, size: iconSize),
                        SkipButtonPresentation(previous: false, onPressed: null, buttonSize: buttonSize),
                      ],
                    ),
                  );
                },
              );
            case PlayerComponentType.utilities:
              return PlayerActionBar(
                actions: utilityActions,
                hasChapters: true,
                grouped: true,
                actionOverrides: utilityOverrides,
              );
            case PlayerComponentType.subtitles:
              return const Center(child: Text('The rain reached the far end of the platform.'));
            case PlayerComponentType.chapters:
              return ListView(
                children: const [
                  PlayerChapterItemPresentation(title: '1. The northern harbor', timeRange: '08:42 - 31:18'),
                  PlayerChapterItemPresentation(title: '2. A house full of maps', timeRange: '31:18 - 58:03'),
                ],
              );
            case PlayerComponentType.queue:
              return ListView(
                children: [
                  PlayerQueueItemPresentation(
                    title: 'Winter at Low Tide',
                    subtitle: 'Jonas Vale',
                    autoQueued: true,
                    onRemove: () {},
                  ),
                  PlayerQueueItemPresentation(title: 'Field Notes', subtitle: 'Field Notes', onRemove: () {}),
                ],
              );
          }
        },
      ),
    );
  }
}

class PlayerComponentSettingsPreview extends StatelessWidget {
  const PlayerComponentSettingsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayerComponentSettingsSheet(
      componentType: PlayerComponentType.mediaInfo,
      profile: PlayerLayoutProfile.defaults(PlayerLayoutScreenSize.mobile),
      onChanged: _ignorePlayerLayoutChange,
    );
  }
}

class SeekTimelinePreview extends StatelessWidget {
  const SeekTimelinePreview({super.key, this.compact = false});

  final bool compact;

  static const _duration = Duration(hours: 3, minutes: 42);
  static const _position = Duration(minutes: 57, seconds: 18);

  String _formatDuration(Duration? value) {
    if (value == null) {
      return '--:--';
    }

    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (hours == 0) {
      return '$minutes:$seconds';
    }

    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return SeekBarRow(
      trackHeight: compact ? 4 : 6,
      timeLabelsBelow: !compact,
      showTimeLabels: !compact,
      timeLabelFontSize: compact ? 10 : 12,
      previewLabelFontSize: compact ? 10 : 12,
      rangeStart: Duration.zero,
      rangeEnd: _duration,
      currentPosition: _position,
      leftTime: _position,
      rightTime: _duration - _position,
      showRemaining: true,
      onToggleRemaining: () {},
      onSeek: (_) async {},
      markers: [
        SeekTimelineMarker(position: const Duration(minutes: 20), type: SeekTimelineMarkerType.chapter),
        SeekTimelineMarker(position: const Duration(minutes: 43), type: SeekTimelineMarkerType.bookmark),
      ],
      markerMode: SeekBarMarkerMode.both,
      buildPreviewLabel: _formatDuration,
      formatDuration: _formatDuration,
      centerLabel: compact ? null : 'Chapter 4 · The lighthouse',
      sleepTimerMarker: const SleepTimerMarker(
        itemId: 'preview-book',
        episodeId: null,
        startPosition: Duration(hours: 1, minutes: 32),
        endPosition: Duration(hours: 2, minutes: 2),
      ),
    );
  }
}

class VolumeSliderCardPreview extends StatelessWidget {
  const VolumeSliderCardPreview({super.key, required this.axis});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final slider = VolumeSliderPresentation(
      axis: axis,
      volume: axis == Axis.horizontal ? 1.3 : 0.7,
      maxVolume: 2,
      onChanged: _ignoreVolume,
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: axis == Axis.horizontal
          ? slider
          : LayoutBuilder(
              builder: (context, constraints) {
                final labels = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Volume', style: Theme.of(context).textTheme.titleLarge),
                    const Text('Vertical player control'),
                  ],
                );

                if (constraints.maxWidth < 360) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labels,
                      const SizedBox(height: 12),
                      Center(child: slider),
                    ],
                  );
                }

                return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [labels, slider]);
              },
            ),
    );
  }
}

void _ignoreVolume(double _) {}

void _ignoreSpeed(double _) {}

void _ignorePlayerAction() {}

void _ignorePlayerLayoutChange(PlayerLayoutProfile _) {}
