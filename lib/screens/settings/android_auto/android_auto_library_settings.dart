import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

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

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update sort field: $e')));
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
    final integrationLabel = isIOS ? 'CarPlay' : 'Android Auto';

    return SettingsPageScaffold(
      title: '$integrationLabel - Library',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: '/settings/android-auto',
      children: [
        currentUser.when(
          data: (user) {
            if (user == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('No active user. Sign in to configure car library settings.'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingSwitch(
                  userId: user.id,
                  label: 'Sort Descending',
                  description: 'When enabled, $integrationLabel library lists are sorted in descending order.',
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

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
