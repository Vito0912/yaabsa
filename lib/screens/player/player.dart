import 'dart:async';

import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:yaabsa/screens/settings/player/player_settings_equalizer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/components/player/common/cast_button.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/player/bookmarks_sheet.dart';
import 'package:yaabsa/screens/player/car_mode_screen.dart';
import 'package:yaabsa/screens/player/components/player_chapters_component.dart';
import 'package:yaabsa/screens/player/components/player_cover_component.dart';
import 'package:yaabsa/screens/player/components/player_media_info_component.dart';
import 'package:yaabsa/screens/player/components/player_playback_controls_component.dart';
import 'package:yaabsa/screens/player/components/player_keyboard_shortcuts.dart';
import 'package:yaabsa/screens/player/components/player_queue_component.dart';
import 'package:yaabsa/screens/player/components/player_seek_bar_component.dart';
import 'package:yaabsa/screens/player/components/player_subtitles_component.dart';
import 'package:yaabsa/screens/player/components/player_utilities_component.dart';
import 'package:yaabsa/screens/player/layout/player_component_settings_sheet.dart';
import 'package:yaabsa/screens/player/layout/player_adaptive_view.dart';
import 'package:yaabsa/screens/player/layout/player_grid_canvas.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/screens/player/player_empty_state_mode.dart';
import 'package:yaabsa/screens/player/play_history_view.dart';
import 'package:yaabsa/screens/player/queue.dart';
import 'package:yaabsa/util/aaos_service.dart';
import 'package:yaabsa/util/chrome_cast_service.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/setting_key.dart';

enum _PlayerAppBarMenuAction { queue, stop, addBookmark, carMode, playHistory, cast, equalizer }

class Player extends ConsumerStatefulWidget {
  const Player({super.key});

  @override
  ConsumerState<Player> createState() => _PlayerState();
}

class _PlayerState extends ConsumerState<Player> {
  static const double _minimizeDragDistanceThreshold = 64;
  static const double _minimizeDragVelocityThreshold = 520;

  bool _didAutoOpenCarMode = false;
  bool _isEditMode = false;
  bool _allowOverlapUnlocked = false;
  double _verticalDragDelta = 0;
  Color? _adaptiveNavigationBarColor;
  PlayerLayoutConfig? _layoutDraft;
  Future<void> _persistSequence = Future<void>.value();
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

  void _updateAdaptiveNavigationBarColor(Color color) {
    if (!mounted || _adaptiveNavigationBarColor == color) {
      return;
    }

    setState(() {
      _adaptiveNavigationBarColor = color;
    });
  }

