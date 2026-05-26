import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class ServerManagementSettings extends ConsumerWidget {
  const ServerManagementSettings({super.key});

  static const String routeName = '/settings/server-management';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: 'Server Management',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUserAsync.when(
          data: (currentUser) {
            if (currentUser == null) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text('No active user. Sign in to manage server management visibility settings.'),
              );
            }

            final canUpdateItems = currentUser.permissions.update;
            final canDeleteItems = currentUser.permissions.delete;
            final canUploadItems = currentUser.permissions.upload;
            final appDatabase = ref.watch(appDatabaseProvider);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingSwitch(
                  label: 'Collections',
                  settingKey: SettingKeys.serverManagementCollections,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: true,
                  enabled: canUpdateItems,
                  description: 'Allows you to edit and create collections like playlists',
                  disabledReason: canUpdateItems ? null : 'Requires edit-item permission.',
                ),
                SettingSwitch(
                  label: 'Edit items',
                  settingKey: SettingKeys.serverManagementEditItems,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canUpdateItems,
                  description: 'Allows access to item editing features like bulk edit',
                  disabledReason: canUpdateItems ? null : 'Requires edit-item permission',
                ),
                SettingSwitch(
                  label: 'Delete items',
                  settingKey: SettingKeys.serverManagementDeleteItems,
                  userId: canDeleteItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canDeleteItems,
                  description: 'Allows deleting items',
                  disabledReason: canDeleteItems ? null : 'Requires delete-item permission',
                ),
                SettingSwitch(
                  label: 'Edit chapters',
                  settingKey: SettingKeys.serverManagementEditChapters,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: true,
                  enabled: canUpdateItems,
                  description: 'Allows using and editing the chapter editor',
                  disabledReason: canUpdateItems ? null : 'Requires edit-item permission',
                ),
                SettingSwitch(
                  label: 'Upload',
                  settingKey: SettingKeys.serverManagementUploadItems,
                  userId: canUploadItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canUploadItems,
                  description: 'Allows uploading new items',
                  disabledReason: canUploadItems ? null : 'Requires upload permission',
                ),
                StreamBuilder<UserSettingEntry?>(
                  stream: appDatabase.watchUserSetting(currentUser.id, SettingKeys.serverManagementEditItems),
                  builder: (context, snapshot) {
                    final editItemsEnabled = SettingsParser.decodeValue<bool>(
                      snapshot.data?.value,
                      defaultSettings[SettingKeys.serverManagementEditItems] as bool? ?? false,
                    );
                    final canEnableMatches = canUpdateItems && editItemsEnabled;

                    return SettingSwitch(
                      label: 'Allow matches and quick matches',
                      settingKey: SettingKeys.serverManagementAllowMatchesQuickMatches,
                      userId: canUpdateItems ? currentUser.id : null,
                      defaultValue: false,
                      enabled: canEnableMatches,
                      description: 'Allows using the match, quick match and preview match features',
                      disabledReason: canUpdateItems ? 'Enable "Edit items" first' : 'Requires edit-item permission',
                    );
                  },
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
