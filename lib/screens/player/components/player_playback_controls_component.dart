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

class PlayerTransportControlsComponent extends ConsumerWidget {
  const PlayerTransportControlsComponent({super.key});

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

            return Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 1,
              runSpacing: 1,
              children: <Widget>[
                if (showControls)
                  IconButton(
                    icon: Icon(Icons.shuffle, color: mixQueue ? activeColor : inactiveColor),
                    onPressed: () {
                      audioHandler.toggleMix();
                    },
                    tooltip: 'Shuffle Queue',
                  ),
                const SkipButton(previous: true),
                const JumpButton(rewind: true),
                const ControlButton(),
                const JumpButton(rewind: false),
                const SkipButton(previous: false),
                if (showControls)
                  IconButton(
                    icon: Icon(Icons.repeat, color: isLoopOn ? activeColor : inactiveColor),
                    onPressed: () {
                      audioHandler.cycleLoopMode();
                    },
                    tooltip: isLoopOn ? 'Loop On' : 'Loop Off',
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