  void _showQueueSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => const _QueueBottomSheet(),
    );
  }

  void _openCarMode(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CarModeScreen()));
  }

  void _openPlayHistory(BuildContext context) {
    final currentMedia = audioHandler.currentMediaItem;
    if (currentMedia == null) {
      context.push(PlayHistoryView.routeName);
      return;
    }

    context.push(
      PlayHistoryView.location(
        itemId: currentMedia.itemId,
        episodeId: currentMedia.episodeId,
        itemTitle: currentMedia.title,
      ),
    );
  }

  void _closePlayerIfOpen() {
    if (!mounted) {
      return;
    }

    final location = GoRouterState.of(context).matchedLocation;
    if (location != '/player') {
      return;
    }

    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  void _scheduleClosePlayerIfOpen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _closePlayerIfOpen();
    });
  }

  void _handleVerticalDragStart(DragStartDetails details) {
    _verticalDragDelta = 0;
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    _verticalDragDelta += details.delta.dy;
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final draggedDownEnough = _verticalDragDelta >= _minimizeDragDistanceThreshold;
    final flungDown = velocity >= _minimizeDragVelocityThreshold;
    _verticalDragDelta = 0;

    if (draggedDownEnough || flungDown) {
      _closePlayerIfOpen();
    }
  }

  void _showQuickSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => const _PlayerQuickSettingsSheet(),
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
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (BuildContext context) => PlayerBookmarksSheet(itemId: media.itemId, itemTitle: media.title),
    );
  }

  Future<void> _handleAppBarMenuAction(BuildContext context, _PlayerAppBarMenuAction action) async {
    switch (action) {
      case _PlayerAppBarMenuAction.queue:
        _showQueueSheet(context);
      case _PlayerAppBarMenuAction.stop:
        await audioHandler.stop();
      case _PlayerAppBarMenuAction.addBookmark:
        _showBookmarksSheet(context);
      case _PlayerAppBarMenuAction.carMode:
        _openCarMode(context);
      case _PlayerAppBarMenuAction.playHistory:
        _openPlayHistory(context);
      case _PlayerAppBarMenuAction.cast:
        await showCastDevicePicker(context);
      case _PlayerAppBarMenuAction.equalizer:
        context.go(PlayerSettingsEqualizer.routeName);
    }
  }

  List<PopupMenuEntry<_PlayerAppBarMenuAction>> _buildOverflowMenuItems({
    required bool isMobile,
    required bool castSupported,
  }) {
    final items = <PopupMenuEntry<_PlayerAppBarMenuAction>>[];

    items.add(
      const PopupMenuItem<_PlayerAppBarMenuAction>(
        value: _PlayerAppBarMenuAction.queue,
        child: _PlayerAppBarMenuItem(icon: Icons.queue_music_rounded, label: 'Queue'),
      ),
    );

    items.add(
      const PopupMenuItem<_PlayerAppBarMenuAction>(
        value: _PlayerAppBarMenuAction.stop,
        child: _PlayerAppBarMenuItem(icon: Icons.stop_circle_outlined, label: 'Stop playback'),
      ),
    );

    items.add(
      const PopupMenuItem<_PlayerAppBarMenuAction>(
        value: _PlayerAppBarMenuAction.addBookmark,
        child: _PlayerAppBarMenuItem(icon: Icons.bookmarks_outlined, label: 'Bookmarks'),
      ),
    );

    items.addAll(<PopupMenuEntry<_PlayerAppBarMenuAction>>[
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

    if (defaultTargetPlatform == TargetPlatform.android) {
      items.add(
        const PopupMenuItem<_PlayerAppBarMenuAction>(
          value: _PlayerAppBarMenuAction.equalizer,
          child: _PlayerAppBarMenuItem(icon: Icons.equalizer_rounded, label: 'Equalizer'),
        ),
      );
    }

    return items;
  }

  PlayerLayoutConfig _readLayoutConfigFromSettings() {
    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final rawLayoutConfig = settingsManager.getGlobalSetting<String>(SettingKeys.playerLayoutConfig, defaultValue: '');

    return PlayerLayoutConfig.fromSettingValue(rawLayoutConfig);
  }

  PlayerLayoutConfig _currentLayoutConfig() {
    return _layoutDraft ?? _readLayoutConfigFromSettings();
  }

  PlayerLayoutProfile _activeProfileForScreen(PlayerLayoutScreenSize screenSize) {
    final layoutConfig = _currentLayoutConfig();
    return normalizePlayerLayoutProfile(layoutConfig.profileFor(screenSize), screenSize, allowOverlap: true);
  }

  Future<void> _persistLayoutConfig(PlayerLayoutConfig layoutConfig) async {
    final settingsManager = ref.read(settingsManagerProvider.notifier);
    _persistSequence = _persistSequence
        .catchError((_) {})
        .then(
          (_) =>
              settingsManager.setGlobalSetting<String>(SettingKeys.playerLayoutConfig, layoutConfig.toSettingValue()),
        );

    await _persistSequence;
  }

  bool _rectanglesOverlap({
    required int x,
    required int y,
    required int width,
    required int height,
    required PlayerComponentPlacement other,
  }) {
    final right = x + width;
    final bottom = y + height;
    final otherRight = other.x + other.width;
    final otherBottom = other.y + other.height;

    return !(right <= other.x || otherRight <= x || bottom <= other.y || otherBottom <= y);
  }

  bool _wouldOverlap(PlayerLayoutProfile profile, PlayerComponentType type, int x, int y, int width, int height) {
    for (final other in profile.placements) {
      if (!other.visible || other.type == type) {
        continue;
      }
      if (_rectanglesOverlap(x: x, y: y, width: width, height: height, other: other)) {
        return true;
      }
    }
    return false;
  }

  ({int x, int y})? _findFirstFreePosition(
    PlayerLayoutProfile profile,
    int width,
    int height,
    PlayerComponentType type,
    PlayerLayoutScreenSize screenSize,
  ) {
    final columns = playerGridColumnsForSize(screenSize);
    final rows = playerGridRowsForSize(screenSize);

    for (var row = 0; row <= rows - height; row++) {
      for (var col = 0; col <= columns - width; col++) {
        if (!_wouldOverlap(profile, type, col, row, width, height)) {
          return (x: col, y: row);
        }
      }
    }

    return null;
  }

  void _updateActiveProfile(PlayerLayoutScreenSize screenSize, PlayerLayoutProfile profile) {
    final currentLayout = _currentLayoutConfig();
    final normalized = normalizePlayerLayoutProfile(profile, screenSize, allowOverlap: true);
    final nextLayout = currentLayout.copyWithProfile(screenSize, normalized);

    _layoutDraft = nextLayout;
    unawaited(_persistLayoutConfig(nextLayout));
    if (mounted) {
      setState(() {});
    }
  }

  void _setComponentVisibility(
    BuildContext context,
    PlayerLayoutScreenSize screenSize,
    PlayerComponentType type,
    bool visible,
  ) {
    final profile = _activeProfileForScreen(screenSize);
    final current = profile.placementFor(type);

    var updated = current.copyWith(visible: visible);
    if (visible && !current.visible) {
      final free = _findFirstFreePosition(profile, updated.width, updated.height, type, screenSize);
      if (free == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No free grid space available for ${type.label}.')));
        return;
      }
      updated = updated.copyWith(x: free.x, y: free.y);
    }

    _updateActiveProfile(screenSize, profile.upsertPlacement(updated));
  }

  void _movePlacement(PlayerLayoutScreenSize screenSize, PlayerComponentType type, int deltaX, int deltaY) {
    final rows = playerGridRowsForSize(screenSize);
    final profile = _activeProfileForScreen(screenSize);
    final placement = profile.placementFor(type);
    final columns = playerGridColumnsForSize(screenSize);
    final constraints = playerComponentConstraintsFor(type);

    final width = placement.width.clamp(constraints.minWidth, constraints.resolvedMaxWidth(columns));
    final height = placement.height.clamp(constraints.minHeight, constraints.resolvedMaxHeight(rows));
    final nextX = (placement.x + deltaX).clamp(0, columns - width);
    final nextY = (placement.y + deltaY).clamp(0, rows - height);

    if (!_allowOverlapUnlocked && _wouldOverlap(profile, type, nextX, nextY, width, height)) {
      return;
    }

    _updateActiveProfile(screenSize, profile.upsertPlacement(placement.copyWith(x: nextX, y: nextY)));
  }

  void _resizePlacement(PlayerLayoutScreenSize screenSize, PlayerComponentType type, int deltaWidth, int deltaHeight) {
    final rows = playerGridRowsForSize(screenSize);
    final profile = _activeProfileForScreen(screenSize);
    final placement = profile.placementFor(type);
    final columns = playerGridColumnsForSize(screenSize);
    final constraints = playerComponentConstraintsFor(type);

    final nextWidth = (placement.width + deltaWidth).clamp(constraints.minWidth, constraints.resolvedMaxWidth(columns));
    final nextHeight = (placement.height + deltaHeight).clamp(
      constraints.minHeight,
      constraints.resolvedMaxHeight(rows),
    );

    final nextX = placement.x.clamp(0, columns - nextWidth);
    final nextY = placement.y.clamp(0, rows - nextHeight);

    if (!_allowOverlapUnlocked && _wouldOverlap(profile, type, nextX, nextY, nextWidth, nextHeight)) {
      return;
    }

    _updateActiveProfile(
      screenSize,
      profile.upsertPlacement(placement.copyWith(x: nextX, y: nextY, width: nextWidth, height: nextHeight)),
    );
  }

  void _resetProfileForScreen(PlayerLayoutScreenSize screenSize) {
    _updateActiveProfile(screenSize, PlayerLayoutProfile.defaults(screenSize));
  }

  Future<void> _copyLayoutConfigToClipboard(BuildContext context) async {
    final configString = _currentLayoutConfig().toSettingValue();
    await Clipboard.setData(ClipboardData(text: configString));
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Layout config copied to clipboard.')));
  }

  void _showComponentSettings(BuildContext context, PlayerLayoutScreenSize screenSize, PlayerComponentType type) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return PlayerComponentSettingsSheet(
          componentType: type,
          profile: _activeProfileForScreen(screenSize),
          onChanged: (PlayerLayoutProfile nextProfile) {
            _updateActiveProfile(screenSize, nextProfile);
          },
        );
      },
    );
  }

  IconData _iconForComponent(PlayerComponentType type) {
    switch (type) {
      case PlayerComponentType.cover:
        return Icons.image_rounded;
      case PlayerComponentType.mediaInfo:
        return Icons.text_fields_rounded;
      case PlayerComponentType.seekBar:
        return Icons.linear_scale_rounded;
      case PlayerComponentType.controls:
        return Icons.play_circle_rounded;
      case PlayerComponentType.utilities:
        return Icons.tune_rounded;
      case PlayerComponentType.subtitles:
        return Icons.subtitles_rounded;
      case PlayerComponentType.chapters:
        return Icons.menu_book_rounded;
      case PlayerComponentType.queue:
        return Icons.queue_music_rounded;
    }
  }

  bool _shouldRenderPlacement({
    required PlayerComponentPlacement placement,
    required bool hasChapters,
    required bool hasQueue,
  }) {
    if (_isEditMode) {
      return placement.visible;
    }

    if (!placement.visible) {
      return false;
    }

    if (placement.type == PlayerComponentType.chapters && !hasChapters) {
      return placement.emptyMode != PlayerCollectionEmptyMode.hide;
    }

    if (placement.type == PlayerComponentType.queue && !hasQueue) {
      return placement.emptyMode != PlayerCollectionEmptyMode.hide;
    }

    return true;
  }

  Widget _scaled(PlayerComponentPlacement placement, Widget child) {
    final scale = placement.scale.clamp(0.6, 1.8);

    if (placement.type == PlayerComponentType.seekBar && (scale - 1.0).abs() < 0.0001) {
      return Align(alignment: Alignment.bottomCenter, child: child);
    }

    if ((scale - 1.0).abs() < 0.0001) {
      return child;
    }

    final scaleX = placement.type == PlayerComponentType.seekBar ? 1.0 : scale;
    final scaleY = scale;
    final alignment = placement.type == PlayerComponentType.seekBar ? Alignment.bottomCenter : Alignment.center;

    return ClipRect(
      child: Align(
        alignment: alignment,
        child: Transform.scale(scaleX: scaleX, scaleY: scaleY, alignment: alignment, child: child),
      ),
    );
  }

  Widget _withCardStyle(PlayerComponentPlacement placement, Widget child) {
    if (!placement.cardStyle) {
      return child;
    }

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(8), child: child),
    );
  }

  Widget _buildComponent({
    required PlayerComponentPlacement placement,
    required PlayerLayoutProfile profile,
    required ABSApi? api,
    required InternalMedia media,
    required bool hasChapters,
    required PlayerTransportMode transportMode,
  }) {
    Widget content;
    switch (placement.type) {
      case PlayerComponentType.cover:
        content = PlayerCoverComponent(api: api, media: media, fitMode: placement.coverFitMode);
      case PlayerComponentType.mediaInfo:
        content = PlayerMediaInfoComponent(
          media: media,
          showAuthor: placement.showAuthor,
          showNarrator: placement.showNarrator,
          showSeries: placement.showSeries,
          textAlignMode: placement.textAlign,
          fontScale: placement.mediaInfoFontScale,
        );
      case PlayerComponentType.seekBar:
        content = PlayerSeekBarComponent(
          timePlacement: placement.seekTimePlacement,
          trackHeight: placement.seekTrackHeight,
          timeLabelFontSize: placement.seekTimeLabelFontSize,
          showCurrentChapterBetweenTimeLabels: true,
        );
      case PlayerComponentType.controls:
        content = PlayerTransportControlsComponent(transportMode: transportMode);
      case PlayerComponentType.utilities:
        content = PlayerUtilitiesComponent(
          utilityOrder: profile.utilityOrder,
          hiddenUtilities: profile.hiddenUtilities.toSet(),
          hasChapters: hasChapters,
        );
      case PlayerComponentType.subtitles:
        content = const PlayerSubtitlesComponent();
      case PlayerComponentType.chapters:
        content = PlayerChaptersComponent(emptyMode: placement.emptyMode);
      case PlayerComponentType.queue:
        content = PlayerQueueComponent(emptyMode: placement.emptyMode);
    }

    return _scaled(placement, _withCardStyle(placement, content));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(globalSettingByKeyProvider(SettingKeys.playerLayoutConfig));
    ref.watch(globalSettingByKeyProvider(SettingKeys.playerLayoutMode));
    ref.watch(globalSettingByKeyProvider(SettingKeys.playerAdaptivePreset));
    final rawCoverSize = ref.watch(globalSettingByKeyProvider(SettingKeys.playerCoverSize)).asData?.value;
    final rawImmersiveColors = ref.watch(globalSettingByKeyProvider(SettingKeys.playerImmersiveColors)).asData?.value;
    final rawFullTransportMode = ref
        .watch(globalSettingByKeyProvider(SettingKeys.fullPlayerTransportMode))
        .asData
        ?.value;
    ref.watch(globalSettingByKeyProvider(SettingKeys.fullPlayerActions));
    ref.watch(globalSettingByKeyProvider(SettingKeys.mobilePlayerLeftAction));
    ref.watch(globalSettingByKeyProvider(SettingKeys.mobilePlayerRightAction));

    _layoutDraft ??= _readLayoutConfigFromSettings();

    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final rawLayoutConfig = settingsManager.getGlobalSetting<String>(SettingKeys.playerLayoutConfig, defaultValue: '');
    final layoutMode = PlayerLayoutMode.fromSettingValue(
      settingsManager.getGlobalSetting<String>(SettingKeys.playerLayoutMode, defaultValue: ''),
      hasSavedCustomLayout: rawLayoutConfig.trim().isNotEmpty,
    );
    final adaptivePreset = PlayerAdaptivePreset.fromSettingValue(
      settingsManager.getGlobalSetting<String>(SettingKeys.playerAdaptivePreset),
    );
    final coverSize = PlayerCoverSize.fromSettingValue(rawCoverSize);
    final immersiveColors = SettingsParser.decodeValue<bool>(
      rawImmersiveColors,
      defaultSettings[SettingKeys.playerImmersiveColors] as bool,
    );
    final transportMode = PlayerTransportMode.fromSettingValue(rawFullTransportMode);
    final adaptiveActions = decodePlayerActions(
      settingsManager.getGlobalSetting<String>(SettingKeys.fullPlayerActions),
      fallback: defaultFullPlayerActions,
    );
    final mobileLeftAction = decodeOptionalPlayerAction(
      settingsManager.getGlobalSetting<String>(SettingKeys.mobilePlayerLeftAction),
      fallback: defaultMobilePlayerLeftAction,
    );
    final mobileRightAction = decodeOptionalPlayerAction(
      settingsManager.getGlobalSetting<String>(SettingKeys.mobilePlayerRightAction),
      fallback: defaultMobilePlayerRightAction,
    );
    final isCustomMode = layoutMode == PlayerLayoutMode.custom;
    final isEditMode = isCustomMode && _isEditMode;
    final castSupported = ChromeCastService.isSupportedPlatform;
    final isMobile = context.isMobile;
    final activeScreenSize = PlayerLayoutScreenSize.fromBreakpoint(context.breakpoint);
    final activeProfile = _activeProfileForScreen(activeScreenSize);
    final activeSeekBarPlacement = activeProfile.placementFor(PlayerComponentType.seekBar);
    final showTimesUnderAppBar =
        isCustomMode &&
        !isEditMode &&
        activeSeekBarPlacement.visible &&
        activeSeekBarPlacement.seekTimePlacement == PlayerSeekTimePlacement.underAppBar;
    final hiddenComponents = activeProfile.placements
        .where((placement) => !placement.visible)
        .map((placement) => placement.type)
        .toList(growable: false);

    final enableSwipeToMinimize = isMobile && !isEditMode;
    final headerDragSurface = enableSwipeToMinimize
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onVerticalDragStart: _handleVerticalDragStart,
            onVerticalDragUpdate: _handleVerticalDragUpdate,
            onVerticalDragEnd: _handleVerticalDragEnd,
          )
        : null;

    final appBar = isEditMode
        ? AppBar(
            title: Text('Edit ${activeScreenSize.label} Layout'),
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () {
                setState(() {
                  _isEditMode = false;
                });
              },
              tooltip: 'Exit edit mode',
            ),
            actions: <Widget>[
              PopupMenuButton<PlayerComponentType>(
                enabled: hiddenComponents.isNotEmpty,
                tooltip: 'Add component',
                icon: const Icon(Icons.add_box_rounded),
                onSelected: (PlayerComponentType type) {
                  _setComponentVisibility(context, activeScreenSize, type, true);
                },
                itemBuilder: (BuildContext context) {
                  if (hiddenComponents.isEmpty) {
                    return const <PopupMenuEntry<PlayerComponentType>>[];
                  }

                  return hiddenComponents
                      .map(
                        (type) => PopupMenuItem<PlayerComponentType>(
                          value: type,
                          child: Row(
                            children: <Widget>[
                              Icon(_iconForComponent(type), size: 18),
                              const SizedBox(width: 10),
                              Text(type.label),
                            ],
                          ),
                        ),
                      )
                      .toList(growable: false);
                },
              ),
              IconButton(
                icon: Icon(_allowOverlapUnlocked ? Icons.lock_open_rounded : Icons.lock_rounded),
                tooltip: _allowOverlapUnlocked ? 'Unlocked overlap mode' : 'Locked mode (prevent overlap)',
                onPressed: () {
                  setState(() {
                    _allowOverlapUnlocked = !_allowOverlapUnlocked;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.bug_report_rounded),
                tooltip: 'Copy layout config',
                onPressed: () {
                  _copyLayoutConfigToClipboard(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.restart_alt_rounded),
                tooltip: 'Reset active screen layout',
                onPressed: () {
                  _resetProfileForScreen(activeScreenSize);
                },
              ),
              IconButton(
                icon: const Icon(Icons.done_rounded),
                tooltip: 'Done editing',
                onPressed: () {
                  setState(() {
                    _isEditMode = false;
                  });
                },
              ),
            ],
          )
        : AppBar(
            title: Text(isCustomMode ? 'Custom player' : 'Now playing'),
            leading: isMobile
                ? IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    onPressed: _closePlayerIfOpen,
                    tooltip: 'Minimize player',
                  )
                : null,
            flexibleSpace: headerDragSurface,
            backgroundColor: isCustomMode ? null : Colors.transparent,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            bottom: showTimesUnderAppBar
                ? const PreferredSize(preferredSize: Size.fromHeight(26), child: _AppBarSeekTimesStrip())
                : null,
            actions: <Widget>[
              if (isCustomMode)
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    setState(() {
                      _isEditMode = true;
                    });
                  },
                  tooltip: 'Enter layout edit mode',
                ),
              IconButton(
                icon: const Icon(Icons.tune_rounded),
                onPressed: () => _showQuickSettings(context),
                tooltip: 'Quick Settings',
              ),
              if (!isMobile && castSupported) const CastButton(),
              if (isCustomMode) const StopButton(),
              PopupMenuButton<_PlayerAppBarMenuAction>(
                tooltip: 'More options',
                icon: const Icon(Icons.more_vert),
                onSelected: (_PlayerAppBarMenuAction action) async {
                  await _handleAppBarMenuAction(context, action);
                },
                itemBuilder: (BuildContext context) {
                  return _buildOverflowMenuItems(isMobile: isMobile, castSupported: castSupported);
                },
              ),
            ],
          );

    final ABSApi? api = ref.watch(absApiProvider);
    final systemNavigationColor = !isCustomMode && _adaptiveNavigationBarColor != null
        ? _adaptiveNavigationBarColor!
        : Theme.of(context).colorScheme.surfaceContainer;
    final navigationBarBrightness = ThemeData.estimateBrightnessForColor(systemNavigationColor);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: navigationBarBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isCustomMode ? systemNavigationColor : Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: navigationBarBrightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: systemNavigationColor,
        extendBodyBehindAppBar: !isCustomMode,
        appBar: appBar,
        body: PlayerKeyboardShortcuts(
          child: StreamBuilder<bool>(
            stream: audioHandler.queueTransitionLoadingStream,
            initialData: audioHandler.queueTransitionLoading,
            builder: (BuildContext context, AsyncSnapshot<bool> transitionSnapshot) {
              final isTransitionLoading = transitionSnapshot.data == true;

              return StreamBuilder<InternalMedia?>(
                stream: audioHandler.mediaItemStream.stream,
                initialData: audioHandler.currentMediaItem,
                builder: (BuildContext context, AsyncSnapshot<InternalMedia?> mediaSnapshot) {
                  if (mediaSnapshot.connectionState == ConnectionState.waiting && mediaSnapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final media = mediaSnapshot.data;
                  if (media == null) {
                    if (isTransitionLoading) {
                      return const _PlayerTransitionLoadingView();
                    }

                    _scheduleClosePlayerIfOpen();
                    return const SizedBox.shrink();
                  }

                  return StreamBuilder<PlayerQueueSnapshot>(
                    stream: audioHandler.queueSnapshotStream,
                    initialData: audioHandler.queueSnapshot,
                    builder: (BuildContext context, AsyncSnapshot<PlayerQueueSnapshot> queueSnapshot) {
                      final queueState = queueSnapshot.data ?? const PlayerQueueSnapshot();
                      final screenSize = PlayerLayoutScreenSize.fromBreakpoint(context.breakpoint);
                      final profile = _activeProfileForScreen(screenSize);
                      final hasChapters = media.chapters?.isNotEmpty == true;
                      final hasQueue = queueState.entries.isNotEmpty;

                      if (!isCustomMode) {
                        return PlayerAdaptiveView(
                          api: api,
                          media: media,
                          hasChapters: hasChapters,
                          preset: adaptivePreset,
                          transportMode: transportMode,
                          actions: adaptiveActions,
                          mobileLeftAction: mobileLeftAction,
                          mobileRightAction: mobileRightAction,
                          coverSize: coverSize,
                          immersiveColors: immersiveColors,
                          onNavigationBarColorChanged: _updateAdaptiveNavigationBarColor,
                        );
                      }

                      return SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.all(context.isMobile ? 2 : 4),
                          child: PlayerGridCanvas(
                            screenSize: screenSize,
                            profile: profile,
                            editMode: isEditMode,
                            isPlacementVisible: (PlayerComponentPlacement placement) {
                              return _shouldRenderPlacement(
                                placement: placement,
                                hasChapters: hasChapters,
                                hasQueue: hasQueue,
                              );
                            },
                            componentBuilder: (PlayerComponentPlacement placement) {
                              return _buildComponent(
                                placement: placement,
                                profile: profile,
                                api: api,
                                media: media,
                                hasChapters: hasChapters,
                                transportMode: transportMode,
                              );
                            },
                            onMovePlacement: isEditMode
                                ? (PlayerComponentType type, int deltaX, int deltaY) {
                                    _movePlacement(screenSize, type, deltaX, deltaY);
                                  }
                                : null,
                            onResizePlacement: isEditMode
                                ? (PlayerComponentType type, int deltaWidth, int deltaHeight) {
                                    _resizePlacement(screenSize, type, deltaWidth, deltaHeight);
                                  }
                                : null,
                            onOpenSettings: isEditMode
                                ? (PlayerComponentType type) {
                                    _showComponentSettings(context, screenSize, type);
                                  }
                                : null,
                            onHidePlacement: isEditMode
                                ? (PlayerComponentType type) {
                                    _setComponentVisibility(context, screenSize, type, false);
                                  }
                                : null,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
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
        children: <Widget>[
          const RepaintBoundary(
            child: SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.6)),
          ),
          const SizedBox(height: 10),
          Text('Loading next item...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _AppBarSeekTimesStrip extends ConsumerWidget {
  const _AppBarSeekTimesStrip();

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    }
    return duration.toPlaybackTimeString();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final showRemainingSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.playerShowRemainingTime));
    final showRemaining = showRemainingSetting.asData?.value == 'true';

    return SizedBox(
      height: 26,
      child: StreamBuilder<Duration>(
        stream: audioHandler.durationStream,
        initialData: Duration.zero,
        builder: (BuildContext context, AsyncSnapshot<Duration> durationSnapshot) {
          final total = durationSnapshot.data ?? Duration.zero;

          return StreamBuilder<Duration>(
            stream: audioHandler.positionStream,
            initialData: audioHandler.position,
            builder: (BuildContext context, AsyncSnapshot<Duration> positionSnapshot) {
              final position = positionSnapshot.data ?? Duration.zero;
              final clampedPosition = position > total ? total : position;

              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_formatDuration(clampedPosition), style: theme.textTheme.labelSmall),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(settingsManagerProvider.notifier)
                            .setGlobalSetting<bool>(SettingKeys.playerShowRemainingTime, !showRemaining);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                        child: Text(
                          showRemaining ? '-${_formatDuration(total - clampedPosition)}' : _formatDuration(total),
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
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
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Queue', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
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
      children: <Widget>[
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
    final rawSeekBarMode = ref.watch(globalSettingByKeyProvider(SettingKeys.playerSeekBarMode)).asData?.value;
    final rawLayoutMode = ref.watch(globalSettingByKeyProvider(SettingKeys.playerLayoutMode)).asData?.value;
    final rawAdaptivePreset = ref.watch(globalSettingByKeyProvider(SettingKeys.playerAdaptivePreset)).asData?.value;
    final rawCoverSize = ref.watch(globalSettingByKeyProvider(SettingKeys.playerCoverSize)).asData?.value;
    final rawImmersiveColors = ref.watch(globalSettingByKeyProvider(SettingKeys.playerImmersiveColors)).asData?.value;
    final rawLayoutConfig = ref.watch(globalSettingByKeyProvider(SettingKeys.playerLayoutConfig)).asData?.value;
    final settingsManager = ref.read(settingsManagerProvider.notifier);
    final selectedMode = PlayerSeekBarMode.fromSettingValue(rawSeekBarMode);
    final layoutMode = PlayerLayoutMode.fromSettingValue(
      rawLayoutMode,
      hasSavedCustomLayout: rawLayoutConfig?.trim().isNotEmpty == true,
    );
    final preset = PlayerAdaptivePreset.fromSettingValue(rawAdaptivePreset);
    final coverSize = PlayerCoverSize.fromSettingValue(rawCoverSize);
    final immersiveColors = SettingsParser.decodeValue<bool>(
      rawImmersiveColors,
      defaultSettings[SettingKeys.playerImmersiveColors] as bool,
    );

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.88),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 2, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Quick Player Settings', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text('Layout', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<PlayerLayoutMode>(
                segments: const <ButtonSegment<PlayerLayoutMode>>[
                  ButtonSegment<PlayerLayoutMode>(
                    value: PlayerLayoutMode.adaptive,
                    icon: Icon(Icons.auto_awesome_mosaic_rounded),
                    label: Text('Adaptive'),
                  ),
                  ButtonSegment<PlayerLayoutMode>(
                    value: PlayerLayoutMode.custom,
                    icon: Icon(Icons.dashboard_customize_rounded),
                    label: Text('Custom'),
                  ),
                ],
                selected: <PlayerLayoutMode>{layoutMode},
                onSelectionChanged: (selection) {
                  settingsManager.setGlobalSetting<String>(SettingKeys.playerLayoutMode, selection.first.name);
                },
              ),
              if (layoutMode == PlayerLayoutMode.adaptive) ...<Widget>[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: PlayerAdaptivePreset.values
                      .map((candidate) {
                        return ChoiceChip(
                          selected: candidate == preset,
                          label: Text(candidate.label),
                          onSelected: (selected) {
                            if (selected) {
                              settingsManager.setGlobalSetting<String>(
                                SettingKeys.playerAdaptivePreset,
                                candidate.name,
                              );
                            }
                          },
                        );
                      })
                      .toList(growable: false),
                ),
                const SizedBox(height: 12),
                Text(
                  'Cover size',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PlayerCoverSize.values
                      .map((candidate) {
                        return ChoiceChip(
                          selected: candidate == coverSize,
                          label: Text(candidate.label),
                          onSelected: (selected) {
                            if (selected) {
                              settingsManager.setGlobalSetting<String>(SettingKeys.playerCoverSize, candidate.name);
                            }
                          },
                        );
                      })
                      .toList(growable: false),
                ),
              ],
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Immersive player colors'),
                value: immersiveColors,
                onChanged: (value) {
                  settingsManager.setGlobalSetting<bool>(SettingKeys.playerImmersiveColors, value);
                },
              ),
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
                children: PlayerSeekBarMode.values
                    .map((PlayerSeekBarMode mode) {
                      final selected = mode == selectedMode;
                      return ChoiceChip(
                        label: Text(mode.label),
                        selected: selected,
                        onSelected: (bool value) {
                          if (!value) {
                            return;
                          }
                          ref
                              .read(settingsManagerProvider.notifier)
                              .setGlobalSetting<String>(SettingKeys.playerSeekBarMode, mode.name);
                        },
                      );
                    })
                    .toList(growable: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
