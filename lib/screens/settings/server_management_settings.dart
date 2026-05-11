import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/server_management_preferences.dart';
import 'package:yaabsa/util/setting_key.dart';

class ServerManagementSettings extends ConsumerWidget {
  const ServerManagementSettings({super.key});

  static const String routeName = '/settings/server-management';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);
    ref.watch(userSettingsWatcherProvider);

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

            final preferences = readServerManagementPreferences(ref, currentUser.id);
            final canUpdateItems = currentUser.permissions.update;
            final canDeleteItems = currentUser.permissions.delete;
            final canEnableMatches = canUpdateItems && preferences.editItemsEnabled;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingSwitch(
                  label: 'Collections',
                  description: 'Show add-to-collection actions and collection action menus (edit/delete/create).',
                  settingKey: SettingKeys.serverManagementCollections,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: true,
                  enabled: canUpdateItems,
                  disabledReason: canUpdateItems ? null : 'Requires edit-item permission.',
                ),
                SettingSwitch(
                  label: 'Delete items',
                  description: 'Show delete-item actions in item menus and bulk selection.',
                  settingKey: SettingKeys.serverManagementDeleteItems,
                  userId: canDeleteItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canDeleteItems,
                  disabledReason: canDeleteItems ? null : 'Requires delete-item permission.',
                ),
                SettingSwitch(
                  label: 'Edit items',
                  description: 'Show item editing actions for this user.',
                  settingKey: SettingKeys.serverManagementEditItems,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canUpdateItems,
                  disabledReason: canUpdateItems ? null : 'Requires edit-item permission.',
                ),
                SettingSwitch(
                  label: 'Edit chapters',
                  description: 'Show chapter editing actions for this user.',
                  settingKey: SettingKeys.serverManagementEditChapters,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: true,
                  enabled: canUpdateItems,
                  disabledReason: canUpdateItems ? null : 'Requires edit-item permission.',
                ),
                SettingSwitch(
                  label: 'Allow matches and quick matches',
                  description: 'Show matching tools that require edit-item permission.',
                  settingKey: SettingKeys.serverManagementAllowMatchesQuickMatches,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canEnableMatches,
                  disabledReason: canUpdateItems ? 'Enable "Edit items" first.' : 'Requires edit-item permission.',
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
