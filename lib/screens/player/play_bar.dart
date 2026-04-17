import 'package:yaabsa/components/player/common/chapter_text.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayBar extends StatefulWidget {
  const PlayBar({super.key});

  @override
  State<PlayBar> createState() => _PlayBarState();
}

class _PlayBarState extends State<PlayBar> {
  bool _isHovered = false;
  bool _isSeekBarHovered = false;

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

        final colorScheme = Theme.of(context).colorScheme;
        final baseColor = colorScheme.surface;
        final hoveredColor = Color.alphaBlend(colorScheme.onSurface.withValues(alpha: 0.06), baseColor);

        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () => context.push('/player'),
                borderRadius: BorderRadius.circular(14),
                mouseCursor: SystemMouseCursors.click,
                onHover: (hovering) {
                  if (_isHovered == hovering) return;
                  setState(() => _isHovered = hovering);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: (_isHovered && !_isSeekBarHovered) ? hoveredColor : baseColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          JumpButton(rewind: true),
                          ControlButton(),
                          JumpButton(rewind: false),
                          SizedBox(width: 6),
                          Expanded(child: ChapterText()),
                          StopButton(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      MouseRegion(
                        onEnter: (_) {
                          if (_isSeekBarHovered) return;
                          setState(() => _isSeekBarHovered = true);
                        },
                        onExit: (_) {
                          if (!_isSeekBarHovered) return;
                          setState(() => _isSeekBarHovered = false);
                        },
                        child: SeekBar(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
