import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
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

        return SettingsNavigationSection(
          title: 'Subtitles',
          topPadding: 0,
          settings: [
            SettingSwitchTile(
              userId: user.id,
              settingKey: SettingKeys.subtitlesEnabled,
              label: 'Enable subtitles',
              subtitle: 'Show subtitle tracks (.srt and .vtt) during playback when available',
            ),
            SettingSwitchTile(
              userId: user.id,
              settingKey: SettingKeys.subtitleSpeakerHighlighting,
              label: 'Highlight speaker labels',
              subtitle: 'Highlight speaker names',
            ),
            SettingSwitchTile(
              userId: user.id,
              settingKey: SettingKeys.subtitleReadAlong,
              label: 'Enable read along',
              subtitle: 'Highlight currently spoken words (requires WebVTT subtitle with cue timestamp)',
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
