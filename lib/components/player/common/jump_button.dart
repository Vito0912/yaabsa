import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';

class JumpButton extends ConsumerWidget {
  const JumpButton({super.key, required this.rewind, this.iconSize, this.buttonSize = 48});

  final bool rewind;
  final double? iconSize;
  final double buttonSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intervalKey = rewind ? SettingKeys.rewindInterval : SettingKeys.fastForwardInterval;
    final intervalVal = ref.watch(globalSettingByKeyProvider(intervalKey)).asData?.value;
    final durationSeconds = SettingsParser.decodeValue<int>(intervalVal, 10);

    return IconButton(
      style: IconButton.styleFrom(minimumSize: Size.square(buttonSize)),
      iconSize: iconSize,
      tooltip: rewind ? 'Rewind $durationSeconds seconds' : 'Forward $durationSeconds seconds',
      icon: JumpIcon(rewind: rewind, durationSeconds: durationSeconds, size: iconSize),
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

    final standardIcon = switch ((rewind, durationSeconds)) {
      (true, 5) => Icons.replay_5_rounded,
      (true, 10) => Icons.replay_10_rounded,
      (true, 30) => Icons.replay_30_rounded,
      (false, 5) => Icons.forward_5_rounded,
      (false, 10) => Icons.forward_10_rounded,
      (false, 30) => Icons.forward_30_rounded,
      _ => null,
    };
    if (standardIcon != null) {
      return Icon(standardIcon, size: iconSize, color: iconColor);
    }

    final text = durationSeconds.toString();
    final double fontSize = iconSize * (text.length > 1 ? 0.24 : 0.28);

    final Widget baseIcon = Icon(Icons.replay_rounded, size: iconSize, color: iconColor);

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (rewind) baseIcon else Transform.scale(scaleX: -1, child: baseIcon),
          Transform.translate(
            offset: const Offset(0, 2),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: iconColor,
                height: 1,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
