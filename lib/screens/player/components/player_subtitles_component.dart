import 'package:flutter/material.dart';
import 'package:yaabsa/components/player/common/subtitle_panel.dart';

class PlayerSubtitlesComponent extends StatelessWidget {
  const PlayerSubtitlesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SubtitlePanel(compact: false, openContinuousModeOnTap: true);
  }
}
