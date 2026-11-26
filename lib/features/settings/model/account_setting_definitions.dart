import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/util/setting_key.dart';

String _decodeAndroidAutoLibrarySort(String raw) {
  if (const {'title', 'author', 'added'}.contains(raw)) {
    return raw;
  }

  return 'title';
}

String _decodeAndroidAutoPodcastSort(String raw) {
  if (const {'title', 'author', 'added'}.contains(raw)) {
    return raw;
  }

  return 'added';
}

class AccountSettingDefs {
  const AccountSettingDefs._();

  static const libraryGridScale = SettingDefinition<double>(
    key: SettingKeys.libraryGridScale,
    scope: SettingScope.app,
    defaultValue: 1.0,
  );

  static const collapseSeries = SettingDefinition<bool>(
    key: SettingKeys.collapseSeries,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const refreshProgressOnAppResume = SettingDefinition<bool>(
    key: SettingKeys.refreshProgressOnAppResume,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const personalizedShelfShowPlayVisibleButton = SettingDefinition<bool>(
    key: SettingKeys.personalizedShelfShowPlayVisibleButton,
    scope: SettingScope.app,
    defaultValue: false,
  );

  static const showShuffleButton = SettingDefinition<bool>(
    key: SettingKeys.showShuffleButton,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const androidAutoGroupByLetters = SettingDefinition<bool>(
    key: SettingKeys.androidAutoGroupByLetters,
    scope: SettingScope.account,
    defaultValue: true,
  );

  static const androidAutoLibrarySortDescending = SettingDefinition<bool>(
    key: SettingKeys.androidAutoLibrarySortDescending,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const androidAutoLibrarySortField = SettingDefinition<String>(
    key: SettingKeys.androidAutoLibrarySortField,
    scope: SettingScope.account,
    defaultValue: 'title',
    decode: _decodeAndroidAutoLibrarySort,
  );

  static const androidAutoPodcastSortDescending = SettingDefinition<bool>(
    key: SettingKeys.androidAutoPodcastSortDescending,
    scope: SettingScope.account,
    defaultValue: true,
  );

  static const androidAutoPodcastSortField = SettingDefinition<String>(
    key: SettingKeys.androidAutoPodcastSortField,
    scope: SettingScope.account,
    defaultValue: 'added',
    decode: _decodeAndroidAutoPodcastSort,
  );

  static const serverManagementCollections = SettingDefinition<bool>(
    key: SettingKeys.serverManagementCollections,
    scope: SettingScope.account,
    defaultValue: true,
  );

  static const serverManagementEditItems = SettingDefinition<bool>(
    key: SettingKeys.serverManagementEditItems,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const serverManagementDeleteItems = SettingDefinition<bool>(
    key: SettingKeys.serverManagementDeleteItems,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const serverManagementEditChapters = SettingDefinition<bool>(
    key: SettingKeys.serverManagementEditChapters,
    scope: SettingScope.account,
    defaultValue: true,
  );

  static const serverManagementUploadItems = SettingDefinition<bool>(
    key: SettingKeys.serverManagementUploadItems,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const serverManagementAllowMatchesQuickMatches = SettingDefinition<bool>(
    key: SettingKeys.serverManagementAllowMatchesQuickMatches,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const toolsRemoveAuthorsWithoutBooks = SettingDefinition<bool>(
    key: SettingKeys.toolsRemoveAuthorsWithoutBooks,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const toolsForceMetadataRefresh = SettingDefinition<bool>(
    key: SettingKeys.toolsForceMetadataRefresh,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const toolsMatchAudiobookChapters = SettingDefinition<bool>(
    key: SettingKeys.toolsMatchAudiobookChapters,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const toolsSplitGenresTags = SettingDefinition<bool>(
    key: SettingKeys.toolsSplitGenresTags,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const toolsRenameSeries = SettingDefinition<bool>(
    key: SettingKeys.toolsRenameSeries,
    scope: SettingScope.account,
    defaultValue: false,
  );

  static const toolsDeleteLongListeningSessions = SettingDefinition<bool>(
    key: SettingKeys.toolsDeleteLongListeningSessions,
    scope: SettingScope.account,
    defaultValue: false,
  );
}
