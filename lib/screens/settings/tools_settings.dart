import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/path_tag_genre_update_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class ToolsSettings extends ConsumerWidget {
  const ToolsSettings({super.key});

  static const String routeName = '/settings/tools';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: context.l10n.settingsCategoryTools,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUserAsync.when(
          data: (currentUser) {
            if (currentUser == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(context.l10n.promptSignInToManageSettings),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 16),
                  child: Text(context.l10n.messageAdditionalToolsInfo, style: Theme.of(context).textTheme.bodyMedium),
                ),
                SettingsNavigationSection(
                  title: context.l10n.headingToolSubpages,
                  topPadding: 0,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.route_outlined,
                      title: context.l10n.headingPathTagGenreUpdate,
                      onTap: () => context.push(PathTagGenreUpdateSettings.routeName),
                    ),
                  ],
                ),
                SettingsNavigationSection(
                  title: context.l10n.headingExperimentalTools,
                  topPadding: 20,
                  settings: [
                    SettingSwitchTile(
                      label: context.l10n.actionRemoveAuthorsWithoutBooks,
                      subtitle: context.l10n.settingRemoveAuthorsWithoutBooksDescription,
                      settingKey: SettingKeys.toolsRemoveAuthorsWithoutBooks,
                      userId: currentUser.id,
                      defaultValue: false,
                    ),
                    SettingSwitchTile(
                      label: context.l10n.settingForceMetadataRefresh,
                      subtitle: context.l10n.settingForceMetadataRefreshDescription,
                      settingKey: SettingKeys.toolsForceMetadataRefresh,
                      userId: currentUser.id,
                      defaultValue: false,
                    ),
                    SettingSwitchTile(
                      label: context.l10n.settingMatchAudiobookChapters,
                      subtitle: context.l10n.settingMatchAudiobookChaptersDescription,
                      settingKey: SettingKeys.toolsMatchAudiobookChapters,
                      userId: currentUser.id,
                      defaultValue: false,
                    ),
                    SettingSwitchTile(
                      label: context.l10n.settingSplitGenresAndTags,
                      subtitle: context.l10n.settingSplitGenresAndTagsDescription,
                      settingKey: SettingKeys.toolsSplitGenresTags,
                      userId: currentUser.id,
                      defaultValue: false,
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: YaabsaCircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              context.l10n.errorOperationFailed(context.l10n.operationLoadSettings, error.toString()),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
