import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/util/setting_key.dart';

class SocialSyncedPlaybackSection extends StatelessWidget {
  const SocialSyncedPlaybackSection({required this.userId, required this.hasConnectedUsers, super.key});

  final String userId;
  final bool hasConnectedUsers;

  @override
  Widget build(BuildContext context) {
    final disabledReason = hasConnectedUsers ? null : 'Add at least one connected user first.';

    return SettingSwitch(
      label: 'Synced playback',
      description: 'Placeholder switch for future synced playback support.',
      settingKey: SettingKeys.socialSyncedPlayback,
      userId: userId,
      defaultValue: false,
      enabled: hasConnectedUsers,
      disabledReason: disabledReason,
    );
  }
}
