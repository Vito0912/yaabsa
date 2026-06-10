import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/path_tag_genre_update_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

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
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('Sign in to configure tools'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 16),
                  child: Text(
                    'Additional tools that extend standard ABS behavior by coordinating multiple API calls. All tools are disabled by default',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SettingsNavigationSection(
                  title: 'Tool Subpages',
                  topPadding: 0,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.route_outlined,
                      title: 'Path Tag and Genre Update',
                      onTap: () => context.push(PathTagGenreUpdateSettings.routeName),
                    ),
                  ],
                ),
                SettingsNavigationSection(
                  title: 'Experimental Tools',
                  topPadding: 20,
                  settings: [
                    SettingSwitchTile(
                      label: 'Remove authors without books',
                      subtitle: 'Add a button in the author section to delete authors without books',
                      settingKey: SettingKeys.toolsRemoveAuthorsWithoutBooks,
                      userId: currentUser.id,
                      defaultValue: false,
                    ),
                    SettingSwitchTile(
                      label: 'Force metadata refresh',
                      subtitle:
                          'Add a button to force recreation of metadata files in Admin Server Settings under metadata utils',
                      settingKey: SettingKeys.toolsForceMetadataRefresh,
                      userId: currentUser.id,
                      defaultValue: false,
                    ),
                    SettingSwitchTile(
                      label: 'Match audiobook chapters',
                      subtitle: 'Add a quick match option for fast chapter matching, including bulk mode',
                      settingKey: SettingKeys.toolsMatchAudiobookChapters,
                      userId: currentUser.id,
                      defaultValue: false,
                    ),
                    SettingSwitchTile(
                      label: 'Split genres/tags',
                      subtitle: 'Add a button to split genres and tags in Admin Server Settings under metadata utils',
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
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Failed to load user settings: $error',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
