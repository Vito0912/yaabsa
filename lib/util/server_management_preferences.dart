import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';

class ServerManagementPreferences {
  final bool collectionsEnabled;
  final bool deleteItemsEnabled;
  final bool editItemsEnabled;
  final bool editChaptersEnabled;
  final bool allowMatchesQuickMatchesEnabled;

  const ServerManagementPreferences({
    required this.collectionsEnabled,
    required this.deleteItemsEnabled,
    required this.editItemsEnabled,
    required this.editChaptersEnabled,
    required this.allowMatchesQuickMatchesEnabled,
  });
}

ServerManagementPreferences readServerManagementPreferences(WidgetRef ref, String? userId) {
  final settingsManager = ref.read(settingsManagerProvider.notifier);

  bool readBool(String key, bool fallbackDefault) {
    final defaultValue = defaultSettings[key] as bool? ?? fallbackDefault;
    if (userId == null) {
      return defaultValue;
    }

    return settingsManager.getUserSetting<bool>(userId, key, defaultValue: defaultValue);
  }

  return ServerManagementPreferences(
    collectionsEnabled: readBool(SettingKeys.serverManagementCollections, true),
    deleteItemsEnabled: readBool(SettingKeys.serverManagementDeleteItems, false),
    editItemsEnabled: readBool(SettingKeys.serverManagementEditItems, false),
    editChaptersEnabled: readBool(SettingKeys.serverManagementEditChapters, true),
    allowMatchesQuickMatchesEnabled: readBool(SettingKeys.serverManagementAllowMatchesQuickMatches, false),
  );
}
