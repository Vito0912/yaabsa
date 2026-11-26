import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/util/aaos_service.dart';

String _carIntegrationLabel(SettingsContext ctx) {
  if (ctx.isAaos) {
    return ctx.l10n.settingsAndroidAutomotive;
  }

  if (ctx.isIOS) {
    return ctx.l10n.settingsCarPlay;
  }

  return ctx.l10n.settingsAndroidAuto;
}

List<SettingsPageSpec> buildAccountCarSettingsPages() {
  return <SettingsPageSpec>[_buildCarIntegrationPage(), _buildCarLibraryPage(), _buildCarPodcastLibraryPage()];
}

SettingsPageSpec _buildCarIntegrationPage() {
  return SettingsPageSpec(
    id: 'account.car',
    route: SettingsRoutes.androidAuto,
    scope: SettingScope.account,
    icon: Icons.directions_car_filled_outlined,
    title: _carIntegrationLabel,
    requiresSignIn: true,
    availability: (ctx) {
      if (ctx.isMobilePlatform || ctx.isAaos) {
        return const SettingsAvailability.available();
      }

      return const SettingsAvailability.hidden();
    },
    sections: [
      SettingsSectionSpec(
        id: 'account.car.aaos_actions',
        title: (ctx) => ctx.l10n.settingsCarIntegration,
        availability: (ctx) {
          if (ctx.isAaos) {
            return const SettingsAvailability.available();
          }

          return const SettingsAvailability.hidden();
        },
        entries: [
          SettingsNavEntry(
            id: 'aaos_open_media_center',
            title: (ctx) => ctx.l10n.aaosOpenMediaCenter,
            keywords: (l10n) => <String>[l10n.settingsAndroidAutomotive, 'aaos', 'car', 'media center'],
            icon: Icons.play_circle_outline,
            targetRoute: SettingsRoutes.androidAuto,
            onTapOverride: (context, ref) async {
              await AaosService.instance.launchMediaCenter(finishActivity: true);
            },
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'account.car.general',
        title: (ctx) => ctx.l10n.settingsCategoryGeneral,
        entries: [
          SettingsToggleEntry(
            id: 'car_group_by_letters',
            title: (ctx) => ctx.l10n.settingGroupListsByFirstLetter,
            description: (ctx) => ctx.l10n.settingGroupListsByFirstLetterDescription(_carIntegrationLabel(ctx)),
            keywords: (l10n) => <String>[
              l10n.settingsAndroidAuto,
              l10n.settingsCarPlay,
              l10n.settingsAndroidAutomotive,
              'carplay',
              'android auto',
              'aaos',
            ],
            definition: AppSettingDefs.androidAutoGroupByLetters,
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'account.car.browse',
        title: (ctx) => ctx.l10n.headingBrowseSettings,
        entries: [
          SettingsNavEntry(
            id: 'car_library_nav',
            title: (ctx) => ctx.l10n.navLibrary,
            description: (ctx) =>
                ctx.l10n.settingBrowseSortDescription(ctx.l10n.mediaTypeAudiobook, _carIntegrationLabel(ctx)),
            icon: Icons.library_books_outlined,
            targetRoute: SettingsRoutes.androidAutoLibrary,
            targetPageId: 'account.car.library',
          ),
          SettingsNavEntry(
            id: 'car_podcast_library_nav',
            title: (ctx) => ctx.l10n.navPodcastLibrary,
            description: (ctx) =>
                ctx.l10n.settingBrowseSortDescription(ctx.l10n.mediaTypePodcast, _carIntegrationLabel(ctx)),
            icon: Icons.podcasts_outlined,
            targetRoute: SettingsRoutes.androidAutoPodcastLibrary,
            targetPageId: 'account.car.podcast_library',
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildCarLibraryPage() {
  return SettingsPageSpec(
    id: 'account.car.library',
    parentId: 'account.car',
    route: SettingsRoutes.androidAutoLibrary,
    scope: SettingScope.account,
    icon: Icons.library_books_outlined,
    title: (ctx) => ctx.l10n.headingIntegrationSectionSettings(_carIntegrationLabel(ctx), ctx.l10n.navLibrary),
    requiresSignIn: true,
    sections: [
      SettingsSectionSpec(
        id: 'account.car.library.browse',
        title: (ctx) => ctx.l10n.headingBrowseSettings,
        entries: [
          SettingsToggleEntry(
            id: 'car_library_sort_descending',
            title: (ctx) => ctx.l10n.settingSortDescending,
            description: (ctx) => ctx.l10n.settingSortDescendingDescription(ctx.l10n.mediaTypeAudiobook),
            keywords: (l10n) => <String>[
              l10n.settingsAndroidAuto,
              l10n.settingsCarPlay,
              l10n.settingsAndroidAutomotive,
              'carplay',
              'android auto',
              'sort',
            ],
            definition: AppSettingDefs.androidAutoLibrarySortDescending,
          ),
          SettingsChoiceEntry<String>(
            id: 'car_library_sort_field',
            title: (ctx) => ctx.l10n.fieldSortBy,
            keywords: (l10n) => <String>[
              l10n.settingsAndroidAuto,
              l10n.settingsCarPlay,
              'carplay',
              'android auto',
              'sort',
            ],
            definition: AppSettingDefs.androidAutoLibrarySortField,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(value: 'title', label: ctx.l10n.fieldTitle),
              SettingsChoiceOption(value: 'author', label: ctx.l10n.fieldAuthor),
              SettingsChoiceOption(value: 'added', label: ctx.l10n.sortDateAdded),
            ],
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildCarPodcastLibraryPage() {
  return SettingsPageSpec(
    id: 'account.car.podcast_library',
    parentId: 'account.car',
    route: SettingsRoutes.androidAutoPodcastLibrary,
    scope: SettingScope.account,
    icon: Icons.podcasts_outlined,
    title: (ctx) => ctx.l10n.headingIntegrationSectionSettings(_carIntegrationLabel(ctx), ctx.l10n.navPodcastLibrary),
    requiresSignIn: true,
    sections: [
      SettingsSectionSpec(
        id: 'account.car.podcast_library.browse',
        title: (ctx) => ctx.l10n.headingBrowseSettings,
        entries: [
          SettingsToggleEntry(
            id: 'car_podcast_sort_descending',
            title: (ctx) => ctx.l10n.settingSortDescending,
            description: (ctx) => ctx.l10n.settingSortDescendingDescription(ctx.l10n.mediaTypePodcast),
            keywords: (l10n) => <String>[
              l10n.settingsAndroidAuto,
              l10n.settingsCarPlay,
              l10n.mediaTypePodcast,
              'carplay',
              'android auto',
              'sort',
            ],
            definition: AppSettingDefs.androidAutoPodcastSortDescending,
          ),
          SettingsChoiceEntry<String>(
            id: 'car_podcast_sort_field',
            title: (ctx) => ctx.l10n.fieldSortBy,
            keywords: (l10n) => <String>[
              l10n.settingsAndroidAuto,
              l10n.settingsCarPlay,
              l10n.mediaTypePodcast,
              'carplay',
              'android auto',
              'sort',
            ],
            definition: AppSettingDefs.androidAutoPodcastSortField,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(value: 'title', label: ctx.l10n.fieldTitle),
              SettingsChoiceOption(value: 'author', label: ctx.l10n.fieldAuthor),
              SettingsChoiceOption(value: 'added', label: ctx.l10n.sortDateAdded),
            ],
          ),
        ],
      ),
    ],
  );
}
