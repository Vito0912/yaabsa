import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/player/common/chapter_text.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
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
  static const double _mobileCoverSize = 44;
  static const double _mobileCoverRadius = 6;
  static const double _desktopCoverWidth = 62;
  static const double _desktopCoverRadius = 8;
  static const double _coverSpacing = 10;
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

  Widget _buildControlsAndSeekBar({Widget? leading}) {
    final showSkipInsteadOfFastForwardAsync = ref.watch(
      globalSettingByKeyProvider(SettingKeys.showSkipInsteadOfFastForward),
    );
    final showSkipInsteadOfFastForward = showSkipInsteadOfFastForwardAsync.value == 'true';

    return StreamBuilder<InternalMedia?>(
      stream: audioHandler.mediaItemStream,
      initialData: audioHandler.currentMediaItem,
      builder: (context, mediaSnapshot) {
        final currentMedia = mediaSnapshot.data;
        final chaptersExist =
            currentMedia != null && currentMedia.chapters != null && currentMedia.chapters!.isNotEmpty;

        return StreamBuilder<PlayerQueueSnapshot>(
          stream: audioHandler.queueSnapshotStream,
          initialData: audioHandler.queueSnapshot,
          builder: (context, queueSnapshot) {
            final queueExists = queueSnapshot.data?.entries.isNotEmpty == true;
            final hasChaptersOrQueue = chaptersExist || queueExists;
            final useSkip = showSkipInsteadOfFastForward && hasChaptersOrQueue;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (leading != null) ...[Padding(padding: const EdgeInsets.only(right: 8), child: leading)],
                    if (useSkip) ...const [
                      SkipButton(previous: true),
                      ControlButton(),
                      SkipButton(previous: false),
                    ] else ...const [JumpButton(rewind: true), ControlButton(), JumpButton(rewind: false)],
                    const SizedBox(width: 6),
                    const Expanded(child: ChapterText()),
                    const StopButton(),
                  ],
                ),
                const SizedBox(height: 4),
                MouseRegion(
                  onEnter: (_) => _setSeekBarHovered(true),
                  onExit: (_) => _setSeekBarHovered(false),
                  child: const SeekBar(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildReadyContent(BuildContext context) {
    final coverUri = audioHandler.currentMediaItem?.cover;
    final requestHeaders = audioHandler.currentRequestHeaders;

    if (context.isMobile) {
      return _buildControlsAndSeekBar(
        leading: SizedBox(
          width: _mobileCoverSize,
          height: _mobileCoverSize,
          child: _PlayBarCover(coverUri: coverUri, borderRadius: _mobileCoverRadius, requestHeaders: requestHeaders),
        ),
      );
    }

    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: SizedBox(
            width: _desktopCoverWidth,
            child: _PlayBarCover(
              coverUri: coverUri,
              borderRadius: widget.attachedToBottom ? 0 : _desktopCoverRadius,
              requestHeaders: requestHeaders,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: _desktopCoverWidth + _coverSpacing),
          child: _buildControlsAndSeekBar(),
        ),
      ],
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
            final baseColor = colorScheme.surface;
            final hoveredColor = Color.alphaBlend(colorScheme.onSurface.withValues(alpha: 0.06), baseColor);
            final borderRadius = widget.attachedToBottom ? BorderRadius.zero : BorderRadius.circular(14);
            final outerPadding = widget.attachedToBottom
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 8, vertical: 6);
            final innerPadding = widget.attachedToBottom
                ? const EdgeInsets.fromLTRB(12, 8, 12, 10)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);
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
                        ? _buildReadyContent(context)
                        : snapshot != null
                        ? _buildIdleContent(context, snapshot)
                        : const SizedBox.shrink();

                    return SafeArea(
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
                                duration: const Duration(milliseconds: 160),
                                curve: Curves.easeOut,
                                padding: innerPadding,
                                decoration: BoxDecoration(
                                  color: (_isHovered && !_isSeekBarHovered) ? hoveredColor : baseColor,
                                  borderRadius: borderRadius,
                                  border: border,
                                ),
                                child: content,
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
  }
}

class _PlayBarCover extends StatelessWidget {
  const _PlayBarCover({required this.coverUri, required this.borderRadius, required this.requestHeaders});

  final Uri? coverUri;
  final double borderRadius;
  final Map<String, String> requestHeaders;

  ImageProvider<Object>? _imageProvider() {
    final uri = coverUri;
    if (uri == null) {
      return null;
    }

    if (uri.scheme == 'file') {
      return FileImage(File(uri.toFilePath()));
    }

    return NetworkImage(uri.toString(), headers: requestHeaders.isEmpty ? null : requestHeaders);
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
