import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

const String _sortFieldTitle = 'title';
const String _sortFieldAuthor = 'author';
const String _sortFieldAdded = 'added';

class AndroidAutoSettings extends ConsumerStatefulWidget {
  const AndroidAutoSettings({super.key});

  static const String routeName = '/settings/android-auto';

  @override
  ConsumerState<AndroidAutoSettings> createState() => _AndroidAutoSettingsState();
}

class _AndroidAutoSettingsState extends ConsumerState<AndroidAutoSettings> {
  bool _isUpdatingSortDirection = false;
  bool _isUpdatingSortField = false;
  bool _isUpdatingGroupByLetters = false;

  void _showSaveError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _setSortDirection({required String userId, required bool descending}) async {
    if (_isUpdatingSortDirection) {
      return;
    }

    setState(() {
      _isUpdatingSortDirection = true;
    });

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<bool>(userId, SettingKeys.androidAutoLibrarySortDescending, descending);
    } catch (e) {
      _showSaveError('Failed to update Android Auto sort direction: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingSortDirection = false;
        });
      }
    }
  }

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
      _showSaveError('Failed to update Android Auto sort field: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingSortField = false;
        });
      }
    }
  }

  Future<void> _setGroupByLetters({required String userId, required bool enabled}) async {
    if (_isUpdatingGroupByLetters) {
      return;
    }

    setState(() {
      _isUpdatingGroupByLetters = true;
    });

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<bool>(userId, SettingKeys.androidAutoGroupByLetters, enabled);
    } catch (e) {
      _showSaveError('Failed to update Android Auto grouping: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingGroupByLetters = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appDatabase = ref.watch(appDatabaseProvider);
    final currentUser = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'Android Auto Settings',
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('No active user. Sign in to configure Android Auto settings.'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder<UserSettingEntry?>(
                  stream: appDatabase.watchUserSetting(user.id, SettingKeys.androidAutoLibrarySortDescending),
                  builder: (context, snapshot) {
                    final fallbackValue = ref
                        .read(settingsManagerProvider.notifier)
                        .getUserSetting<bool>(
                          user.id,
                          SettingKeys.androidAutoLibrarySortDescending,
                          defaultValue: false,
                        );
                    final sortDescending = SettingsParser.decodeValue<bool>(snapshot.data?.value, fallbackValue);

                    return SwitchListTile.adaptive(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      value: sortDescending,
                      onChanged: _isUpdatingSortDirection
                          ? null
                          : (value) => _setSortDirection(userId: user.id, descending: value),
                      title: const Text('Sort Descending'),
                    );
                  },
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

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: DropdownButtonFormField<String>(
                        initialValue: safeSortField,
                        decoration: const InputDecoration(labelText: 'Sort By'),
                        items: const [
                          DropdownMenuItem<String>(value: _sortFieldTitle, child: Text('Title')),
                          DropdownMenuItem<String>(value: _sortFieldAuthor, child: Text('Author')),
                          DropdownMenuItem<String>(value: _sortFieldAdded, child: Text('Date Added')),
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
                StreamBuilder<UserSettingEntry?>(
                  stream: appDatabase.watchUserSetting(user.id, SettingKeys.androidAutoGroupByLetters),
                  builder: (context, snapshot) {
                    final fallbackValue = ref
                        .read(settingsManagerProvider.notifier)
                        .getUserSetting<bool>(user.id, SettingKeys.androidAutoGroupByLetters, defaultValue: true);
                    final groupByLetters = SettingsParser.decodeValue<bool>(snapshot.data?.value, fallbackValue);

                    return SwitchListTile.adaptive(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                      value: groupByLetters,
                      onChanged: _isUpdatingGroupByLetters
                          ? null
                          : (value) => _setGroupByLetters(userId: user.id, enabled: value),
                      title: const Text('Group Large Lists By First Letter'),
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
          error: (error, _) =>
              Padding(padding: const EdgeInsets.all(16), child: Text('Failed to load user settings: $error')),
        ),
      ],
    );
  }
}
