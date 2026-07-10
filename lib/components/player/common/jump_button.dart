import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';

class JumpButton extends ConsumerWidget {
  const JumpButton({super.key, required this.rewind});

  final bool rewind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intervalKey = rewind ? SettingKeys.rewindInterval : SettingKeys.fastForwardInterval;
    final intervalVal = ref.watch(globalSettingByKeyProvider(intervalKey)).asData?.value;
    final durationSeconds = SettingsParser.decodeValue<int>(intervalVal, 10);

    return IconButton(
      icon: JumpIcon(rewind: rewind, durationSeconds: durationSeconds),
      onPressed: () {
        rewind ? audioHandler.rewind() : audioHandler.fastForward();
      },
    );
  }
}

class JumpIcon extends StatelessWidget {
  const JumpIcon({super.key, required this.rewind, required this.durationSeconds, this.size, this.color});

  final bool rewind;
  final int durationSeconds;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final double iconSize = size ?? IconTheme.of(context).size ?? 24.0;
    final Color iconColor = color ?? IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;

    final text = durationSeconds.toString();
    final double fontSize = iconSize * 0.25;

    final Widget baseIcon = Icon(Icons.replay, size: iconSize, color: iconColor);

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (rewind) baseIcon else Transform.scale(scaleX: -1, child: baseIcon),
          Positioned(
            bottom: iconSize * 0.29,
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: iconColor, height: 1.0),
            ),
          ),
        ],
      ),
    );
  }
}
