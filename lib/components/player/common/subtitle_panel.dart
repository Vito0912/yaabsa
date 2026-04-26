import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/subtitle_reading_mode.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/subtitles/subtitle_loader.dart';
import 'package:yaabsa/util/subtitles/subtitle_parser.dart';

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
      defaultValue: defaultSettings[SettingKeys.subtitlesEnabled] as bool? ?? true,
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
              stream: audioHandler.player.playerStateStream,
              initialData: audioHandler.player.playerState,
              builder: (context, stateSnapshot) {
                final state = stateSnapshot.data;
                final isPlaying = state != null && state.playing && state.processingState == ProcessingState.ready;
                if (!isPlaying) {
                  final emptyPanel = _SubtitleContainer(
                    compact: compact,
                    child: _EmptySubtitleBody(compact: compact),
                  );
                  return _wrapPanelForTap(context, emptyPanel);
                }

                return StreamBuilder<Duration>(
                  stream: audioHandler.positionStream,
                  initialData: audioHandler.position,
                  builder: (context, positionSnapshot) {
                    final position = positionSnapshot.data ?? Duration.zero;
                    final cueIndex = document.cueIndexAt(position);
                    if (cueIndex < 0) {
                      final emptyPanel = _SubtitleContainer(
                        compact: compact,
                        child: _EmptySubtitleBody(compact: compact),
                      );
                      return _wrapPanelForTap(context, emptyPanel);
                    }

                    final cue = document.cues[cueIndex];
                    final accentColor = canHighlightSpeaker && cue.speaker?.isNotEmpty == true
                        ? _speakerColorFor(cue.speaker!, Theme.of(context).colorScheme)
                        : null;

                    final panelChild = _SubtitleContainer(
                      compact: compact,
                      child: _SubtitleCueView(
                        document: document,
                        cueIndex: cueIndex,
                        currentPosition: position,
                        readAlongEnabled: canReadAlong,
                        compact: compact,
                        accentColor: accentColor,
                      ),
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

class _SubtitleContainer extends StatelessWidget {
  const _SubtitleContainer({required this.child, required this.compact});

  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padding = compact
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 7)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 9);

    return Padding(
      padding: EdgeInsets.only(top: compact ? 4 : 6),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.65)),
        ),
        child: child,
      ),
    );
  }
}

class _SubtitleCueView extends StatelessWidget {
  const _SubtitleCueView({
    required this.document,
    required this.cueIndex,
    required this.currentPosition,
    required this.readAlongEnabled,
    required this.compact,
    this.accentColor,
  });

  final ParsedSubtitleDocument document;
  final int cueIndex;
  final Duration currentPosition;
  final bool readAlongEnabled;
  final bool compact;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cue = document.cues[cueIndex];
    final colorScheme = Theme.of(context).colorScheme;
    final currentCueStyle = (compact ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.bodyLarge)
        ?.copyWith(height: 1.35);
    final baseStyle = currentCueStyle ?? const TextStyle(fontSize: 16, height: 1.35);
    final activeStyle = baseStyle.copyWith(
      color: colorScheme.primary,
      backgroundColor: colorScheme.primary.withValues(alpha: 0.18),
    );

    Widget content;
    if (readAlongEnabled && cue.segments.isNotEmpty) {
      final spans = <TextSpan>[];
      for (final segment in cue.segments) {
        final isActive = currentPosition >= segment.start && currentPosition < segment.end;
        spans.add(TextSpan(text: segment.text, style: isActive ? activeStyle : baseStyle));
      }

      content = RichText(
        textAlign: TextAlign.center,
        text: TextSpan(style: baseStyle, children: spans),
      );
    } else {
      content = Text(cue.text, textAlign: TextAlign.center, style: baseStyle);
    }

    final cueWindow = Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [content]);

    final accent = accentColor;
    if (accent == null) {
      return cueWindow;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: accent, width: 3.0)),
      ),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), child: cueWindow),
    );
  }
}

class _EmptySubtitleBody extends StatelessWidget {
  const _EmptySubtitleBody({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: compact ? 18 : 22, width: double.infinity);
  }
}
