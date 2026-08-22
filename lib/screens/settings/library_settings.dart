import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/library_shelf_settings.dart';
import 'package:yaabsa/screens/settings/library_order_settings.dart';
import 'package:yaabsa/screens/settings/library_view_subtitle_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/util/setting_key.dart';

class LibrarySettings extends ConsumerStatefulWidget {
  const LibrarySettings({super.key});

  static const String routeName = '/settings/library';

  @override
  ConsumerState<LibrarySettings> createState() => _LibrarySettingsState();
}

class _LibrarySettingsState extends ConsumerState<LibrarySettings> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'Library Settings',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('Sign in to configure library settings'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsNavigationSection(
                  title: 'Library',
                  topPadding: 8,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.view_carousel_outlined,
                      title: 'Shelf Sections',
                      subtitle: 'Choose which shelf sections are visible and their order',
                      onTap: () => context.push(LibraryShelfSettings.routeName),
                    ),
                    SettingsNavigationItem(
                      icon: Icons.sort_rounded,
                      title: 'Reorder & Configure Libraries',
                      onTap: () => context.push(LibraryOrderSettings.routeName),
                    ),
                    SettingsNavigationItem(
                      icon: Icons.subtitles_outlined,
                      title: 'View Subtitles',
                      subtitle: 'Configure details that are shown for items, series and authors as a subtitle',
                      onTap: () => context.push(LibraryViewSubtitleSettings.routeName),
                    ),
                  ],
                  settings: [
                    SettingSlider<double>(
                      label: 'Library Grid Scale',
                      description: 'Scales library item cards in all grid views',
                      values: appLibraryGridScaleOptions,
                      valueLabels: appLibraryGridScaleLabels,
                      settingKey: SettingKeys.libraryGridScale,
                    ),
                    SettingSwitchTile(
                      label: 'Collapse Series',
                      settingKey: SettingKeys.collapseSeries,
                      userId: user.id,
                    ),

                    const SettingSwitchTile(
                      label: 'Show Shelf Play Button',
                      settingKey: SettingKeys.personalizedShelfShowPlayVisibleButton,
                      subtitle: 'Adds a play-all button on Continue Listening and Newest Episodes shelves',
                    ),
                    SettingSwitchTile(
                      label: 'Show Shuffle Button',
                      settingKey: SettingKeys.showShuffleButton,
                      userId: user.id,
                      subtitle: 'Adds a shuffle button to collections, playlists, and podcasts',
                    ),
                    const SettingSwitchTile(
                      label: 'Check Server Updates',
                      settingKey: SettingKeys.checkForServerUpdates,
                      subtitle: 'Checks for ABS updates via GitHub',
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) =>
              Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load user settings: $error')),
        ),
      ],
    );
  }
}
