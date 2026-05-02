import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/aaos_service.dart';
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
  bool _isUpdatingPodcastSortDirection = false;
  bool _isUpdatingPodcastSortField = false;
  bool _isUpdatingGroupByLetters = false;

  @override
  void initState() {
    super.initState();
    unawaited(AaosService.instance.initialize());
  }

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

  Future<void> _setPodcastSortDirection({required String userId, required bool descending}) async {
    if (_isUpdatingPodcastSortDirection) {
      return;
    }

    setState(() {
      _isUpdatingPodcastSortDirection = true;
    });

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<bool>(userId, SettingKeys.androidAutoPodcastSortDescending, descending);
    } catch (e) {
      _showSaveError('Failed to update Android Auto podcast sort direction: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingPodcastSortDirection = false;
        });
      }
    }
  }

  Future<void> _setPodcastSortField({required String userId, required String sortField}) async {
    if (_isUpdatingPodcastSortField) {
      return;
    }

    setState(() {
      _isUpdatingPodcastSortField = true;
    });

    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setUserSetting<String>(userId, SettingKeys.androidAutoPodcastSortField, sortField);
    } catch (e) {
      _showSaveError('Failed to update Android Auto podcast sort field: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingPodcastSortField = false;
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

  Widget _buildAaosSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_car_filled, size: 20, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 10),
                    Expanded(child: Text('AAOS mode active', style: Theme.of(context).textTheme.titleSmall)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('For now here are no settings for AAOS.', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAndroidAutoSettings(AppDatabase appDatabase) {
    final currentUser = ref.watch(currentUserProvider);

    return currentUser.when(
      data: (user) {
        if (user == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text('No active user. Sign in to configure Android Auto browse settings.'),
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
                    .getUserSetting<bool>(user.id, SettingKeys.androidAutoLibrarySortDescending, defaultValue: false);
                final sortDescending = SettingsParser.decodeValue<bool>(snapshot.data?.value, fallbackValue);

                return SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  value: sortDescending,
                  onChanged: _isUpdatingSortDirection
                      ? null
                      : (value) => _setSortDirection(userId: user.id, descending: value),
                  title: const Text('Book Sort Descending'),
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
                final safeSortField = <String>{_sortFieldTitle, _sortFieldAuthor, _sortFieldAdded}.contains(sortField)
                    ? sortField
                    : _sortFieldTitle;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: DropdownButtonFormField<String>(
                    initialValue: safeSortField,
                    decoration: const InputDecoration(labelText: 'Book Sort By'),
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
              stream: appDatabase.watchUserSetting(user.id, SettingKeys.androidAutoPodcastSortDescending),
              builder: (context, snapshot) {
                final fallbackValue = ref
                    .read(settingsManagerProvider.notifier)
                    .getUserSetting<bool>(user.id, SettingKeys.androidAutoPodcastSortDescending, defaultValue: true);
                final sortDescending = SettingsParser.decodeValue<bool>(snapshot.data?.value, fallbackValue);

                return SwitchListTile.adaptive(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                  value: sortDescending,
                  onChanged: _isUpdatingPodcastSortDirection
                      ? null
                      : (value) => _setPodcastSortDirection(userId: user.id, descending: value),
                  title: const Text('Podcast Sort Descending'),
                );
              },
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
                final safeSortField = <String>{_sortFieldTitle, _sortFieldAuthor, _sortFieldAdded}.contains(sortField)
                    ? sortField
                    : _sortFieldAdded;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: DropdownButtonFormField<String>(
                    initialValue: safeSortField,
                    decoration: const InputDecoration(labelText: 'Podcast Sort By'),
                    items: const [
                      DropdownMenuItem<String>(value: _sortFieldTitle, child: Text('Title')),
                      DropdownMenuItem<String>(value: _sortFieldAuthor, child: Text('Author')),
                      DropdownMenuItem<String>(value: _sortFieldAdded, child: Text('Date Added')),
                    ],
                    onChanged: _isUpdatingPodcastSortField
                        ? null
                        : (value) {
                            if (value != null) {
                              _setPodcastSortField(userId: user.id, sortField: value);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final appDatabase = ref.watch(appDatabaseProvider);

    return StreamBuilder<AaosTelemetryState>(
      stream: AaosService.instance.stream,
      initialData: AaosService.instance.currentState,
      builder: (context, snapshot) {
        final aaosState = snapshot.data ?? AaosService.instance.currentState;
        final isAaos = aaosState.isAutomotiveDevice;

        return SettingsPageScaffold(
          title: isAaos ? 'AAOS Settings' : 'Android Auto Settings',
          children: [if (isAaos) _buildAaosSettings(), if (!isAaos) _buildAndroidAutoSettings(appDatabase)],
        );
      },
    );
  }
}
