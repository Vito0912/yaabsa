import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';
import 'package:yaabsa/components/player/common/sleep_timer_button.dart';
import 'package:yaabsa/components/player/common/speed_slider.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
import 'package:yaabsa/components/player/common/volume_slider.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/chapter.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/screens/player/queue.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _PlayerLayoutType { mobile, tablet, desktop }

class Player extends StatelessWidget {
  const Player({super.key});

  _PlayerLayoutType _resolveLayout(double width) {
    if (width < 700) {
      return _PlayerLayoutType.mobile;
    }
    if (width < 1150) {
      return _PlayerLayoutType.tablet;
    }
    return _PlayerLayoutType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    void closePlayerIfOpen() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        final location = GoRouterState.of(context).matchedLocation;
        if (location == '/player') {
          if (Navigator.of(context).canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Player'),
        actions: [
          if (context.isMobile)
            IconButton(
              icon: const Icon(Icons.queue_music_rounded),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (context) => const _QueueBottomSheet(),
                );
              },
              tooltip: 'Queue',
            ),
          IconButton(
            icon: const Icon(Icons.directions_car_filled_outlined),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const _CarModeScreen()));
            },
            tooltip: 'Car Mode',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.push(PlayHistoryView.routeName);
            },
            tooltip: 'Play History',
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                showDragHandle: true,
                builder: (context) => const _PlayerQuickSettingsSheet(),
              );
            },
            tooltip: 'Quick Settings',
          ),
          StopButton(),
        ],
      ),
      body: Consumer(
        builder: (BuildContext context, ref, child) {
          final ABSApi? api = ref.watch(absApiProvider);
          return StreamBuilder<bool>(
            stream: audioHandler.queueTransitionLoadingStream,
            initialData: audioHandler.queueTransitionLoading,
            builder: (context, transitionSnapshot) {
              final isTransitionLoading = transitionSnapshot.data == true;
              return StreamBuilder<InternalMedia?>(
                stream: audioHandler.mediaItemStream.stream,
                initialData: audioHandler.currentMediaItem,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.waiting && asyncSnapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (asyncSnapshot.data == null) {
                    if (isTransitionLoading) {
                      return const _PlayerTransitionLoadingView();
                    }

                    closePlayerIfOpen();
                    return const SizedBox.shrink();
                  }

                  final InternalMedia media = asyncSnapshot.data!;
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final layout = _resolveLayout(constraints.maxWidth);
                      final basePadding = layout == _PlayerLayoutType.mobile ? 6.0 : 8.0;
                      final hasChapters = media.chapters?.isNotEmpty == true;

                      if (layout == _PlayerLayoutType.mobile) {
                        return Padding(
                          padding: EdgeInsets.all(basePadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _NowPlayingPanel(api: api, media: media, layout: layout),
                                      if (hasChapters) ...[
                                        const SizedBox(height: 6),
                                        const _SectionPanel(title: 'Chapters', child: ChapterView(maxHeight: 190)),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              const _SectionPanel(title: 'Playback', child: _PlaybackContent(dense: true)),
                            ],
                          ),
                        );
                      }

                      if (layout == _PlayerLayoutType.tablet) {
                        return StreamBuilder<PlayerQueueSnapshot>(
                          stream: audioHandler.queueSnapshotStream,
                          initialData: audioHandler.queueSnapshot,
                          builder: (context, queueSnapshot) {
                            final showQueue = queueSnapshot.data?.entries.isNotEmpty == true;
                            final showSidePanels = hasChapters || showQueue;

                            return Padding(
                              padding: EdgeInsets.all(basePadding),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        _NowPlayingPanel(api: api, media: media, layout: layout),
                                        const Spacer(),
                                        const _SectionPanel(title: 'Playback', child: _PlaybackContent(dense: true)),
                                      ],
                                    ),
                                  ),
                                  if (showSidePanels) const SizedBox(width: 6),
                                  if (showSidePanels)
                                    SizedBox(
                                      width: 320,
                                      child: _PlayerSidePanels(hasChapters: hasChapters, showQueue: showQueue),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return StreamBuilder<PlayerQueueSnapshot>(
                        stream: audioHandler.queueSnapshotStream,
                        initialData: audioHandler.queueSnapshot,
                        builder: (context, queueSnapshot) {
                          final showQueue = queueSnapshot.data?.entries.isNotEmpty == true;
                          final showSidePanels = hasChapters || showQueue;

                          return Padding(
                            padding: EdgeInsets.all(basePadding),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      _NowPlayingPanel(api: api, media: media, layout: layout),
                                      const Spacer(),
                                      const _SectionPanel(title: 'Playback', child: _PlaybackContent(dense: true)),
                                    ],
                                  ),
                                ),
                                if (showSidePanels) const SizedBox(width: 6),
                                if (showSidePanels)
                                  SizedBox(
                                    width: 360,
                                    child: _PlayerSidePanels(hasChapters: hasChapters, showQueue: showQueue),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PlayerTransitionLoadingView extends StatelessWidget {
  const _PlayerTransitionLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.6)),
          const SizedBox(height: 10),
          Text('Loading next item...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _NowPlayingPanel extends StatelessWidget {
  const _NowPlayingPanel({required this.api, required this.media, required this.layout});

  final ABSApi? api;
  final InternalMedia media;
  final _PlayerLayoutType layout;

  double get _coverSize {
    switch (layout) {
      case _PlayerLayoutType.mobile:
        return 108;
      case _PlayerLayoutType.tablet:
        return 124;
      case _PlayerLayoutType.desktop:
        return 148;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionPanel(
      title: 'Now Playing',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CoverArt(api: api, media: media, size: _coverSize),
          const SizedBox(width: 10),
          Expanded(child: _TitleBlock(media: media, alignCenter: false)),
        ],
      ),
    );
  }
}

class _CoverArt extends StatelessWidget {
  const _CoverArt({required this.api, required this.media, required this.size});

  final ABSApi? api;
  final InternalMedia media;
  final double size;

  @override
  Widget build(BuildContext context) {
    const fallback = CoverPlaceholder(borderRadius: 14);

    return SizedBox(
      width: size,
      height: size,
      child: api == null || media.cover == null
          ? fallback
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: api!.getLibraryItemApi().getLibraryItemCover(media.itemId),
            ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({required this.media, required this.alignCenter});

  final InternalMedia media;
  final bool alignCenter;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final authorStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return Column(
      crossAxisAlignment: alignCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          media.title,
          textAlign: alignCenter ? TextAlign.center : TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        const SizedBox(height: 4),
        Text(
          media.author ?? 'Unknown Author',
          textAlign: alignCenter ? TextAlign.center : TextAlign.start,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: authorStyle,
        ),
      ],
    );
  }
}

class _PlaybackContent extends StatelessWidget {
  const _PlaybackContent({this.dense = false});

  final bool dense;

  @override
  Widget build(BuildContext context) {
    final spacing = dense ? 6.0 : 8.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VolumeSlider(),
        SizedBox(height: spacing),
        const SeekBar(),
        SizedBox(height: spacing),
        const Wrap(
          alignment: WrapAlignment.center,
          spacing: 2,
          runSpacing: 2,
          children: [
            SkipButton(previous: true),
            JumpButton(rewind: true),
            ControlButton(),
            JumpButton(rewind: false),
            SkipButton(previous: false),
          ],
        ),
        SizedBox(height: spacing),
        const Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [SpeedSlider(), SleepTimerButton()],
        ),
      ],
    );
  }
}

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({required this.title, required this.child, this.expandChild = false});

  final String title;
  final Widget child;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    final content = expandChild ? Expanded(child: child) : child;
    final borderRadius = BorderRadius.circular(12);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: borderRadius,
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            content,
          ],
        ),
      ),
    );
  }
}

