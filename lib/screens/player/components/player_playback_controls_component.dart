import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/player/common/control_button.dart';
import 'package:yaabsa/components/player/common/jump_button.dart';
import 'package:yaabsa/components/player/common/skip_button.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/screens/player/layout/player_presentation_config.dart';

class PlayerTransportControlsComponent extends ConsumerWidget {
  const PlayerTransportControlsComponent({
    super.key,
    this.transportMode = PlayerTransportMode.both,
    this.prominent = true,
    this.prominentSkipButtons,
    this.prominentJumpButtons,
    this.jumpIconSize,
    this.skipIconSize,
    this.controlButtonSize,
    this.controlIconSize,
  });

  final PlayerTransportMode transportMode;
  final bool prominent;
  final bool? prominentSkipButtons;
  final bool? prominentJumpButtons;
  final double? jumpIconSize;
  final double? skipIconSize;
  final double? controlButtonSize;
  final double? controlIconSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loopModeAsync = ref.watch(globalSettingByKeyProvider(SettingKeys.loopMode));
    final loopMode = loopModeAsync.value ?? 'off';
    final isLoopOn = loopMode == 'on';

    final mixQueueAsync = ref.watch(globalSettingByKeyProvider(SettingKeys.mixQueue));
    final mixQueue = mixQueueAsync.value == 'true';

    final showLoopShuffleAsync = ref.watch(globalSettingByKeyProvider(SettingKeys.showPlayerLoopShuffle));
    final showLoopShuffle = showLoopShuffleAsync.value ?? 'music_only';

    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4);

    final db = ref.watch(appDatabaseProvider);
    final activeUserId = ref.watch(currentUserProvider).value?.id;

    return StreamBuilder<InternalMedia?>(
      stream: audioHandler.mediaItemStream,
      initialData: audioHandler.currentMediaItem,
      builder: (context, mediaSnapshot) {
        final currentMedia = mediaSnapshot.data;
        final libraryId = currentMedia?.libraryId;

        final userSettingStream = (activeUserId != null && libraryId != null)
            ? db.watchUserSetting(activeUserId, 'music_library_$libraryId')
            : Stream<UserSettingEntry?>.value(null);

        return StreamBuilder<UserSettingEntry?>(
          stream: userSettingStream,
          builder: (context, settingSnapshot) {
            final isMusic = settingSnapshot.data?.value == 'true';

            bool showControls = false;
            if (showLoopShuffle == 'on') {
              showControls = true;
            } else if (showLoopShuffle == 'off') {
              showControls = false;
            } else {
              showControls = isMusic;
            }

            final showJump = transportMode != PlayerTransportMode.skip;
            final showSkip = transportMode != PlayerTransportMode.jump;
            final useProminentSkipButtons = prominentSkipButtons ?? prominent;
            final useProminentJumpButtons = prominentJumpButtons ?? prominent;

            final controls = <Widget>[
              if (showControls)
                IconButton(
                  icon: Icon(Icons.shuffle, color: mixQueue ? activeColor : inactiveColor),
                  onPressed: () {
                    audioHandler.toggleMix();
                  },
                  tooltip: 'Shuffle Queue',
                ),
              if (showSkip)
                SkipButton(
                  previous: true,
                  iconSize: skipIconSize ?? (useProminentSkipButtons ? 30 : null),
                  buttonSize: useProminentSkipButtons ? 56 : 48,
                ),
              if (showJump)
                JumpButton(
                  rewind: true,
                  iconSize: jumpIconSize ?? (useProminentJumpButtons ? 34 : null),
                  buttonSize: useProminentJumpButtons ? 62 : 48,
                ),
              ControlButton(
                prominent: prominent,
                iconSize: controlIconSize ?? (prominent ? null : 24),
                buttonSize: controlButtonSize,
              ),
              if (showJump)
                JumpButton(
                  rewind: false,
                  iconSize: jumpIconSize ?? (useProminentJumpButtons ? 34 : null),
                  buttonSize: useProminentJumpButtons ? 62 : 48,
                ),
              if (showSkip)
                SkipButton(
                  previous: false,
                  iconSize: skipIconSize ?? (useProminentSkipButtons ? 30 : null),
                  buttonSize: useProminentSkipButtons ? 56 : 48,
                ),
              if (showControls)
                IconButton(
                  icon: Icon(Icons.repeat, color: isLoopOn ? activeColor : inactiveColor),
                  onPressed: () {
                    audioHandler.cycleLoopMode();
                  },
                  tooltip: isLoopOn ? 'Loop On' : 'Loop Off',
                ),
            ];

            if (context.isMobile) {
              return FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (var index = 0; index < controls.length; index++) ...<Widget>[
                      if (index > 0) const SizedBox(width: 4),
                      controls[index],
                    ],
                  ],
                ),
              );
            }

            return Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: controls,
            );
          },
        );
      },
    );
  }
}
