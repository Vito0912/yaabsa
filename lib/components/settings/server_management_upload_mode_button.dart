import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/components/settings/settings_button.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';

class ServerManagementUploadModeButton extends ConsumerWidget {
  const ServerManagementUploadModeButton({
    super.key,
    required this.userId,
    required this.canUploadItems,
    required this.hasSelectedLibrary,
    required this.onPressed,
  });

  final String userId;
  final bool canUploadItems;
  final bool hasSelectedLibrary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appDatabase = ref.watch(appDatabaseProvider);

    return StreamBuilder<UserSettingEntry?>(
      stream: appDatabase.watchUserSetting(userId, SettingKeys.serverManagementUploadItems),
      builder: (context, snapshot) {
        final uploadItemsEnabled = SettingsParser.decodeValue<bool>(
          snapshot.data?.value,
          defaultSettings[SettingKeys.serverManagementUploadItems] as bool? ?? false,
        );
        final enabled = canUploadItems && uploadItemsEnabled && hasSelectedLibrary;
        final disabledReason = !canUploadItems
            ? S.current.componentsSettingsServerManagementUploadModeButtonRequiresUploadPermission
            : !uploadItemsEnabled
            ? S.current.componentsSettingsServerManagementUploadModeButtonEnableUploadItemsFirst
            : !hasSelectedLibrary
            ? S.current.componentsSettingsServerManagementUploadModeButtonSelectLibraryBeforeOpeningUploadMode
            : null;

        return SettingButton(
          label: S.current.componentsSettingsServerManagementUploadModeButtonOpenUpload,
          description: enabled
              ? null
              : disabledReason ??
                    S
                        .current
                        .componentsSettingsServerManagementUploadModeButtonUploadModeRequiresUploadPermissionAndEnabledUploadActions,
          buttonText: S.current.componentsSettingsServerManagementUploadModeButtonOpen,
          buttonIcon: Icons.cloud_upload_outlined,
          onPressed: enabled ? onPressed : null,
        );
      },
    );
  }
}