class _PlayerSidePanels extends StatelessWidget {
  const _PlayerSidePanels({required this.hasChapters, required this.showQueue});

  final bool hasChapters;
  final bool showQueue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (hasChapters)
          const Expanded(
            child: _SectionPanel(title: 'Chapters', expandChild: true, child: ChapterView()),
          ),
        if (hasChapters && showQueue) const SizedBox(height: 6),
        if (showQueue)
          const Expanded(
            child: _SectionPanel(title: 'Queue', expandChild: true, child: PlayerQueueView(showEmptyIcon: false)),
          ),
      ],
    );
  }
}

class _QueueBottomSheet extends StatelessWidget {
  const _QueueBottomSheet();

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return SafeArea(
      child: SizedBox(
        height: maxHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Queue', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Expanded(child: PlayerQueueView(showEmptyIcon: false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarModeScreen extends ConsumerWidget {
  const _CarModeScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.watch(absApiProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Car Mode')),
      body: StreamBuilder<InternalMedia?>(
        stream: audioHandler.mediaItemStream.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final media = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CoverArt(api: api, media: media, size: 260),
                      const SizedBox(height: 20),
                      Text(
                        media.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        media.author ?? 'Unknown Author',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const SeekBar(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _CarControl(icon: Icons.replay_10, onPressed: () => audioHandler.rewind()),
                    const _CarPlayPauseControl(),
                    _CarControl(icon: Icons.forward_10, onPressed: () => audioHandler.fastForward()),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CarControl extends StatelessWidget {
  const _CarControl({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 46,
      style: IconButton.styleFrom(minimumSize: const Size(96, 96)),
    );
  }
}

class _CarPlayPauseControl extends StatelessWidget {
  const _CarPlayPauseControl();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: audioHandler.player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        return IconButton.filled(
          onPressed: () {
            if (isPlaying) {
              audioHandler.pause();
            } else {
              audioHandler.play();
            }
          },
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 56,
          style: IconButton.styleFrom(minimumSize: const Size(116, 116)),
        );
      },
    );
  }
}

class _PlayerQuickSettingsSheet extends ConsumerWidget {
  const _PlayerQuickSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeValue = ref.watch(globalSettingByKeyProvider(SettingKeys.playerSeekBarMode)).asData?.value;
    final selectedMode = PlayerSeekBarMode.fromSettingValue(modeValue);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quick Player Settings', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Timeline mode',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PlayerSeekBarMode.values.map((mode) {
                final selected = mode == selectedMode;
                return ChoiceChip(
                  label: Text(mode.label),
                  selected: selected,
                  onSelected: (value) {
                    if (!value) return;
                    ref
                        .read(settingsManagerProvider.notifier)
                        .setGlobalSetting<String>(SettingKeys.playerSeekBarMode, mode.name);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
