import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

import 'package:yaabsa/generated/l10n.dart';

const String _sortFieldTitle = 'title';
const String _sortFieldAuthor = 'author';
const String _sortFieldAdded = 'added';

class AndroidAutoPodcastLibrarySettings extends ConsumerStatefulWidget {
  const AndroidAutoPodcastLibrarySettings({super.key});

  static const String routeName = '/settings/android-auto/podcast-library';

  @override
  ConsumerState<AndroidAutoPodcastLibrarySettings> createState() => _AndroidAutoPodcastLibrarySettingsState();
}

class _AndroidAutoPodcastLibrarySettingsState extends ConsumerState<AndroidAutoPodcastLibrarySettings> {
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
          .setUserSetting<String>(userId, SettingKeys.androidAutoPodcastSortField, sortField);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.current.screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsFailedToUpdateSortField(e),
          ),
        ),
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

    return SettingsPageScaffold(
      title: 'Android Auto - Podcast Library',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: '/settings/android-auto',
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(S.current.screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsNoActiveUserSignInTo),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingSwitch(
                  userId: user.id,
                  label: 'Sort Descending',
                  description: 'When enabled, Android Auto podcast lists are sorted in descending order.',
                  settingKey: SettingKeys.androidAutoPodcastSortDescending,
                  defaultValue: true,
                ),
                StreamBuilder<UserSettingEntry?>(
                  stream: appDatabase.watchUserSetting(user.id, SettingKeys.androidAutoPodcastSortField),
                  builder: (context, snapshot) {
                    final fallbackValue = ref
                        .read(settingsManagerProvider.notifier)
                        .getUserSetting<String>(
                          user.id,
                          SettingKeys.androidAutoPodcastSortField,
                          defaultValue: _sortFieldAdded,
                        );
                    final sortField = SettingsParser.decodeValue<String>(snapshot.data?.value, fallbackValue);
                    final safeSortField =
                        <String>{_sortFieldTitle, _sortFieldAuthor, _sortFieldAdded}.contains(sortField)
                        ? sortField
                        : _sortFieldAdded;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: DropdownButtonFormField<String>(
                        initialValue: safeSortField,
                        decoration: InputDecoration(
                          labelText: S.current.screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsSortBy,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: _sortFieldTitle,
                            child: Text(S.current.screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsTitle),
                          ),
                          DropdownMenuItem<String>(
                            value: _sortFieldAuthor,
                            child: Text(S.current.screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsAuthor),
                          ),
                          DropdownMenuItem<String>(
                            value: _sortFieldAdded,
                            child: Text(S.current.screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsDateAdded),
                          ),
                        ],
                        onChanged: _isUpdatingSortField
                            ? null
                            : (value) {
                                if (value != null) {
                                  _setSortField(userId: user.id, sortField: value);
                                }
                              },
                      ),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              S.current.screensSettingsAndroidAutoAndroidAutoPodcastLibrarySettingsFailedToLoadUserSettings(error),
            ),
          ),
        ),
      ],
    );
  }
}
