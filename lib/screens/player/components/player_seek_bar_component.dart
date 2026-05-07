import 'package:flutter/material.dart';
import 'package:yaabsa/components/player/common/seek_bar.dart';
import 'package:yaabsa/screens/player/layout/player_layout_config.dart';

class PlayerSeekBarComponent extends StatelessWidget {
  const PlayerSeekBarComponent({
    super.key,
    this.timePlacement = PlayerSeekTimePlacement.inline,
    this.trackHeight = 8.0,
    this.timeLabelFontSize = 12.0,
  });

  final PlayerSeekTimePlacement timePlacement;
  final double trackHeight;
  final double timeLabelFontSize;

  @override
  Widget build(BuildContext context) {
    return SeekBar(
      trackHeight: trackHeight,
      timeLabelsBelow: timePlacement.timeLabelsBelow,
      showTimeLabels: timePlacement.showLabelsInComponent,
      timeLabelFontSize: timeLabelFontSize,
    );
  }
}
