import 'package:yaabsa/components/player/common/chapter_text.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/components/player/common/stop_button.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlayBar extends StatelessWidget {
  const PlayBar({super.key});

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

        return SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => context.push('/player'),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: ChapterText()),
                      StopButton(),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      JumpButton(rewind: true),
                      ControlButton(),
                      JumpButton(rewind: false),
                    ],
                  ),
                  SizedBox(height: 4),
                  SeekBar(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
