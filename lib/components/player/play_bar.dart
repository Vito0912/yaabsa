import 'package:buchshelfly/components/player/common/chapter_text.dart';
import 'package:buchshelfly/components/player/common/control_button.dart';
import 'package:buchshelfly/components/player/common/jump_button.dart';
import 'package:buchshelfly/components/player/common/seek_bar.dart';
import 'package:buchshelfly/components/player/common/stop_button.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PlayBar extends HookWidget {
  const PlayBar({super.key});

  @override
  Widget build(BuildContext context) {
    final playerStateStream = audioHandler.shouldShowPlayer;

    final playingStatusStream = useMemoized(() => playerStateStream, [playerStateStream]);

    final playingSnapshot = useStream(playingStatusStream, initialData: audioHandler.player.playerState.playing);

    if (playingSnapshot.hasData && playingSnapshot.data == true) {
      return SafeArea(
        child: InkWell(
          onTap: () {
            //context.go('/player');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      JumpButton(rewind: true),
                      ControlButton(),
                      JumpButton(rewind: false),
                      StopButton(),
                      ChapterText(),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: SeekBar()),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
