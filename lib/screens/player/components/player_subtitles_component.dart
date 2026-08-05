import 'package:flutter/material.dart';
import 'package:yaabsa/components/player/common/subtitle_panel.dart';

class PlayerSubtitlesComponent extends StatelessWidget {
  const PlayerSubtitlesComponent({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SubtitlePanel(compact: compact, openContinuousModeOnTap: true);
  }
}
