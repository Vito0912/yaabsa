import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/common/cover_zoom_view.dart';
import 'package:yaabsa/components/player/common/cover_palette_builder.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
import 'package:yaabsa/screens/player/components/player_action_bar.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';
import 'package:yaabsa/screens/player/play_bar_idle_content.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/globals.dart';

class PlayBar extends ConsumerStatefulWidget {
  const PlayBar({super.key, this.includeBottomSafeArea = true, this.attachedToBottom = false});

  final bool includeBottomSafeArea;
  final bool attachedToBottom;

  @override
  ConsumerState<PlayBar> createState() => _PlayBarState();
}

class _PlayBarState extends ConsumerState<PlayBar> {
  static const double _mobileCoverSize = 52;
  static const double _mobileCoverRadius = 12;
  static const double _desktopCoverWidth = 56;
  static const double _desktopCoverRadius = 12;
  static const double _coverSpacing = 12;
  static const double _expandDragDistanceThreshold = 44;
  static const double _expandDragVelocityThreshold = 420;

  bool _isHovered = false;
  bool _isSeekBarHovered = false;
  double _verticalDragDelta = 0;

  void _openFullPlayer() {
    context.push('/player');
  }

  void _handleVerticalDragStart(DragStartDetails details) {
    _verticalDragDelta = 0;
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    _verticalDragDelta += details.delta.dy;
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final draggedUpEnough = _verticalDragDelta <= -_expandDragDistanceThreshold;
    final flungUp = velocity <= -_expandDragVelocityThreshold;
    _verticalDragDelta = 0;

    if (draggedUpEnough || flungUp) {
      _openFullPlayer();
    }
  }

  void _setSeekBarHovered(bool isHovered) {
    if (_isSeekBarHovered == isHovered) {
      return;
    }
    setState(() => _isSeekBarHovered = isHovered);
  }

