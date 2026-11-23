import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/features/player/widgets/player_subtitle_presentation.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/subtitle_reading_mode.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/subtitles/subtitle_loader.dart';

class SubtitlePanel extends ConsumerWidget {
  const SubtitlePanel({super.key, this.compact = false, this.openContinuousModeOnTap = true});

  final bool compact;
  final bool openContinuousModeOnTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsManager = ref.read(settingsManagerProvider.notifier);
    ref.watch(userSettingsWatcherProvider);

    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final userId = currentUser?.id;

    final subtitlesEnabled = settingsManager.getUserSetting<bool>(
      userId,
      SettingKeys.subtitlesEnabled,
      defaultValue: defaultSettings[SettingKeys.subtitlesEnabled] as bool? ?? false,
    );
    if (!subtitlesEnabled) {
      return const SizedBox.shrink();
    }

    final speakerHighlightingEnabled = settingsManager.getUserSetting<bool>(
      userId,
      SettingKeys.subtitleSpeakerHighlighting,
      defaultValue: defaultSettings[SettingKeys.subtitleSpeakerHighlighting] as bool? ?? true,
    );
    final readAlongEnabled = settingsManager.getUserSetting<bool>(
      userId,
      SettingKeys.subtitleReadAlong,
      defaultValue: defaultSettings[SettingKeys.subtitleReadAlong] as bool? ?? true,
    );

    return StreamBuilder(
      stream: audioHandler.mediaItemStream.stream,
      initialData: audioHandler.currentMediaItem,
      builder: (context, mediaSnapshot) {
        final media = mediaSnapshot.data;
        if (media == null) {
          return const SizedBox.shrink();
        }

        final loadFuture = loadSubtitleDocumentForItem(
          ref: ref,
          itemId: media.itemId,
          episodeId: media.episodeId,
          userId: userId,
        );

        return FutureBuilder<LoadedSubtitleDocument?>(
          future: loadFuture,
          builder: (context, subtitleSnapshot) {
            final loaded = subtitleSnapshot.data;
            if (loaded == null) {
              return const SizedBox.shrink();
            }

            final document = loaded.document;
            final canHighlightSpeaker = speakerHighlightingEnabled && document.supportsSpeakerHighlighting;
            final canReadAlong = readAlongEnabled && document.supportsReadAlong;

            return StreamBuilder<PlayerState>(
              stream: audioHandler.playerControlStateStream,
              initialData: audioHandler.playerControlState,
              builder: (context, stateSnapshot) {
                final state = stateSnapshot.data;
                final isPlaying = state != null && state.playing && state.processingState == ProcessingState.ready;
                if (!isPlaying) {
                  final emptyPanel = PlayerSubtitleEmptyPresentation(compact: compact);
                  return _wrapPanelForTap(context, emptyPanel);
                }

                return StreamBuilder<Duration>(
                  stream: audioHandler.subtitlePositionStream,
                  initialData: audioHandler.position,
                  builder: (context, positionSnapshot) {
                    final position = positionSnapshot.data ?? Duration.zero;
                    final cueIndex = document.cueIndexAt(position);
                    if (cueIndex < 0) {
                      final emptyPanel = PlayerSubtitleEmptyPresentation(compact: compact);
                      return _wrapPanelForTap(context, emptyPanel);
                    }

                    final cue = document.cues[cueIndex];
                    final accentColor = canHighlightSpeaker && cue.speaker?.isNotEmpty == true
                        ? _speakerColorFor(cue.speaker!, Theme.of(context).colorScheme)
                        : null;

                    final panelChild = PlayerSubtitleCuePresentation(
                      document: document,
                      cueIndex: cueIndex,
                      currentPosition: position,
                      readAlongEnabled: canReadAlong,
                      compact: compact,
                      accentColor: accentColor,
                    );

                    if (!openContinuousModeOnTap) {
                      return panelChild;
                    }

                    return _wrapPanelForTap(context, panelChild);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _wrapPanelForTap(BuildContext context, Widget panelChild) {
    if (!openContinuousModeOnTap) {
      return panelChild;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _openContinuousMode(context),
        child: panelChild,
      ),
    );
  }

  void _openContinuousMode(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    if (currentLocation == SubtitleReadingModeView.routeName) {
      return;
    }

    context.go(SubtitleReadingModeView.routeName);
  }

  Color _speakerColorFor(String speaker, ColorScheme colorScheme) {
    final normalized = speaker.trim().toLowerCase();
    final hash = normalized.codeUnits.fold<int>(0, (value, unit) => (value * 31 + unit) & 0x7fffffff);
    final colors = <Color>[colorScheme.primary, colorScheme.secondary, colorScheme.tertiary];
    return colors[hash % colors.length];
  }
}
