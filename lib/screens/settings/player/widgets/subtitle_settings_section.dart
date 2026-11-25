import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class SubtitleSettingsSection extends ConsumerWidget {
  const SubtitleSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      data: (user) {
        if (user == null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(context.l10n.promptSignInToManageSettings),
          );
        }

        return SettingsNavigationSection(
          title: context.l10n.playerComponentSubtitles,
          topPadding: 0,
          settings: [
            SettingSwitchTile(
              userId: user.id,
              settingKey: SettingKeys.subtitlesEnabled,
              label: context.l10n.settingEnableSubtitles,
              subtitle: context.l10n.settingEnableSubtitlesDescription,
            ),
            SettingSwitchTile(
              userId: user.id,
              settingKey: SettingKeys.subtitleSpeakerHighlighting,
              label: context.l10n.settingHighlightSpeakerLabels,
              subtitle: context.l10n.settingHighlightSpeakerLabelsDescription,
            ),
            SettingSwitchTile(
              userId: user.id,
              settingKey: SettingKeys.subtitleReadAlong,
              label: context.l10n.settingEnableReadAlong,
              subtitle: context.l10n.settingEnableReadAlongDescription,
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(child: YaabsaCircularProgressIndicator()),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          context.l10n.errorOperationFailed(context.l10n.operationLoadSettings, error.toString()),
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
