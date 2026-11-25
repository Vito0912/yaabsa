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
import 'package:yaabsa/util/app_update_checker.dart';
import 'package:yaabsa/util/layout_sizes.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

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
      title: context.l10n.headingLibrarySettings,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(context.l10n.promptSignInToManageSettings),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsNavigationSection(
                  title: context.l10n.navLibrary,
                  topPadding: 8,
                  items: [
                    SettingsNavigationItem(
                      icon: Icons.view_carousel_outlined,
                      title: context.l10n.settingShelfSections,
                      subtitle: context.l10n.settingShelfSectionsDescription,
                      onTap: () => context.push(LibraryShelfSettings.routeName),
                    ),
                    SettingsNavigationItem(
                      icon: Icons.sort_rounded,
                      title: context.l10n.navLibraries,
                      onTap: () => context.push(LibraryOrderSettings.routeName),
                    ),
                    SettingsNavigationItem(
                      icon: Icons.subtitles_outlined,
                      title: context.l10n.settingViewSubtitles,
                      subtitle: context.l10n.settingViewSubtitlesDescription,
                      onTap: () => context.push(LibraryViewSubtitleSettings.routeName),
                    ),
                  ],
                  settings: [
                    SettingSlider<double>(
                      label: context.l10n.settingLibraryGridScale,
                      description: context.l10n.settingLibraryGridScaleDescription,
                      values: appLibraryGridScaleOptions,
                      valueLabels: appLibraryGridScaleLabels,
                      settingKey: SettingKeys.libraryGridScale,
                    ),
                    SettingSwitchTile(
                      label: context.l10n.settingCollapseSeries,
                      settingKey: SettingKeys.collapseSeries,
                      userId: user.id,
                    ),
                    SettingSwitchTile(
                      label: context.l10n.settingRefreshProgressOnResume,
                      settingKey: SettingKeys.refreshProgressOnAppResume,
                      subtitle: context.l10n.settingRefreshProgressOnResumeDescription,
                    ),
                    SettingSwitchTile(
                      label: context.l10n.settingShowShelfPlayButton,
                      settingKey: SettingKeys.personalizedShelfShowPlayVisibleButton,
                      subtitle: context.l10n.settingShowShelfPlayButtonDescription,
                    ),
                    SettingSwitchTile(
                      label: context.l10n.settingShowShuffleButton,
                      settingKey: SettingKeys.showShuffleButton,
                      userId: user.id,
                      subtitle: context.l10n.settingShowShuffleButtonDescription,
                    ),
                    if (isAppUpdateCheckEligible)
                      SettingSwitchTile(
                        label: context.l10n.settingCheckForAppUpdates,
                        settingKey: appUpdateSettingKey,
                        defaultValue: false,
                        subtitle: context.l10n.settingCheckForAppUpdatesDescription,
                      ),
                    SettingSwitchTile(
                      label: context.l10n.settingCheckServerUpdates,
                      settingKey: SettingKeys.checkForServerUpdates,
                      subtitle: context.l10n.settingCheckServerUpdatesDescription,
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: YaabsaCircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(context.l10n.errorOperationFailed(context.l10n.operationLoadSettings, error.toString())),
          ),
        ),
      ],
    );
  }
}
