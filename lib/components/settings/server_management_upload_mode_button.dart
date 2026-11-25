import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_button.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/l10n.dart';

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
        final l10n = context.l10n;
        String? disabledReason;
        if (!canUploadItems) {
          disabledReason = l10n.messageUploadPermissionRequired;
        } else if (!uploadItemsEnabled) {
          disabledReason = l10n.messageEnableUploadActionsFirst;
        } else if (!hasSelectedLibrary) {
          disabledReason = l10n.messageSelectLibraryBeforeUpload;
        }

        return SettingButton(
          label: l10n.headingUploadMode,
          description: enabled ? null : disabledReason,
          buttonText: l10n.actionOpen,
          buttonIcon: Icons.cloud_upload_outlined,
          onPressed: enabled ? onPressed : null,
        );
      },
    );
  }
}