  Widget _buildControlsAndSeekBar({
    Widget? leading,
    required PlayerTransportMode transportMode,
    required List<PlayerActionType> actions,
    required bool mobile,
  }) {
    return StreamBuilder<InternalMedia?>(
      stream: audioHandler.mediaItemStream,
      initialData: audioHandler.currentMediaItem,
      builder: (context, mediaSnapshot) {
        final currentMedia = mediaSnapshot.data;
        final chaptersExist =
            currentMedia != null && currentMedia.chapters != null && currentMedia.chapters!.isNotEmpty;

        final metadata = Row(
          children: <Widget>[
            if (leading != null) ...<Widget>[
              Padding(
                padding: const EdgeInsets.only(right: _coverSpacing),
                child: leading,
              ),
            ],
            Expanded(child: _MiniPlayerMetadata(media: currentMedia)),
          ],
        );
        final compactDesktop = !mobile && MediaQuery.sizeOf(context).width < 1100;
        final visibleDesktopActions = compactDesktop ? actions.take(2).toList(growable: false) : actions;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(flex: mobile ? 1 : 3, child: metadata),
                if (!mobile) const SizedBox(width: 24),
                _MiniTransportControls(mode: transportMode, compact: mobile),
                if (mobile)
                  IconButton(
                    tooltip: 'More player controls',
                    onPressed: () => _showMiniActionsSheet(context, actions: actions, hasChapters: chaptersExist),
                    icon: const Icon(Icons.more_horiz_rounded),
                  )
                else ...<Widget>[
                  const SizedBox(width: 18),
                  PlayerActionBar(actions: visibleDesktopActions, hasChapters: chaptersExist, spacing: 6),
                  if (visibleDesktopActions.length != actions.length)
                    IconButton(
                      tooltip: 'More player controls',
                      onPressed: () => _showMiniActionsSheet(
                        context,
                        actions: actions.skip(visibleDesktopActions.length).toList(growable: false),
                        hasChapters: chaptersExist,
                      ),
                      icon: const Icon(Icons.more_horiz_rounded),
                    ),
                  const SizedBox(width: 6),
                  const StopButton(),
                ],
              ],
            ),
            const SizedBox(height: 5),
            MouseRegion(
              onEnter: (_) => _setSeekBarHovered(true),
              onExit: (_) => _setSeekBarHovered(false),
              child: const SeekBar(
                trackHeight: 4,
                timeLabelsBelow: true,
                timeLabelFontSize: 11,
                showCurrentChapterBetweenTimeLabels: true,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMiniActionsSheet(
    BuildContext context, {
    required List<PlayerActionType> actions,
    required bool hasChapters,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (actions.isNotEmpty) ...<Widget>[
                PlayerActionBar(actions: actions, hasChapters: hasChapters, showLabels: true, spacing: 8),
                const SizedBox(height: 12),
              ],
              ListTile(
                leading: const Icon(Icons.stop_circle_rounded),
                title: const Text('Stop playback'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                tileColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                onTap: () {
                  Navigator.of(context).pop();
                  audioHandler.stop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReadyContent(
    BuildContext context, {
    required PlayerTransportMode transportMode,
    required List<PlayerActionType> actions,
  }) {
    final coverUri = libraryItemCoverUri(audioHandler.currentMediaItem?.cover);
    final requestHeaders = audioHandler.currentRequestHeaders;

    if (context.isMobile) {
      return _buildControlsAndSeekBar(
        transportMode: transportMode,
        actions: actions,
        mobile: true,
        leading: SizedBox(
          width: _mobileCoverSize,
          height: _mobileCoverSize,
          child: _PlayBarCover(coverUri: coverUri, borderRadius: _mobileCoverRadius, requestHeaders: requestHeaders),
        ),
      );
    }

    return _buildControlsAndSeekBar(
      transportMode: transportMode,
      actions: actions,
      mobile: false,
      leading: SizedBox(
        width: _desktopCoverWidth,
        height: _desktopCoverWidth,
        child: _PlayBarCover(coverUri: coverUri, borderRadius: _desktopCoverRadius, requestHeaders: requestHeaders),
      ),
    );
  }

  Widget _buildIdleContent(BuildContext context, LastPlayedMiniPlayerSnapshot snapshot) {
    return PlayBarIdleContent(
      snapshot: snapshot,
      isMobile: context.isMobile,
      requestHeaders: audioHandler.currentRequestHeaders,
      attachedToBottom: widget.attachedToBottom,
      mobileCoverSize: _mobileCoverSize,
      mobileCoverRadius: _mobileCoverRadius,
      desktopCoverWidth: _desktopCoverWidth,
      desktopCoverRadius: _desktopCoverRadius,
    );
  }

  Widget _buildTransitionLoadingContent(BuildContext context) {
    final isMobile = context.isMobile;
    final coverSize = isMobile ? _mobileCoverSize : _desktopCoverWidth;
    final coverRadius = isMobile ? _mobileCoverRadius : (widget.attachedToBottom ? 0.0 : _desktopCoverRadius);

    return SizedBox(
      height: coverSize,
      child: Row(
        children: [
          SizedBox(
            width: coverSize,
            height: coverSize,
            child: CoverPlaceholder(borderRadius: coverRadius),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Loading next item...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rawTransportMode = ref.watch(globalSettingByKeyProvider(SettingKeys.miniPlayerTransportMode)).asData?.value;
    final rawActions = ref.watch(globalSettingByKeyProvider(SettingKeys.miniPlayerActions)).asData?.value;
    final rawImmersiveColors = ref.watch(globalSettingByKeyProvider(SettingKeys.playerImmersiveColors)).asData?.value;
    final transportMode = PlayerTransportMode.fromSettingValue(rawTransportMode);
    final actions = decodePlayerActions(rawActions, fallback: defaultMiniPlayerActions);
    final immersiveColors = SettingsParser.decodeValue<bool>(
      rawImmersiveColors,
      defaultSettings[SettingKeys.playerImmersiveColors] as bool,
    );

    return StreamBuilder<bool>(
      stream: audioHandler.shouldShowPlayer,
      initialData: audioHandler.shouldShowPlayerNow,
      builder: (context, snapshot) {
        final showPlayer = snapshot.data == true;
        if (!showPlayer) {
          return const SizedBox.shrink();
        }

        return StreamBuilder<bool>(
          stream: audioHandler.queueTransitionLoadingStream,
          initialData: audioHandler.queueTransitionLoading,
          builder: (context, loadingSnapshot) {
            final isTransitionLoading = loadingSnapshot.data == true && audioHandler.currentMediaItem == null;

            final colorScheme = Theme.of(context).colorScheme;
            final borderRadius = widget.attachedToBottom
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(20);
            final outerPadding = widget.attachedToBottom
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
            final innerPadding = widget.attachedToBottom
                ? context.isMobile
                      ? const EdgeInsets.fromLTRB(10, 10, 10, 1)
                      : const EdgeInsets.fromLTRB(10, 7, 10, 6)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
            final border = widget.attachedToBottom
                ? Border(top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.6)))
                : Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.6));

            return StreamBuilder<LastPlayedMiniPlayerSnapshot?>(
              stream: audioHandler.lastPlayedMiniPlayerSnapshotStream,
              initialData: audioHandler.lastPlayedMiniPlayerSnapshot,
              builder: (context, lastPlayedSnapshot) {
                return StreamBuilder<InternalMedia?>(
                  stream: audioHandler.mediaItemStream,
                  initialData: audioHandler.currentMediaItem,
                  builder: (context, mediaSnapshot) {
                    final currentMedia = mediaSnapshot.data;
                    final snapshot = lastPlayedSnapshot.data;
                    final isIdleMiniPlayer = !isTransitionLoading && currentMedia == null && snapshot != null;
                    final content = isTransitionLoading
                        ? _buildTransitionLoadingContent(context)
                        : currentMedia != null
                        ? _buildReadyContent(context, transportMode: transportMode, actions: actions)
                        : snapshot != null
                        ? _buildIdleContent(context, snapshot)
                        : const SizedBox.shrink();

                    return CoverPaletteBuilder(
                      coverUri: immersiveColors ? libraryItemCoverUri(currentMedia?.cover ?? snapshot?.cover) : null,
                      requestHeaders: audioHandler.currentRequestHeaders,
                      builder: (context, palette) {
                        final dark = Theme.of(context).brightness == Brightness.dark;
                        final gradientStart = immersiveColors
                            ? Color.alphaBlend(
                                (palette?.primary ?? colorScheme.primaryContainer).withValues(
                                  alpha: dark ? 0.22 : 0.12,
                                ),
                                colorScheme.surfaceContainer,
                              )
                            : colorScheme.surfaceContainer;
                        final gradientEnd = immersiveColors
                            ? Color.alphaBlend(
                                (palette?.secondary ?? colorScheme.secondaryContainer).withValues(
                                  alpha: dark ? 0.2 : 0.1,
                                ),
                                colorScheme.surfaceContainer,
                              )
                            : colorScheme.surfaceContainer;
                        final baseColor = Color.lerp(gradientStart, gradientEnd, 0.5)!;
                        final gradient = LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[gradientStart, gradientEnd],
                        );
                        final hoveredGradient = LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color.alphaBlend(colorScheme.onSurface.withValues(alpha: 0.06), gradientStart),
                            Color.alphaBlend(colorScheme.onSurface.withValues(alpha: 0.06), gradientEnd),
                          ],
                        );
                        final paintsSystemInset = context.isMobile && widget.includeBottomSafeArea;
                        final navigationBarBrightness = ThemeData.estimateBrightnessForColor(baseColor);
                        return AnnotatedRegion<SystemUiOverlayStyle>(
                          value: SystemUiOverlayStyle(
                            systemNavigationBarColor: Colors.transparent,
                            systemNavigationBarDividerColor: Colors.transparent,
                            systemNavigationBarIconBrightness: navigationBarBrightness == Brightness.dark
                                ? Brightness.light
                                : Brightness.dark,
                            systemNavigationBarContrastEnforced: false,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOut,
                            decoration: BoxDecoration(gradient: paintsSystemInset ? gradient : null),
                            child: SafeArea(
                              top: false,
                              left: !widget.attachedToBottom,
                              right: !widget.attachedToBottom,
                              bottom: widget.includeBottomSafeArea,
                              child: Padding(
                                padding: outerPadding,
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: borderRadius,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onVerticalDragStart: _handleVerticalDragStart,
                                    onVerticalDragUpdate: _handleVerticalDragUpdate,
                                    onVerticalDragEnd: _handleVerticalDragEnd,
                                    child: InkWell(
                                      onTap: isIdleMiniPlayer
                                          ? () {
                                              audioHandler.play();
                                            }
                                          : _openFullPlayer,
                                      borderRadius: borderRadius,
                                      mouseCursor: SystemMouseCursors.click,
                                      onHover: (hovering) {
                                        if (_isHovered == hovering) return;
                                        setState(() => _isHovered = hovering);
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 260),
                                        curve: Curves.easeOut,
                                        padding: innerPadding,
                                        decoration: BoxDecoration(
                                          color: paintsSystemInset && _isHovered && !_isSeekBarHovered
                                              ? colorScheme.onSurface.withValues(alpha: 0.06)
                                              : null,
                                          gradient: paintsSystemInset
                                              ? null
                                              : (_isHovered && !_isSeekBarHovered)
                                              ? hoveredGradient
                                              : gradient,
                                          borderRadius: borderRadius,
                                          border: border,
                                        ),
                                        child: content,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
    );
  }
}

class _MiniTransportControls extends StatelessWidget {
  const _MiniTransportControls({required this.mode, required this.compact});

  final PlayerTransportMode mode;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final showJump = mode != PlayerTransportMode.skip;
    final showSkip = mode != PlayerTransportMode.jump;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 0,
      runSpacing: 0,
      children: <Widget>[
        if (showSkip && (!compact || !showJump)) const SkipButton(previous: true),
        if (showJump) const JumpButton(rewind: true),
        const ControlButton(),
        if (showJump) const JumpButton(rewind: false),
        if (showSkip && (!compact || !showJump)) const SkipButton(previous: false),
      ],
    );
  }
}

class _MiniPlayerMetadata extends StatelessWidget {
  const _MiniPlayerMetadata({required this.media});

  final InternalMedia? media;

  @override
  Widget build(BuildContext context) {
    final title = media?.title ?? 'Now playing';
    final author = media?.author?.trim();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (author?.isNotEmpty == true)
          Text(
            author!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }
}

class _PlayBarCover extends StatelessWidget {
  const _PlayBarCover({required this.coverUri, required this.borderRadius, required this.requestHeaders});

  final Uri? coverUri;
  final double borderRadius;
  final Map<String, String> requestHeaders;

  ImageProvider<Object>? _imageProvider() {
    return coverImageProviderFromUri(coverUri, requestHeaders: requestHeaders);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageProvider();
    if (imageProvider == null) {
      return CoverPlaceholder(borderRadius: borderRadius);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image(
        image: imageProvider,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
        errorBuilder: (context, error, stackTrace) => CoverPlaceholder(borderRadius: borderRadius),
      ),
    );
  }
}
