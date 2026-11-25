import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class ServerManagementSettings extends ConsumerWidget {
  const ServerManagementSettings({super.key});

  static const String routeName = '/settings/server-management';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return SettingsPageScaffold(
      title: context.l10n.settingServerManagement,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        currentUserAsync.when(
          data: (currentUser) {
            if (currentUser == null) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(context.l10n.promptSignInToManageSettings),
              );
            }

            final canUpdateItems = currentUser.permissions.update;
            final canDeleteItems = currentUser.permissions.delete;
            final canUploadItems = currentUser.permissions.upload;
            final appDatabase = ref.watch(appDatabaseProvider);

            return SettingsNavigationSection(
              title: context.l10n.headingPermissionVisibility,
              topPadding: 0,
              settings: [
                SettingSwitchTile(
                  label: context.l10n.permissionCollections,
                  settingKey: SettingKeys.serverManagementCollections,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: true,
                  enabled: canUpdateItems,
                  subtitle: context.l10n.permissionCollectionsDescription,
                  disabledReason: canUpdateItems ? null : context.l10n.permissionRequiresEditItems,
                ),
                SettingSwitchTile(
                  label: context.l10n.permissionEditItems,
                  settingKey: SettingKeys.serverManagementEditItems,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canUpdateItems,
                  subtitle: context.l10n.permissionEditItemsDescription,
                  disabledReason: canUpdateItems ? null : context.l10n.permissionRequiresEditItems,
                ),
                SettingSwitchTile(
                  label: context.l10n.permissionDeleteItems,
                  settingKey: SettingKeys.serverManagementDeleteItems,
                  userId: canDeleteItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canDeleteItems,
                  subtitle: context.l10n.permissionDeleteItemsDescription,
                  disabledReason: canDeleteItems ? null : context.l10n.permissionRequiresDeleteItems,
                ),
                SettingSwitchTile(
                  label: context.l10n.permissionEditChapters,
                  settingKey: SettingKeys.serverManagementEditChapters,
                  userId: canUpdateItems ? currentUser.id : null,
                  defaultValue: true,
                  enabled: canUpdateItems,
                  subtitle: context.l10n.permissionEditChaptersDescription,
                  disabledReason: canUpdateItems ? null : context.l10n.permissionRequiresEditItems,
                ),
                SettingSwitchTile(
                  label: context.l10n.permissionUpload,
                  settingKey: SettingKeys.serverManagementUploadItems,
                  userId: canUploadItems ? currentUser.id : null,
                  defaultValue: false,
                  enabled: canUploadItems,
                  subtitle: context.l10n.permissionUploadDescription,
                  disabledReason: canUploadItems ? null : context.l10n.permissionRequiresUpload,
                ),
                StreamBuilder<UserSettingEntry?>(
                  stream: appDatabase.watchUserSetting(currentUser.id, SettingKeys.serverManagementEditItems),
                  builder: (context, snapshot) {
                    final editItemsEnabled = SettingsParser.decodeValue<bool>(
                      snapshot.data?.value,
                      defaultSettings[SettingKeys.serverManagementEditItems] as bool? ?? false,
                    );
                    final canEnableMatches = canUpdateItems && editItemsEnabled;

                    return SettingSwitchTile(
                      label: context.l10n.permissionMatches,
                      settingKey: SettingKeys.serverManagementAllowMatchesQuickMatches,
                      userId: canUpdateItems ? currentUser.id : null,
                      defaultValue: false,
                      enabled: canEnableMatches,
                      subtitle: context.l10n.permissionMatchesDescription,
                      disabledReason: canUpdateItems
                          ? context.l10n.promptEnableSettingFirst(context.l10n.permissionEditItems)
                          : context.l10n.permissionRequiresEditItems,
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: YaabsaCircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              context.l10n.errorOperationFailed(context.l10n.operationLoadUser, error.toString()),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
