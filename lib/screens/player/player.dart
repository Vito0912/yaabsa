import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/cast_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';
import 'package:yaabsa/components/player/common/sleep_timer_button.dart';
import 'package:yaabsa/components/player/common/speed_slider.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
import 'package:yaabsa/components/player/common/subtitle_panel.dart';
import 'package:yaabsa/components/player/common/volume_slider.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/bookmarks_sheet.dart';
import 'package:yaabsa/screens/player/car_mode_screen.dart';
import 'package:yaabsa/screens/player/chapter.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/screens/player/queue.dart';
import 'package:yaabsa/util/chrome_cast_service.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

enum _PlayerLayoutType { mobile, tablet, desktop }

enum _PlayerAppBarMenuAction { queue, addBookmark, carMode, playHistory, cast }

class Player extends ConsumerStatefulWidget {
  const Player({super.key});

  @override
  ConsumerState<Player> createState() => _PlayerState();
}

class _PlayerState extends ConsumerState<Player> {
  bool _didAutoOpenCarMode = false;
  StreamSubscription<AaosTelemetryState>? _aaosAutoOpenSubscription;

  @override
  void initState() {
    super.initState();
    _aaosAutoOpenSubscription = AaosService.instance.stream.listen(_maybeAutoOpenCarMode);
    _maybeAutoOpenCarMode(AaosService.instance.currentState);
  }

  @override
  void dispose() {
    _aaosAutoOpenSubscription?.cancel();
    super.dispose();
  }

  void _maybeAutoOpenCarMode(AaosTelemetryState state) {
    if (_didAutoOpenCarMode || !state.isAutomotiveDevice || !mounted) {
      return;
    }

    _didAutoOpenCarMode = true;
    _aaosAutoOpenSubscription?.cancel();
    _aaosAutoOpenSubscription = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _openCarMode(context);
    });
  }

  _PlayerLayoutType _resolveLayout(double width) {
    if (width < 700) {
      return _PlayerLayoutType.mobile;
    }
    if (width < 1150) {
      return _PlayerLayoutType.tablet;
    }
    return _PlayerLayoutType.desktop;
  }

  void _showQueueSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const _QueueBottomSheet(),
    );
  }

  void _openCarMode(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CarModeScreen()));
  }

  void _openPlayHistory(BuildContext context) {
    context.push(PlayHistoryView.routeName);
  }

  void _showQuickSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _PlayerQuickSettingsSheet(),
    );
  }

  void _showBookmarksSheet(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final media = audioHandler.currentMediaItem;
    if (media == null) {
      messenger.showSnackBar(const SnackBar(content: Text('No active media to bookmark.')));
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => PlayerBookmarksSheet(itemId: media.itemId, itemTitle: media.title),
    );
  }

  Future<void> _handleAppBarMenuAction(BuildContext context, _PlayerAppBarMenuAction action) async {
    switch (action) {
      case _PlayerAppBarMenuAction.queue:
        _showQueueSheet(context);
      case _PlayerAppBarMenuAction.addBookmark:
        _showBookmarksSheet(context);
      case _PlayerAppBarMenuAction.carMode:
        _openCarMode(context);
      case _PlayerAppBarMenuAction.playHistory:
        _openPlayHistory(context);
      case _PlayerAppBarMenuAction.cast:
        await showCastDevicePicker(context);
    }
  }

  List<PopupMenuEntry<_PlayerAppBarMenuAction>> _buildOverflowMenuItems({
    required bool isMobile,
    required bool castSupported,
  }) {
    final items = <PopupMenuEntry<_PlayerAppBarMenuAction>>[];

    if (isMobile) {
      items.add(
        const PopupMenuItem<_PlayerAppBarMenuAction>(
          value: _PlayerAppBarMenuAction.queue,
          child: _PlayerAppBarMenuItem(icon: Icons.queue_music_rounded, label: 'Queue'),
        ),
      );
    }

    items.add(
      const PopupMenuItem<_PlayerAppBarMenuAction>(
        value: _PlayerAppBarMenuAction.addBookmark,
        child: _PlayerAppBarMenuItem(icon: Icons.bookmarks_outlined, label: 'Bookmarks'),
      ),
    );

    items.addAll([
      const PopupMenuItem<_PlayerAppBarMenuAction>(
        value: _PlayerAppBarMenuAction.carMode,
        child: _PlayerAppBarMenuItem(icon: Icons.directions_car_filled_outlined, label: 'Car Mode'),
      ),
      const PopupMenuItem<_PlayerAppBarMenuAction>(
        value: _PlayerAppBarMenuAction.playHistory,
        child: _PlayerAppBarMenuItem(icon: Icons.history, label: 'Play History'),
      ),
    ]);

    if (isMobile && castSupported) {
      items.add(
        const PopupMenuItem<_PlayerAppBarMenuAction>(
          value: _PlayerAppBarMenuAction.cast,
          child: _PlayerAppBarMenuItem(icon: Icons.cast, label: 'Cast'),
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final castSupported = ChromeCastService.isSupportedPlatform;
    final isMobile = context.isMobile;

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
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showQuickSettings(context),
            tooltip: 'Quick Settings',
          ),
          if (!isMobile && castSupported) const CastButton(),
          const StopButton(),
          PopupMenuButton<_PlayerAppBarMenuAction>(
            tooltip: 'More options',
            icon: const Icon(Icons.more_vert),
            onSelected: (action) async {
              await _handleAppBarMenuAction(context, action);
            },
            itemBuilder: (context) => _buildOverflowMenuItems(isMobile: isMobile, castSupported: castSupported),
          ),
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
    final currentApi = api;
    final requestHeaders = currentApi == null
        ? const <String, String>{}
        : normalizeImageRequestHeaders(currentApi.dio.options.headers);
    final imageProvider = coverImageProviderFromUri(media.cover, requestHeaders: requestHeaders);

    return SizedBox(
      width: size,
      height: size,
      child: imageProvider == null
          ? fallback
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    openCoverZoomView(
                      context,
                      coverUri: media.cover!,
                      requestHeaders: requestHeaders,
                      semanticsLabel: media.title,
                    );
                  },
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                    errorBuilder: (context, error, stackTrace) => fallback,
                  ),
                ),
              ),
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
        const SubtitlePanel(),
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

class _PlayerAppBarMenuItem extends StatelessWidget {
  const _PlayerAppBarMenuItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).iconTheme.color ?? Theme.of(context).colorScheme.onSurface),
        const SizedBox(width: 12),
        Text(label),
      ],
    );
  }
}

class _PlayerQuickSettingsSheet extends ConsumerWidget {
  const _PlayerQuickSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(globalSettingByKeyProvider(SettingKeys.playerSeekBarMode));
    final selectedMode = PlayerSeekBarMode.fromSettingValue(
      ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<String>(SettingKeys.playerSeekBarMode, defaultValue: PlayerSeekBarMode.full.name),
    );

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
