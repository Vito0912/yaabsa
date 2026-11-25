import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

const String _sortFieldTitle = 'title';
const String _sortFieldAuthor = 'author';
const String _sortFieldAdded = 'added';

class AndroidAutoLibrarySettings extends ConsumerStatefulWidget {
  const AndroidAutoLibrarySettings({super.key});

  static const String routeName = '/settings/android-auto/library';

  @override
  ConsumerState<AndroidAutoLibrarySettings> createState() => _AndroidAutoLibrarySettingsState();
}

class _AndroidAutoLibrarySettingsState extends ConsumerState<AndroidAutoLibrarySettings> {
  bool _isUpdatingSortField = false;

  Future<void> _setSortField({required String userId, required String sortField}) async {
    if (_isUpdatingSortField) {
      return;
    }

    setState(() {
      _isUpdatingSortField = true;
    });

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(userId, SettingKeys.androidAutoLibrarySortField, sortField);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorOperationFailed(context.l10n.operationSaveSortOrder, e.toString()))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingSortField = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appDatabase = ref.watch(appDatabaseProvider);
    final currentUser = ref.watch(currentUserProvider);
    final isIOS = !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;
    final integrationLabel = isIOS ? context.l10n.settingsCarPlay : context.l10n.settingsAndroidAuto;

    return SettingsPageScaffold(
      title: context.l10n.headingIntegrationSectionSettings(integrationLabel, context.l10n.navLibrary),
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: '/settings/android-auto',
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(context.l10n.promptSignInToManageSettings),
              );
            }

            return SettingsNavigationSection(
              title: context.l10n.headingBrowseSettings,
              topPadding: 0,
              settings: [
                SettingSwitchTile(
                  userId: user.id,
                  label: context.l10n.settingSortDescending,
                  subtitle: context.l10n.settingSortDescendingDescription(context.l10n.mediaTypeAudiobook),
                  settingKey: SettingKeys.androidAutoLibrarySortDescending,
                  defaultValue: false,
                ),
                StreamBuilder<UserSettingEntry?>(
                  stream: appDatabase.watchUserSetting(user.id, SettingKeys.androidAutoLibrarySortField),
                  builder: (context, snapshot) {
                    final fallbackValue = ref
                        .read(settingsManagerProvider.notifier)
                        .getUserSetting<String>(
                          user.id,
                          SettingKeys.androidAutoLibrarySortField,
                          defaultValue: _sortFieldTitle,
                        );
                    final sortField = SettingsParser.decodeValue<String>(snapshot.data?.value, fallbackValue);
                    final safeSortField =
                        <String>{_sortFieldTitle, _sortFieldAuthor, _sortFieldAdded}.contains(sortField)
                        ? sortField
                        : _sortFieldTitle;

                    return SettingDropdown<String>.remote(
                      label: context.l10n.fieldSortBy,
                      values: const [_sortFieldTitle, _sortFieldAuthor, _sortFieldAdded],
                      valueLabels: [context.l10n.fieldTitle, context.l10n.fieldAuthor, context.l10n.sortDateAdded],
                      value: safeSortField,
                      enabled: !_isUpdatingSortField,
                      onValueChanged: (value) {
                        _setSortField(userId: user.id, sortField: value);
                      },
                    );
                  },
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
