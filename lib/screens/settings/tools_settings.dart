import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/path_tag_genre_update_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

import 'package:yaabsa/generated/l10n.dart';

class ToolsSettings extends ConsumerWidget {
  const ToolsSettings({super.key});

  static const String routeName = '/settings/tools';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'Tools',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUserAsync.when(
          data: (currentUser) {
            if (currentUser == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(S.current.screensSettingsToolsSettingsNoActiveUserSignInTo),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
                  child: Text(
                    S.current.screensSettingsToolsSettingsTheseToolsAddFunctionalityBeyondStandard,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SettingsNavigationSection(
                  title: 'Tool Subpages',
                  topPadding: 8,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.route_outlined,
                      title: 'Path Tag and Genre Update',
                      onTap: () => context.push(PathTagGenreUpdateSettings.routeName),
                    ),
                  ],
                ),
                const Divider(height: 26),
                SettingSwitch(
                  label: 'Remove authors without books',
                  description:
                      'This will add a button in the author section to allow deletion of authors without books.',
                  settingKey: SettingKeys.toolsRemoveAuthorsWithoutBooks,
                  userId: currentUser.id,
                  defaultValue: false,
                ),
                SettingSwitch(
                  label: 'Force metadata refresh',
                  description:
                      'This will add a button to force recreation of metadata files in Admin Server Settings under metadata utils.',
                  settingKey: SettingKeys.toolsForceMetadataRefresh,
                  userId: currentUser.id,
                  defaultValue: false,
                ),
                SettingSwitch(
                  label: 'Match audiobook chapters',
                  description:
                      'This will add a quick match option to allow quick chapter matching, including bulk mode.',
                  settingKey: SettingKeys.toolsMatchAudiobookChapters,
                  userId: currentUser.id,
                  defaultValue: false,
                ),
                SettingSwitch(
                  label: 'Split genres/tags',
                  description:
                      'This will add a button to split genres/tags in Admin Server Settings under metadata utils.',
                  settingKey: SettingKeys.toolsSplitGenresTags,
                  userId: currentUser.id,
                  defaultValue: false,
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.current.screensSettingsToolsSettingsFailedToLoadUserSettings(error),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
