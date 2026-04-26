import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/setting_key.dart';

class SubtitleSettingsSection extends ConsumerWidget {
  const SubtitleSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      data: (user) {
        if (user == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text('No active user. Sign in to configure subtitle settings.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Text('Subtitles', style: Theme.of(context).textTheme.titleLarge),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider(height: 16)),
            SettingSwitch(
              userId: user.id,
              settingKey: SettingKeys.subtitlesEnabled,
              label: 'Enable subtitles',
              description: 'Show subtitle tracks (.srt and .vtt) during playback when available.',
            ),
            SettingSwitch(
              userId: user.id,
              settingKey: SettingKeys.subtitleSpeakerHighlighting,
              label: 'Highlight speaker labels',
              description: 'Highlight speaker',
            ),
            SettingSwitch(
              userId: user.id,
              settingKey: SettingKeys.subtitleReadAlong,
              label: 'Enable read along',
              description: 'Highlight currently spoken words. Needs a WebVTT subtitle with cue timestamp payload',
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          'Unable to load subtitle settings: $error',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
