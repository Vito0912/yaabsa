import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/common/cover_placeholder.dart';
import 'package:yaabsa/components/player/common/chapter_text.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
import 'package:yaabsa/util/globals.dart';

class PlayBar extends StatefulWidget {
  const PlayBar({super.key, this.includeBottomSafeArea = true, this.attachedToBottom = false});

  final bool includeBottomSafeArea;
  final bool attachedToBottom;

  @override
  State<PlayBar> createState() => _PlayBarState();
}

class _PlayBarState extends State<PlayBar> {
  static const double _mobileCoverSize = 44;
  static const double _mobileCoverRadius = 6;
  static const double _desktopCoverWidth = 62;
  static const double _desktopCoverRadius = 8;
  static const double _coverSpacing = 10;

  bool _isHovered = false;
  bool _isSeekBarHovered = false;

  void _setSeekBarHovered(bool isHovered) {
    if (_isSeekBarHovered == isHovered) {
      return;
    }
    setState(() => _isSeekBarHovered = isHovered);
  }

  Widget _buildControlsAndSeekBar({Widget? leading}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (leading != null) ...[Padding(padding: const EdgeInsets.only(right: 8), child: leading)],
            const JumpButton(rewind: true),
            const ControlButton(),
            const JumpButton(rewind: false),
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
  }

  Widget _buildReadyContent(BuildContext context) {
    final coverUri = audioHandler.currentMediaItem?.cover;

    if (context.isMobile) {
      return _buildControlsAndSeekBar(
        leading: SizedBox(
          width: _mobileCoverSize,
          height: _mobileCoverSize,
          child: _PlayBarCover(coverUri: coverUri, borderRadius: _mobileCoverRadius),
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
            child: _PlayBarCover(coverUri: coverUri, borderRadius: widget.attachedToBottom ? 0 : _desktopCoverRadius),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: _desktopCoverWidth + _coverSpacing),
          child: _buildControlsAndSeekBar(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: audioHandler.shouldShowPlayer,
      initialData: audioHandler.player.playerState.playing,
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

            return SafeArea(
              top: false,
              bottom: widget.includeBottomSafeArea,
              child: Padding(
                padding: outerPadding,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: borderRadius,
                  child: InkWell(
                    onTap: () => context.push('/player'),
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
                      child: isTransitionLoading
                          ? const _PlayBarTransitionLoadingContent()
                          : _buildReadyContent(context),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PlayBarCover extends StatelessWidget {
  const _PlayBarCover({required this.coverUri, required this.borderRadius});

  final Uri? coverUri;
  final double borderRadius;

  ImageProvider<Object>? _imageProvider() {
    final uri = coverUri;
    if (uri == null) {
      return null;
    }

    if (uri.scheme == 'file') {
      return FileImage(File(uri.toFilePath()));
    }

    return NetworkImage(uri.toString());
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

class _PlayBarTransitionLoadingContent extends StatelessWidget {
  const _PlayBarTransitionLoadingContent();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.2)),
        SizedBox(width: 10),
        Expanded(child: Text('Loading next item...', maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
