import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
            ? 'Requires upload permission.'
            : !uploadItemsEnabled
            ? 'Enable "Upload items" first.'
            : !hasSelectedLibrary
            ? 'Select a library before opening upload mode.'
            : null;

        return SettingButton(
          label: 'Open upload',
          description: enabled
              ? null
              : disabledReason ?? 'Upload mode requires upload permission and enabled upload actions.',
          buttonText: 'Open',
          buttonIcon: Icons.cloud_upload_outlined,
          onPressed: enabled ? onPressed : null,
        );
      },
    );
  }
}
